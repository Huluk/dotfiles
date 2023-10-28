use v6;

# needs: zef install Grammar::Debugger
# use Grammar::Tracer;

grammar Command {
  token TOP { <cmd>+ }

  proto token cmd {*}
        token cmd:sym<help> { 'h' }
        token cmd:sym<amend> { 'a' }
        token cmd:sym<evolve> { 'e' }
        token cmd:sym<status> { 's' }
        token cmd:sym<sync> { 'y' }
        token cmd:sym<long_history> { 'l' }
        token cmd:sym<short_history> { 'x' }
        token cmd:sym<diff> { 'd' <arg> }
        token cmd:sym<checkout> { 'c' <arg> }
        token cmd:sym<upload> { 'u' <arg> }

  rule arg { ^^ <word> $$ }
  token word { \S+ }

  # Special arguments
  # TODO use
  # TODO add cl, commit hash
  rule parent { 'parent' }
  rule tree { 'tree' }
}

class Execute {
  method TOP ($/) { make map { .made }, @<cmd>; }
  method arg ($/) { make $<word>; }
  # TODO populate help output
  method cmd:sym<help> ($/) { make ('echo', 'Help output'); }
}

class MercurialExecute is Execute {
  sub exec(*@args) {
    'chg', |@args;
  }

  method cmd:sym<amend> ($/) { make exec <amend>; }
  method cmd:sym<evolve> ($/) { make exec <evolve>; }
  method cmd:sym<status> ($/) { make exec <status>; }
  method cmd:sym<sync> ($/) { make exec <sync>; }
  method cmd:sym<long_history> ($/) { make exec <ll>; }
  method cmd:sym<short_history> ($/) { make exec <xl>; }
  method cmd:sym<upload_tree> ($/) { make exec <upload tree>; }

  method cmd:sym<diff> ($/) { make exec <diff -r>, $<arg>; }
  method cmd:sym<checkout> ($/) { make exec <checkout>, $<arg>; }
  method cmd:sym<upload> ($/) { make exec <upload>, $<arg>; }
}

sub MAIN(
  $cmd,  #= One or more letters representing a command. Use 'h' for help.
  *@args #= Arguments
) {
  # cmd is a separate argument to enforce that a command is passed.
  @args.unshift($cmd);
  # TODO \n is problematic as it may be used for commit messages
  my $args = join '\n', map @args;
  my $parsed = Command.parse($args, actions => MercurialExecute);
  die 'Failed to parse input!' if not $parsed;
  for $parsed.made -> @cmd {
    run @cmd;
  }
}
