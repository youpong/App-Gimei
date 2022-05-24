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

sub parse_option {
    my ($self, $args_ref, $opts_ref) = @_;

    $opts_ref->{n} = 1;
    $opts_ref->{sep} = ', ';

    my $p = Getopt::Long::Parser->new(
        config => [ "no_ignore_case" ],
    );

    local $SIG{__WARN__} = sub { die "$_[0]" };
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
            push @results, execute_arg($arg, $name, $address);
        }

        say join $opts{sep}, @results;
    }
}

# ARG:                   [WORD_TYPE] [':' WORD_SUB_TYPE] [':' RENDERING]
# WORD_TYPE:             'name'       | 'address'
# WORD_SUBTYPE(name):    'family'     | 'given'
# WORD_SUBTYPE(address): 'prefecture' | 'city'     | 'town'
# RENDERING:             'kanji'      | 'hiragana' | 'katakana' | 'romaji'
sub execute_arg {
    my ($arg, $name, $address) = @_;

    my @tokens = split /:/, $arg;

    my $word;
    my $token = shift @tokens || 'name';
    # WORD_TYPE(default: 'name')
    if ($token eq 'name') {
        $word = $name;             # WORD_TYPE = 'name'

        $token = shift @tokens || '';
        if ($token eq 'family' || $token eq 'given') {
            $word = $word->$token; # WORD_SUBTYPE(name)
        } else {
            unshift @tokens, $token;
        }
    } elsif ($token eq 'address') {
        $word = $address;          # WORD_TYPE = 'address'

        $token = shift @tokens || '';
        if ($token eq 'prefecture' || $token eq 'city' || $token eq 'town') {
            $word = $word->$token; # WORD_SUBTYPE(address)
        } else {
            unshift @tokens, $token;
        }
    } else {
        say "Error: unknown word_type";  exit 2;
    }

    # RENDERING(default: 'kanji')
    $token = shift @tokens ||  "kanji";
    my $call = $word->can($token) or say "Error: unkown rendering";
    return $word->$call();
}

1;
