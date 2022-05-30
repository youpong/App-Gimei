package App::Gimei::Runner;

use strict; use warnings;
use v5.22;
binmode STDOUT, ":utf8";

use Getopt::Long;

use App::Gimei;
use Data::Gimei;

use Class::Tiny;# qw( test );

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

    if ($opts_ref->{n} < 1) {
        die "Error: value $opts_ref->{n} invalid for option n (must be positive number)\n";
    }
}

sub execute {
    my ($self, @args) = @_;

    my %opts;
    $self->parse_option(\@args, \%opts);

    if ($opts{version}) {
        say "$App::Gimei::VERSION";
        return 0;
    }

    if ($opts{help}) {
        system "perldoc", "App::Gimei";
        return 0;
    }

    if (!@args) {
        push @args, 'name:kanji';
    }

    foreach (1 .. $opts{n}) {
        my %words = ( name    => Data::Gimei::Name->new(),
                      male    => Data::Gimei::Name->new(gender => 'male'),
                      female  => Data::Gimei::Name->new(gender => 'female'),
                      address => Data::Gimei::Address->new() );

        my @results;
        foreach my $arg (@args) {
            my @tokens = split(/[-:]/, $arg);
            push @results, execute_tokens(\@tokens, \%words);
        }

        say join $opts{sep}, @results;
    }

    return 0;
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
    my ($tokens_ref, $words_ref ) = @_;
    my ($word_type, $word, $token);

    $token = shift @$tokens_ref;
    if ($token eq 'name' || $token eq 'male' || $token eq 'female') {
        $word_type = 'name';
        $word = subtype_name($tokens_ref, $words_ref->{$token});
    } elsif ($token eq 'address') {
        $word_type = 'address';
        $word = subtype_address($tokens_ref, $words_ref->{$token});
    } else {
        die "Error: unknown word_type: $token\n";
    }

    return render($tokens_ref, $word_type, $word);
}

sub subtype_name {
    my ($tokens_ref, $word) = @_;
    my ($token, $subtype, $call, $method);

    my %map = ( 'family' => 'family',
                'last'   => 'family',
                'given'  => 'given',
                'first'  => 'given' );

    $token = @$tokens_ref[0] // '';
    if ($method = $map{$token} ) {
        shift @$tokens_ref;
        $call = $word->can($method) or die "system err";
        $word = $word->$call();
    }

    return $word;
}

sub subtype_address {
    my ($tokens_ref, $word) = @_;

    my $token = @$tokens_ref[0] // '';
    if ($token eq 'prefecture' || $token eq 'city' || $token eq 'town') {
        shift @$tokens_ref;
        my $call = $word->can($token);
        die "system error" if (!$call);
        $word = $word->$call();
    }

    return $word;
}

# romaji not supported in WORD_TYPE = 'address'
sub render {
    my ($tokens_ref, $word_type, $word) = @_;

    my $token = @$tokens_ref[0];
    if (!$token || $token eq 'name') {
        $token = "kanji";
    }

    if ( $token eq 'romaji' &&
         $word_type eq 'address' ) {
        die "Error: unknown subtype or rendering: $token\n";
    }

    my $call = $word->can($token);
    die "Error: unknown subtype or rendering: $token\n" if (!$call);

    return  $word->$call();
}

1;
