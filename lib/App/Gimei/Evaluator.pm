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
    }
    if ( $self->sub_type eq 'family' ) {
        $word =  $word->family;
    }
    if ( $self->rendering eq 'kanji') {
        $result = $word->kanji;
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
