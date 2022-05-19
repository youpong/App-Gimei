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

    my $p = Getopt::Long::Parser->new(
        config => [ "no_ignore_case" ],
    );

    $p->getoptions(
        #"h|help" => 
    );

    #    push @commands, @ARGV;

    foreach (1..1) {
        my $name = Data::Gimei::Name->new();
        my $address = Data::Gimei::Address->new();

        foreach my $arg (@args) {
            my @tokens = split /:/, $arg;

            my $obj;
            if (!$tokens[0] || $tokens[0] eq 'name') {
                $obj = $name;
            } elsif ($tokens[0] eq 'address') {
                $obj = $address;
            } else {
                # Error: unknown word_type
            }
            my $call = $obj->can($tokens[1] // "kanji"); # or Error: unkown ...
            say $obj->$call();
        }
    }
}
1;
