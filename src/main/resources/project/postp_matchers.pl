@::gMatchers = (
  {
   id =>        "kw-compiling",
   pattern =>          q{Compiling },
   action =>           q{incValueWithString("kw-compiles", "Compiled 0 sources");updateSummary();},
  },
  {
   id =>        "kw-analyzing",
   pattern =>          q{Analyzing },
   action =>           q{incValueWithString("kw-analyze", "Analyzed 0 objects");updateSummary();},
  },
  #file or directory not found
  {
    id =>       "kwinject-fatal-error",
    pattern =>         q{kwinject FATAL:},
    action =>          q{incValueWithString("kwinject-fatal-error", "0 Kwinject fatal error(s)");updateSummary();},
  },
  #project created
  {
    id =>       "create-project",
    pattern =>         q{Project (.*) created.},
    action =>          q{&addSimpleError("create-project","Project $1 created.");updateSummary();},
  },
  #project deleted
  {
    id =>       "delete-project",
    pattern =>         q{Project (.*) deleted.},
    action =>          q{&addSimpleError("delete-project","Project $1 deleted.");updateSummary();},
  },
  #project already exists
  {
    id =>       "already-existing-project",
    pattern =>         q{Project (.*) already exists},
    action =>          q{&addSimpleError("already-existing-project","Project $1 already exists.");updateSummary();},
  },
  #Unrecognized option
  {
    id =>       "unrecognized-option",
    pattern =>         q{Unrecognized option (.*)},
    action =>          q{&addSimpleError("unrecognized-option","Unrecognized option $1");updateSummary();},
  },
  #Unknown Language
  {
    id =>       "unknown-language",
    pattern =>         q{unknown language (.*) Supported (languages are:(.*))},
    action =>          q{&addSimpleError("unknown-language","unknown language $1 Supported languages are: $3");updateSummary();},
  },
);

sub addSimpleError {
    my ($name, $customError) = @_;
    if(!defined $::gProperties{$name}){
        setProperty ($name, $customError);
    }
}

sub incValueWithString($;$$) {
    my ($name, $patternString, $increment) = @_;

    $increment = 1 unless defined($increment);

    my $localString = (defined $::gProperties{$name}) ? $::gProperties{$name} :
                                                        $patternString;

    $localString =~ /([^\d]*)(\d+)(.*)/;
    my $leading = $1;
    my $numeric = $2;
    my $trailing = $3;
    
    $numeric += $increment;
    $localString = $leading . $numeric . $trailing;

    setProperty ($name, $localString);
}

sub updateSummary() {
    my $summary = "";
	$summary .= (defined $::gProperties{"kw-compiles"}) ? $::gProperties{"kw-compiles"} . "\n" : "";
	$summary .= (defined $::gProperties{"kw-analyze"}) ? $::gProperties{"kw-analyze"} . "\n" : "";
    $summary .= (defined $::gProperties{"kwinject-fatal-error"}) ? $::gProperties{"kwinject-fatal-error"} . "\n" : "";
    $summary .= (defined $::gProperties{"create-project"}) ? $::gProperties{"create-project"} . "\n" : "";
    $summary .= (defined $::gProperties{"delete-project"}) ? $::gProperties{"delete-project"} . "\n" : "";
    $summary .= (defined $::gProperties{"already-existing-project"}) ? $::gProperties{"already-existing-project"} . "\n" : "";
    $summary .= (defined $::gProperties{"unrecognized-option"}) ? $::gProperties{"unrecognized-option"} . "\n" : "";
    $summary .= (defined $::gProperties{"unknown-language"}) ? $::gProperties{"unknown-language"} . "\n" : "";
	setProperty ("summary", $summary);
}