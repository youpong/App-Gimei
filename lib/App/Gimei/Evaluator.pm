package App::Gimei::Evaluator;

use warnings;
use v5.34;

use App::Gimei;
use Data::Gimei;

use Class::Tiny qw( type sub_type rendering );

sub evaluate {
    my $self = shift;

    my ( $word, $result );

    if ( $self->type eq 'name' ) {
        $word = Data::Gimei::Name->new();
    } elsif ( $self->type eq 'address' ) {
        $word = Data::Gimei::Address->new();
    }

    if ( $self->sub_type eq 'family' ) {
        $word =  $word->family;
    } elsif ( $self->sub_type eq 'given' ) {
        $word = $word->given;
    } elsif ( $self->sub_type eq 'gender') {
        $word = $word->gender;
    } elsif ( $self->sub_type eq 'prefecture' ) {
        $word = $word->prefecture;
    } elsif ( $self->sub_type eq 'city' ) {
        $word = $word->city;
    } elsif ( $self->sub_type eq 'town' ) {
        $word = $word->town;
    }

    if ( $self->sub_type eq 'gender' ) {
        $result = $word;
    } elsif ( $self->rendering eq 'kanji') {
        $result = $word->kanji;
    } elsif ( $self->rendering eq 'hiragana' ) {
        $result = $word->hiragana;
    } elsif ( $self->rendering eq 'katakana' ) {
        $result = $word->katakana;
    } elsif ( $self->rendering eq 'romaji' ) {
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
