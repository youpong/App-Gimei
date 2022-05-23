package App::Gimei::Runner;

use strict; use warnings;
use v5.22;
binmode STDOUT, ":utf8";

use Getopt::Long;
use Data::Gimei;

use Class::Tiny {
    #verbose => undef,
};

sub execute {
    my ($self, @args) = @_;

    local @ARGV = @args;

    my $p = Getopt::Long::Parser->new(
        config => [ "no_ignore_case" ],
    );

    my $n = 1;
    my $sep = ', ';
    $p->getoptions(
                   #"h|help" =>
                   "n=i" => \$n,
                   "sep=s" => \$sep,
    );

    @args = @ARGV;

    #    push @commands, @ARGV;

    if (!@args) {
        push @args, 'name:kanji';
    }

    foreach (1..$n) {
        my $name = Data::Gimei::Name->new();
        my $address = Data::Gimei::Address->new();

        my @results;
        foreach my $arg (@args) {
            my @tokens = split /:/, $arg;

            my $word;
            my $token = shift @tokens || 'name';
            if ($token eq 'name') {
                $token = shift @tokens || '';
                if ($token eq 'family') {
                    $word = $name->family;
                } elsif ($token eq 'given') {
                    $word = $name->given;
                } else {
                    unshift @tokens, $token;
                    $word = $name;
                }
            } elsif ($token eq 'address') {
                $token = shift @tokens || '';
                if ($token eq 'prefecture') {
                    $word = $address->prefecture;
                } elsif ($token eq 'town') {
                    $word = $address->town;
                } elsif ($token eq 'city') {
                    $word = $address->city;
                } else {
                    unshift @tokens, $token;
                    $word = $address;
                }
            } else {
                say "Error: unknown word_type";  exit 2;
            }
            my $call = $word->can(shift @tokens ||  "kanji") or say "Error: unkown rendering";
            push @results, $word->$call();
        }
        say join $sep, @results;
    }
}
1;
