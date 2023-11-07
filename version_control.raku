use v6;

# needs: zef install Grammar::Debugger
# use Grammar::Tracer;

constant $ARGUMENT_SEPARATOR = "\0";

grammar Command {
  token TOP { <cmd>+ }

  token sep { $ARGUMENT_SEPARATOR }

  proto token cmd {*}
        token cmd:sym<help> { 'h' }
        token cmd:sym<amend> { 'a' }
        token cmd:sym<evolve> { 'e' }
        token cmd:sym<status> { 's' }
        token cmd:sym<sync> { 'y' }
        token cmd:sym<long_history> { 'l' }
        token cmd:sym<short_history> { 'x' }
        token cmd:sym<diff> { 'd' <.sep> <arg> }
        token cmd:sym<checkout> { 'c' <.sep> <arg> }
        token cmd:sym<commit> { [ <sym> | 'm' ] <.sep> <arg> }
        token cmd:sym<upload> { 'u' <.sep> <arg> }

  proto token arg {*}
        token arg:sym<parent> { <sym> }
        token arg:sym<sibling> { [ <sym> | 'sib' ] <int_> }
        token arg:sym<any> { <:!sep>+ }

  token int_ { \-?\d+ }
}

class Cmd {
  has Str @cmd is built;
  has Bool $say is built;

  method new(*@cmd, Bool :$say = False) {
    return self.bless(:@cmd, :$say);
  }

  method run {
    say @cmd.join(' ') if $say;
    return run @cmd, |%_;
  }
}

class Execute {
  method TOP ($/) { make map { .made }, @<cmd>; }
  method arg:sym<any> ($/) { make $/; }
  # TODO populate help output
  method cmd:sym<help> ($/) { make ('echo', 'Help output'); }
}

class MercurialExecute is Execute {
  sub exec(*@args, Bool :$say = False) {
    Cmd.new('chg', |@args) :$say;
  }

  sub read-log(:$rev, *@nodes) {
    my $nodes = join '\t', map { "\{$_\}" }, @nodes;
    my $cmd = exec qqw[log -T $nodes\\n -r $rev];
    my $proc = $cmd.run :out;
    my @lines = $proc.out.slurp(:close).chomp.split("\n");
    return map { .split("\t") }, @lines;
  }

  method arg:sym<parent> ($/) { make <p1(p1())>; }
  method arg:sym<sibling> ($/) {
    my @heads = reverse read-log <graphnode short(node)>, rev => 'heads(smart)';
    my $current = @heads.first: /^\@/, :k;
    if not $current.defined {
      my $heads = join "\n", map { .join(' – ') }, @heads;
      die "Current commit not found among {@heads.Int} heads:\n$heads";
    }
    my ($, $sibling) = @heads[$current + $<int_>];
    die "Sibling $<int_> not found for current head $current" if not $sibling;
    make $sibling.subst(/^.\t/);
  }

  method cmd:sym<amend> ($/) { make exec <amend>; }
  method cmd:sym<evolve> ($/) { make exec <evolve>; }
  method cmd:sym<status> ($/) { make exec <status>; }
  method cmd:sym<sync> ($/) { make exec <sync>; }
  # TODO ll and xl are work-specific
  method cmd:sym<long_history> ($/) { make exec <ll>; }
  method cmd:sym<short_history> ($/) { make exec <xl>; }
  method cmd:sym<upload_tree> ($/) { make exec <upload tree>; }

  method cmd:sym<diff> ($/) { make exec <diff -r>, $<arg>.made; }
  method cmd:sym<checkout> ($/) { make exec <checkout>, $<arg>.made, :say; }
  method cmd:sym<upload> ($/) { make exec <upload>, $<arg>.made; }
  method cmd:sym<commit> ($/) { make exec <commit -m>, $<arg>.made, :say; }
}

sub MAIN(
  $cmd,  #= One or more letters representing a command. Use 'h' for help.
  *@args #= Arguments
) {
  # cmd is a separate argument to enforce that a command is passed.
  @args.unshift($cmd);
  my $args = join $ARGUMENT_SEPARATOR, @args;
  my $parsed = Command.parse($args, actions => MercurialExecute);
  die 'Failed to parse input!' if not $parsed;
  for $parsed.made -> $cmd {
    $cmd.run;
  }
}
