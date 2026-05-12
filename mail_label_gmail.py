#!/usr/bin/env python3
# ============================================================
# gmail.py — called by MailLabels.applescript via do shell script
#
# Usage:
#   python3 gmail.py clear-labels <gmail-address> <message-id>
#   python3 gmail.py assign-label <gmail-address> <message-id> <label-name>
#   python3 gmail.py remove-label <gmail-address> <message-id> <label-name>
#
# <gmail-address> selects which account's stored OAuth credentials
# to use (see auth.py), since multiple Gmail accounts may be
# configured.
#
# assign-label removes all existing Labels/* labels before adding
# the new one, ensuring only one label is ever set at a time.
# ============================================================

import json
import subprocess
import sys
import urllib.request
import urllib.parse

KEYCHAIN_SERVICE = "maillabels"
LABELS_PREFIX    = "Labels/"


def keychain_account(gmail_address):
    return f"gmail_refresh_token_{gmail_address}"


def load_from_keychain(service, account):
    result = subprocess.run(
        ["security", "find-generic-password", "-s", service, "-a", account, "-w"],
        capture_output=True, text=True, check=True
    )
    return json.loads(result.stdout.strip())


def get_access_token(client_id, client_secret, refresh_token):
    data = urllib.parse.urlencode({
        "client_id":     client_id,
        "client_secret": client_secret,
        "refresh_token": refresh_token,
        "grant_type":    "refresh_token",
    }).encode()
    req = urllib.request.Request(
        "https://oauth2.googleapis.com/token",
        data=data,
        method="POST"
    )
    try:
        with urllib.request.urlopen(req) as r:
            return json.loads(r.read())["access_token"]
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", "replace")
        raise SystemExit(f"Token refresh failed ({e.code}): {body}")


def gmail_request(method, path, token, body=None):
    url = f"https://gmail.googleapis.com/gmail/v1/users/me/{path}"
    data = json.dumps(body).encode() if body else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Authorization", f"Bearer {token}")
    req.add_header("Content-Type", "application/json")
    with urllib.request.urlopen(req) as r:
        return json.loads(r.read())


def get_all_labels(token):
    """Return a dict of label name -> label id for all labels."""
    result = gmail_request("GET", "labels", token)
    return {l["name"]: l["id"] for l in result.get("labels", [])}


def get_label_id(all_labels, label_name):
    """Find label id by bare name or Labels/ prefixed name."""
    if label_name in all_labels:
        return all_labels[label_name]
    prefixed = LABELS_PREFIX + label_name
    if prefixed in all_labels:
        return all_labels[prefixed]
    return None


def get_message_label_ids(token, gmail_id):
    """Return the list of label IDs currently on a message."""
    result = gmail_request("GET", f"messages/{gmail_id}?format=minimal", token)
    return result.get("labelIds", [])


def find_gmail_id(token, imap_message_id):
    clean_id = imap_message_id.strip("<>")
    query = urllib.parse.quote(f"rfc822msgid:{clean_id}")
    result = gmail_request("GET", f"messages?q={query}", token)
    messages = result.get("messages", [])
    if not messages:
        raise ValueError(f"Message not found: {imap_message_id}")
    return messages[0]["id"]


def main():
    if len(sys.argv) < 4:
        print("Usage: gmail.py <assign-label|remove-label> <gmail-address> <message-id> <label-name>")
        print("       gmail.py clear-labels <gmail-address> <message-id>")
        sys.exit(1)

    action       = sys.argv[1]
    gmail_address = sys.argv[2]
    message_id   = sys.argv[3]
    label_name   = sys.argv[4] if len(sys.argv) > 4 else None

    if action in ("assign-label", "remove-label") and label_name is None:
        print(f"{action} requires a label name", file=sys.stderr)
        sys.exit(1)

    token_data   = load_from_keychain(KEYCHAIN_SERVICE, keychain_account(gmail_address))
    access_token = get_access_token(
        token_data["client_id"],
        token_data["client_secret"],
        token_data["refresh_token"],
    )

    all_labels = get_all_labels(access_token)
    gmail_id   = find_gmail_id(access_token, message_id)

    label_id = None
    if label_name is not None:
        label_id = get_label_id(all_labels, label_name)
        if label_id is None:
            print(f"Label not found: {label_name}", file=sys.stderr)
            sys.exit(1)

    if action == "remove-label":
        gmail_request("POST", f"messages/{gmail_id}/modify", access_token, {
            "removeLabelIds": [label_id]
        })
        print(f"Removed label '{label_name}'")

    elif action == "assign-label":
        # Find all Labels/* labels currently on this message,
        # EXCLUDING the one being assigned: putting the same id in
        # removeLabelIds and addLabelIds of one modify call is at
        # best undefined and can net out to the label being removed.
        current_label_ids = get_message_label_ids(access_token, gmail_id)
        labels_prefix_ids = [
            lid for name, lid in all_labels.items()
            if name.startswith(LABELS_PREFIX)
            and lid in current_label_ids
            and lid != label_id
        ]

        # Build a single API call: remove old Labels/* labels, add new one
        gmail_request("POST", f"messages/{gmail_id}/modify", access_token, {
            "removeLabelIds": labels_prefix_ids,
            "addLabelIds":    [label_id]
        })
        removed = [n for n, i in all_labels.items() if i in labels_prefix_ids]
        print(f"Removed {removed}, added label '{label_name}'")

    elif action == "clear-labels":
        # Strip ALL Labels/* labels from the message in one call.
        # Used by MailLabels "archive": the AppleScript doesn't need
        # to know which label(s) the message carries.
        current_label_ids = get_message_label_ids(access_token, gmail_id)
        labels_prefix_ids = [
            lid for name, lid in all_labels.items()
            if name.startswith(LABELS_PREFIX) and lid in current_label_ids
        ]
        if labels_prefix_ids:
            gmail_request("POST", f"messages/{gmail_id}/modify", access_token, {
                "removeLabelIds": labels_prefix_ids
            })
        removed = [n for n, i in all_labels.items() if i in labels_prefix_ids]
        print(f"Cleared labels {removed}")

    else:
        print(f"Unknown action: {action}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
