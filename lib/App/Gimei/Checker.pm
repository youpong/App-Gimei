package App::Gimei::Checker;

use warnings;
use v5.34;

use App::Gimei;
use Data::Gimei;

use Class::Tiny;

sub check {
    my ( $self, @irs ) = @_;

    foreach my $ir (@irs) {
        if ($ir->{type} eq 'address' && $ir->{rendering} eq 'romaji') {
             die "Error: unknown subtype or rendering: romaji\n";
        }
    }
    return undef;
}
1;
