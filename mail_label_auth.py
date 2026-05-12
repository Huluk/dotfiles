#!/usr/bin/env python3
# ============================================================
# auth.py — run once PER GMAIL ACCOUNT to authorize Gmail API
# access. Stores refresh token in macOS Keychain, keyed by the
# Gmail address so multiple accounts can coexist.
#
# Usage:
#   python3 auth.py --account you@gmail.com \
#       --client-id YOUR_ID --client-secret YOUR_SECRET
# ============================================================

import argparse
import json
import subprocess
from google_auth_oauthlib.flow import InstalledAppFlow

SCOPES       = ["https://www.googleapis.com/auth/gmail.modify"]
KEYCHAIN_SERVICE = "maillabels"


def keychain_account(gmail_address):
    return f"gmail_refresh_token_{gmail_address}"


def save_to_keychain(service, account, value):
    # Delete existing entry first (ignore error if not found)
    subprocess.run(
        ["security", "delete-generic-password", "-s", service, "-a", account],
        capture_output=True
    )
    subprocess.run(
        ["security", "add-generic-password",
         "-s", service, "-a", account, "-w", value],
        check=True
    )


def main():
    parser = argparse.ArgumentParser(description="Authorize Gmail API access")
    parser.add_argument("--account",       required=True,
                         help="Gmail address being authorized, e.g. you@gmail.com")
    parser.add_argument("--client-id",     required=True)
    parser.add_argument("--client-secret", required=True)
    args = parser.parse_args()

    client_config = {
        "installed": {
            "client_id":     args.client_id,
            "client_secret": args.client_secret,
            "redirect_uris": ["urn:ietf:wg:oauth:2.0:oob", "http://localhost"],
            "auth_uri":  "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
        }
    }

    flow = InstalledAppFlow.from_client_config(client_config, SCOPES)
    creds = flow.run_local_server(port=0)

    # Store all three values needed for token refresh as JSON
    payload = json.dumps({
        "client_id":     args.client_id,
        "client_secret": args.client_secret,
        "refresh_token": creds.refresh_token,
    })
    save_to_keychain(KEYCHAIN_SERVICE, keychain_account(args.account), payload)
    print(f"Done! Credentials for {args.account} saved to Keychain.")


if __name__ == "__main__":
    main()
