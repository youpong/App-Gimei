package App::Gimei::Runner;

use strict; use warnings;
use v5.22;

use Getopt::Long;
use Data::Gimei;

use Class::Tiny {
    #verbose => undef,
};

sub execute {
    my @args = @_;

    my $p = Getopt::Long::Parser->new(
        config => [ "no_ignore_case" ],
    );

    $p->getoptions(
        #"h|help" => 
    );

    #    push @commands, @ARGV;

    say "okay";
}
1;
