use v5.36;

package App::Gimei::Parser;

use App::Gimei::Token qw($TK_NAME $TK_MALE $TK_FEMALE $TK_ADDRESS
    $TK_FAMILY $TK_LAST $TK_GIVEN $TK_FIRST $TK_GENDER $TK_SEX
    $TK_PREFECTURE $TK_CITY $TK_TOWN
    $TK_KANJI $TK_HIRAGANA $TK_KATAKANA $TK_ROMAJI
    $TK_END $TK_UNKNOWN);
use App::Gimei::Generator;
use App::Gimei::Generators;

use Class::Tiny qw ( tokens );

sub parse ($self) {
    my $generators = App::Gimei::Generators->new();

    while (@{$self->tokens}) {   
        $generators->push( $self->parse_stmt() );
    }

    return $generators;
}

# BNF-like notation
#
# ARG:          [WORD_TYPE] [':' RENDERING] TK_END
#
# WORD_TYPE:　     TYPE_NAME [':' SUBTYPE_NAME] | TYPE_ADDRESS [':' SUBTYPE_ADDRESS ]
# TYPE_NAME:       TK_NAME    | TK_MALE   | TK_FEMALE
# SUBTYPE_NAME:    TK_FAMILY  | TK_GIVEN
# TYPE_ADDRESS:    TK_ADDRESS
# SUBTYPE_ADDRESS: TK_PREFECTURE | TK_CITY | TK_TOWN
#
# RENDERING:    TK_KANJI | TK_HIRAGANA | TK_KATAKANA | TK_ROMAJI
# (DO NOT support romaji rendering for type address)
sub parse_stmt ($self) {
    my ( $gen, %params );

    my $token = shift @{$self->tokens};
    # say "stmt: " . $token->type;
    if ( $token->type == $TK_NAME || $token->type == $TK_MALE || $token->type == $TK_FEMALE ) { # TYPE_NAME
        $params{word_class} = "Data::Gimei::Name";
        if ( $token->type == $TK_MALE ) {
            $params{gender} = 'male';
        } elsif ( $token->type == $TK_FEMALE ) {
            $params{gender} = 'female';
        }
        $params{word_subtype} = $self->subtype_name();
        # say "word_subtype: ". $params{word_subtype};
    } elsif ( $token->type == $TK_ADDRESS ) { # TYPE_ADDRESS
        $params{word_class}   = "Data::Gimei::Address";
        $params{word_subtype} = $self->subtype_address();
    } else {
        die "Error: unknown word_type: $token->name\n";
    }

    $params{rendering} = $self->rendering();
    # if ( !$ok ) {
    #     if ( defined $params{word_subtype} ) {
    #         die "Error: unknown rendering: $rendering\n";
    #     } else {
    #         die "Error: unknown subtype or rendering: $rendering\n";
    #     }
    # }
    # $params{rendering} = $rendering;

    $token = shift(@{$self->tokens});
    #say "72: " . $token;
    if ($token->type != $TK_END) {
        die "Error: expect TK_END but got: $token->type\n";
    }

    return App::Gimei::Generator->new(%params);
}

sub subtype_name ($self) {
    my $token = shift(@{$self->tokens});
    #say "subtype_name: " . $token;
    if ($token->type == $TK_FAMILY || $token->type == $TK_LAST) {
        return 'surname';
    } elsif ($token->type == $TK_GIVEN || $token->type == $TK_FIRST) {
        return 'forename';
    } elsif ($token->type == $TK_GENDER || $token->type == $TK_SEX) {
        return 'gender';
    } 

    unshift(@{$self->tokens}, $token);
    return undef;
}

sub subtype_address ($self) {
    my $token = shift(@{$self->tokens});
    if ( $token->type == $TK_PREFECTURE) {
        return 'prefecture';
    } elsif ($token->type == $TK_CITY) {
        return 'city';
    } elsif ($token->type == $TK_TOWN) {
        return 'town';
    }

    unshift(@{$self->tokens}, $token);
    return undef;
}

sub rendering ($self) {
    my $token = shift(@{$self->tokens});
    #say "rendering: " . $token;
    if ($token->type == $TK_KANJI ) {
        return 'kanji';
    } elsif ($token->type == $TK_HIRAGANA) {
        return 'hiragana';
    } elsif ($token->type == $TK_KATAKANA) {
        return 'katakana';
    } elsif ($token->type == $TK_ROMAJI) {
        return 'romaji';
    } 
    
    unshift(@{$self->tokens}, $token);       
    return 'kanji'; 
}

1;
