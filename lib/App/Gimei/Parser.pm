use v5.36;

package App::Gimei::Parser;

use App::Gimei::Generator;
use App::Gimei::Generators;

sub parse_args (@args) {
    my $generators = App::Gimei::Generators->new();

    foreach my $arg (@args) {
        $generators->push(parse_arg($arg));
    }

    return $generators;
}

# ARG:                            [WORD_TYPE] [':' WORD_SUB_TYPE] [':' RENDERING]
# WORD_TYPE:                      'name' | 'male' | 'female' | 'address'
# WORD_SUBTYPE(name|male|female): 'family'     | 'given'
# WORD_SUBTYPE(address):          'prefecture' | 'city'     | 'town'
# RENDERING:                      'kanji'      | 'hiragana' | 'katakana' | 'romaji'
sub parse_arg ($arg) {
    my ( $gen, @tokens, %params );

    @tokens = split( /[-:]/, $arg );

    my $token = shift @tokens;
    if ( $token eq 'name' || $token eq 'male' || $token eq 'female' ) {
        $params{word_class} = "Data::Gimei::Name";
        if ( $token ne 'name' ) {
            $params{gender} = $token;
        }
        $params{word_subtype} = subtype_name( \@tokens );
    } elsif ( $token eq 'address' ) {
        $params{word_class}   = "Data::Gimei::Address";
        $params{word_subtype} = subtype_address( \@tokens );
    } else {
        die "Error: unknown word_type: $token\n";
    }

    my ( $ok, $render ) = render( \@tokens );
    if ( !$ok ) {
        if ( defined $params{word_subtype} ) {
            die "Error: unknown rendering: $render\n";
        } else {
            die "Error: unknown subtype or rendering: $render\n";
        }
    }
    $params{render} = $render;

    return App::Gimei::Generator->new(%params);
}

sub subtype_name ($tokens_ref) {
    my ($word_subtype);

    my %map = (
        'family' => 'surname',
        'last'   => 'surname',
        'given'  => 'forename',
        'first'  => 'forename',
        'gender' => 'gender',
        'sex'    => 'gender',
    );

    my $token = @$tokens_ref[0] // '';
    if ( $word_subtype = $map{$token} ) {
        shift @$tokens_ref;
    }

    return $word_subtype;
}

sub subtype_address ($tokens_ref) {
    my ($word_subtype);

    my $token = @$tokens_ref[0] // '';
    if ( $token eq 'prefecture' || $token eq 'city' || $token eq 'town' ) {
        shift @$tokens_ref;
        $word_subtype = $token;
    }

    return $word_subtype;
}

sub render ($tokens_ref) {
    my $status = '';

    my $token = @$tokens_ref[0];
    if (   !defined $token
        || $token eq 'kanji'
        || $token eq 'hiragana'
        || $token eq 'katakana'
        || $token eq 'romaji' )
    {
        $status = 'ok';
    }

    return ( $status, $token );
}

1;
