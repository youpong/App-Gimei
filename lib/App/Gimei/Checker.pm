package App::Gimei::Checker;

use warnings;
use v5.34;

use App::Gimei;
use Data::Gimei;

use Class::Tiny qw (
    irs
);

sub BUILDARGS {
    my ( $class, @irs ) = @_;

    return { irs => \@irs };
}

sub check {
    my $self = shift;

    foreach my $ir (@{$self->irs}) {
        if ($ir->{type} eq 'address' && $ir->{rendering} eq 'romaji') {
             die "Error: unknown subtype or rendering: romaji\n";
        }
    }
    return undef;
}
1;
