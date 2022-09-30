package App::Gimei::Runner;

use warnings;
use v5.22;
binmode STDOUT, ":utf8";

use Getopt::Long;
use Pod::Usage;
use Pod::Find qw( pod_where );

use App::Gimei;
use Data::Gimei;

use Class::Tiny;

#
# global vars
#

# TODO: ? -inc
my %conf = ( POD_FILE => pod_where( { -inc => 1 }, 'App::Gimei' ) );

#
# methods
#
# TODO: rename n -> ntimes
# TODO: memberize opts
sub parse_option {
    my ( $self, $args_ref, $opts_ref ) = @_;

    $opts_ref->{n}   = 1;
    $opts_ref->{sep} = ', ';

    my $p = Getopt::Long::Parser->new( config => ["no_ignore_case"], );

    local $SIG{__WARN__} = sub { die "Error: $_[0]" };
    my $ok = $p->getoptionsfromarray( $args_ref, $opts_ref, "help|h", "version|v",
                                      "n=i", "sep=s", );

    if ( $opts_ref->{n} < 1 ) {
        # TODO: multi line
        die "Error: value $opts_ref->{n} invalid for option n (must be positive number)\n";
    }
}

sub execute {
    my ( $self, @args ) = @_;

    my %opts;
    $self->parse_option( \@args, \%opts );

    if ( $opts{version} ) {
        say "$App::Gimei::VERSION";
        return 0;
    }

    if ( $opts{help} ) {
        pod2usage( -input => $conf{POD_FILE}, -exitval => 'noexit' );
        return 0;
    }

    my $context = App::Gimei::Context->new(@args);
    my $parser  = App::Gimei::Parser->new($context);


    my @irs = $parser->parse();
    my $checker = App::Gimei::Checker->new(@irs);
    $checker->check();

    my $evaluator = App::Gimei::Evaluator->new(@irs);
    foreach ( 1 .. $opts{n} ) {
        say join $opts{sep}, $evaluator->evaluate();
    }

    return 0;
}

1;
