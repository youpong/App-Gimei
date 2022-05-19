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
            #say join ',', @tokens;
            my $result;
            if ($tokens[0] eq 'name') {
                # say $tokens[1];
                my $call = $name->can($tokens[1]);
                $result = $name->$call();
                #$result = $name->$tokens[1]();
            }
            say $result;
        }
    }
}
1;
