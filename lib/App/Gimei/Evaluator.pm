package App::Gimei::Evaluator;

use warnings;
use v5.34;

use App::Gimei;
use Data::Gimei;

use Class::Tiny qw( irs name address );

sub BUILDARGS {
    my ($class, @irs) = @_;

    return { irs => \@irs };
}

sub evaluate {
    my $self = shift;

    my @results;
    foreach my $ir (@{$self->irs}) {
        push @results, $self->evaluate1($ir);
    }
    return @results;
}

sub evaluate1 {
    my ($self, $ir) = @_;

    my ( $word, $result );

    if ( $ir->{type} eq 'name' ) {
        $self->{name} //= Data::Gimei::Name->new();
        $word = $self->name;
    } elsif ( $ir->{type} eq 'address' ) {
        $self->{address} //= Data::Gimei::Address->new();
        $word = $self->address;
    }

    if ( $ir->{sub_type} eq 'family' ) {
        $word =  $word->family;
    } elsif ( $ir->{sub_type} eq 'given' ) {
        $word = $word->given;
    } elsif ( $ir->{sub_type} eq 'gender') {
        $word = $word->gender;
    } elsif ( $ir->{sub_type} eq 'prefecture' ) {
        $word = $word->prefecture;
    } elsif ( $ir->{sub_type} eq 'city' ) {
        $word = $word->city;
    } elsif ( $ir->{sub_type} eq 'town' ) {
        $word = $word->town;
    }

    if ( $ir->{sub_type} eq 'gender' ) {
        $result = $word;
    } elsif ( $ir->{rendering} eq 'kanji') {
        $result = $word->kanji;
    } elsif ( $ir->{rendering} eq 'hiragana' ) {
        $result = $word->hiragana;
    } elsif ( $ir->{rendering} eq 'katakana' ) {
        $result = $word->katakana;
    } elsif ( $ir->{rendering} eq 'romaji' ) {
        $result = $word->romaji;
    }

    return $result;
}

sub to_s {
    my $self = shift;

    return "{ type => '" . $self->type .
        "', sub_type => '" . $self->sub_type .
        "', rendering => '" . $self->rendering . "' }";
}
1;
