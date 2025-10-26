use v6;

# needs: zef install Grammar::Debugger
# use Grammar::Tracer;

constant $ARGUMENT_SEPARATOR = "\0";

grammar Command {
  token TOP { <command> + }

  token sep { $ARGUMENT_SEPARATOR }

  token command { <cmd> <.sep>? }
  proto token cmd {*}
        token cmd:sym<help> { 'h' }
        token cmd:sym<amend> { 'a' }
        token cmd:sym<evolve> { 'e' }
        token cmd:sym<status> { 's' }
        token cmd:sym<sync> { 'y' }
        token cmd:sym<print> { 'p' }
        token cmd:sym<long_history> { 'l' }
        token cmd:sym<short_history> { 'x' }
        token cmd:sym<diff> { [ <sym> | 'd' ] <.sep> <arg> }
        token cmd:sym<checkout> { [ <sym> | 'c' ] <.sep> <arg> }
        token cmd:sym<commit> { [ <sym> | 'm' ] <.sep> <arg> }
        token cmd:sym<upload> { [ <sym> | 'u' ] <.sep> <arg> }
        token cmd:sym<upload_tree> { 'ut' }

  proto token arg {*}
        token arg:sym<interactive> { '-i' }
        token arg:sym<parent> { <sym> }
        token arg:sym<child> { <sym> }
        token arg:sym<head> { <sym> }
        token arg:sym<exported> { <sym> | 'upstream' | 'origin' | 'remote' }
        token arg:sym<sibling> { [ <sym> | 'sib' ] <int_> }
        token arg:sym<any> { <{ "<-[$ARGUMENT_SEPARATOR]>" }>+ }

  token int_ { \-?\d+ }
}

class Cmd {
  has Str @cmd is built;
  has Bool $say is built;

  method new(*@cmd, Bool :$say = False) {
    return self.bless(:@cmd, :$say);
  }

  method run {
    @cmd.duckmap(-> $_ where /\s/.any { "'$_'" }).join(' ').say if $say;
    return run @cmd, |%_;
  }
}

class Execute {
  method TOP ($/) { make map { .made }, @<command>; }
  method command ($/) { make $<cmd>.made; }
  method arg:sym<any> ($/) { make $/.Str; }
  # TODO populate help output
  method cmd:sym<help> ($/) { make ('echo', 'Help output'); }
}

class MercurialExecute is Execute {
  sub exec(*@args, Bool :$say = False) {
    Cmd.new('chg', |@args) :$say;
  }

  method detect returns Bool { exec(<root>).run(:out, :err).so }

  sub read-log(:$rev, *@nodes) {
    my $nodes = join '\t', map { "\{$_\}" }, @nodes;
    my $cmd = exec qqw[log -T $nodes\\n -r $rev];
    my $proc = $cmd.run :out;
    my @lines = $proc.out.slurp(:close).chomp.split("\n");
    return map { .split("\t") }, @lines;
  }

  method arg:sym<parent> ($/) { make <p1(p1())>; }
  method arg:sym<child> ($/) { make <children(p1())>; } # TODO error-handling
  method arg:sym<head> ($/) { make <p4head>; } # TODO work-specific
  method arg:sym<exported> ($/) { make <exported(.)>; } # TODO work-specific
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
  method cmd:sym<print> ($/) {
    make exec qww|id -T '{clpreferredname}: {desc}' -r.|;
  }
  method cmd:sym<long_history> ($/) { make exec <ll>; }
  method cmd:sym<short_history> ($/) { make exec <xl>; }
  method cmd:sym<upload_tree> ($/) { make exec <upload tree>; }

  method cmd:sym<diff> ($/) { make exec <diff -r>, $<arg>.made; }
  method cmd:sym<checkout> ($/) { make exec <checkout>, $<arg>.made, :say; }
  method cmd:sym<upload> ($/) { make exec <upload>, $<arg>.made; }
  method cmd:sym<commit> ($/) { make exec <commit -m>, $<arg>.made, :say; }
}

class GitExecute is Execute {
  sub exec(*@args, Bool :$say = False) {
    Cmd.new('git', |@args) :$say;
  }

  method arg:sym<head> ($/) { make <HEAD>; }

  method detect returns Bool {
    return exec(<rev-parse --show-toplevel>).run(:out, :err).so;
  }

  method cmd:sym<amend> ($/) { make exec <add --all>; }
  method cmd:sym<status> ($/) { make exec <status>; }

  method cmd:sym<upload> ($/) { make exec <push>, $<arg>.made; }
  method cmd:sym<commit> ($/) { make exec <commit -m>, $<arg>.made, :say; }
}

class JjExecute is Execute {
  # Currently assumes git backing.

  sub exec(*@args, Bool :$say = False) {
    Cmd.new('jj', |@args) :$say;
  }

  method arg:sym<head> ($/) { make Nil; }
  method arg:sym<parent> ($/) { make <@->; }
  method arg:sym<child> ($/) { make <@-+ & ~@>; } # TODO untested
  # method arg:sym<sibling> ($/) {
    # helper: jj log -T commit_id --no-graph -r 'visible_heads() & ~@'
    # make ;
  # }
  # method arg:sym<exported> ($/) { }

  method detect returns Bool {
    return exec(<root>).run(:out, :err).so;
  }

  method cmd:sym<amend> ($/) { make exec <squash>; }
  method cmd:sym<evolve> ($/) { make exec <rebase --interactive>; }
  method cmd:sym<status> ($/) { make exec <status>; }
  method cmd:sym<sync> ($/) { make exec <git fetch>; }
  method cmd:sym<print> ($/) {
    make exec <log -r @- -n1 --no-graph -T description>;
  }
  method cmd:sym<long_history> ($/) { make exec <log -r ::>; }
  method cmd:sym<short_history> ($/) { make exec <log>; }
  method cmd:sym<upload_tree> ($/) { make exec <git push -c @>; }

  method cmd:sym<diff> ($/) {
    my $arg = $<arg>.made;
    make ($arg ?? exec <diff -r>, $arg !! exec <diff>);
  }
  method cmd:sym<checkout> ($/) { make exec <new>, $<arg>.made, :say; }
  method cmd:sym<upload> ($/) { make exec <git push -r>, $<arg>.made; }
  method cmd:sym<commit> ($/) { make exec <commit -m>, $<arg>.made, :say; }
}

sub MAIN(
  $cmd,  #= One or more letters representing a command. Use 'h' for help.
  *@args #= Arguments
) {
  # cmd is a separate argument to enforce that a command is passed.
  @args.unshift($cmd);
  my $args = join $ARGUMENT_SEPARATOR, @args;
  my $is-mercurial = MercurialExecute.detect;
  my $is-git = GitExecute.detect;
  my $is-jj = JjExecute.detect;
  if not ($is-mercurial or $is-git or $is-jj) {
    die 'No version control detected.';
  }
  # jj takes precedence because it may use the other systems as a backend.
  if $is-mercurial and $is-git and not $is-jj {
    die 'Multiple version control systems detected. No idea what to do.';
  }
  my $executor = $is-jj ?? JjExecute
    !! ($is-git ?? GitExecute !! MercurialExecute);
  my $parsed = Command.parse(
    $args,
    actions => $executor
  );
  die 'Failed to parse input!' if not $parsed;
  for $parsed.made -> $cmd {
    $cmd.run;
  }
}
