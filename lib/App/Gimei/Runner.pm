package App::Gimei::Runner;

use strict; use warnings;
use v5.22;
binmode STDOUT, ":utf8";

use Getopt::Long;

use App::Gimei;
use Data::Gimei;

use Class::Tiny {
    #verbose => undef,
};

#
# methods ...
#

sub parse_option {
    my ($self, $args_ref, $opts_ref) = @_;

    $opts_ref->{n} = 1;
    $opts_ref->{sep} = ', ';

    my $p = Getopt::Long::Parser->new(
        config => [ "no_ignore_case" ],
    );

    local $SIG{__WARN__} = sub { die "Error: $_[0]" };
    my $err = $p->getoptionsfromarray(
        $args_ref,
        $opts_ref,
        "help|h",
        "version|v",
        "n=i",
        "sep=s",
    );
}

sub execute {
    my ($self, @args) = @_;

    my %opts;
    $self->parse_option(\@args, \%opts);

    if ($opts{version}) {
        say "$App::Gimei::VERSION";
        exit 0;
    }

    if ($opts{help}) {
        system "perldoc", "App::Gimei";
        exit 0;
    }

    if (!@args) {
        push @args, 'name:kanji';
    }

    foreach (1 .. $opts{n}) {
        my $name = Data::Gimei::Name->new();
        my $address = Data::Gimei::Address->new();

        my @results;
        foreach my $arg (@args) {
            my @tokens = split(/:/, $arg);
            push @results, execute_tokens(\@tokens, $name, $address);
        }

        say join $opts{sep}, @results;
    }
}

#
# functions ...
#

# ARG:                   [WORD_TYPE] [':' WORD_SUB_TYPE] [':' RENDERING]
# WORD_TYPE:             'name'       | 'address'
# WORD_SUBTYPE(name):    'family'     | 'given'
# WORD_SUBTYPE(address): 'prefecture' | 'city'     | 'town'
# RENDERING:             'kanji'      | 'hiragana' | 'katakana' | 'romaji'
sub execute_tokens {
    my ($tokens_ref, $name, $address) = @_;
    my ($word_type, $word, $token);

    $token = shift @$tokens_ref // 'name';
    if ($token eq 'name') {
        $word_type = 'name';
        $word = subtype_name($tokens_ref, $name);
    } elsif ($token eq 'address') {
        $word_type = 'address';
        $word = subtype_address($tokens_ref, $address);
    } else {
        die "Error: unknown word_type: $token\n";
    }

    return render($tokens_ref, $word_type, $word);
}

sub subtype_name {
    my ($tokens_ref, $word) = @_;

    my $token = shift @$tokens_ref // '';
    if ($token eq 'family' || $token eq 'given') {
        $word = $word->$token;
    } else {
        unshift @$tokens_ref, $token;
    }

    return $word;
}

sub subtype_address {
    my ($tokens_ref, $word) = @_;

    my $token = shift @$tokens_ref // '';
    if ($token eq 'prefecture' || $token eq 'city' || $token eq 'town') {
        $word = $word->$token;
    } else {
        unshift @$tokens_ref, $token;
    }

    return $word;
}

# romaji not supported in WORD_TYPE = 'address'
sub render {
    my ($tokens_ref, $word_type, $word) = @_;

    my $token = shift @$tokens_ref //  "kanji";
    my $call = $word->can($token);
    if (!$call ||
        ( $word_type eq 'address' && $token eq 'romaji')) {
        die "Error: unkown rendering: $token\n";
    }

    return  $word->$call();
}

1;
