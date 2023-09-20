package App::Gimei::Parser;

use warnings;
use v5.22;

use App::Gimei;
use Class::Tiny;

sub parse_args {
    my ( @args ) = @_;
    my @generators;
    
    foreach my $arg (@args) {
	push @generators, parse_arg($arg);
    }

    return @generators;
}

# ARG:                            [WORD_TYPE] [':' WORD_SUB_TYPE] [':' RENDERING]
# WORD_TYPE:                      'name' | 'male' | 'female' | 'address'
# WORD_SUBTYPE(name|male|female): 'family'     | 'given'
# WORD_SUBTYPE(address):          'prefecture' | 'city'     | 'town'
# RENDERING:                      'kanji'      | 'hiragana' | 'katakana' | 'romaji'
sub parse_arg {
    my ( $arg ) = @_;
    my ( $gen, @tokens );

    @tokens = split( /[-:]/, $arg );
    
    my $token = shift @tokens;
    if ( $token eq 'name' || $token eq 'male' || $token eq 'female' ) {
	$gen = App::Gimei::Generator->new( word_class => "Data::Gimei::Name" );
	my $gender = $token;
	if ( $gender eq 'name' ) {
	    $gender = 'default';
	}
	$gen->gender( $gender );
        $gen->word_subtype( subtype_name( \@tokens ) );
    } elsif ( $token eq 'address' ) {
	$gen = App::Gimei::Generator->new( word_class => "Data::Gimei::Address" );
        $gen->word_subtype( subtype_address( \@tokens ) );
    } else {
        die "Error: unknown word_type: $token\n";
    }

    $gen->render( render( \@tokens ) );

    return $gen;
}

sub subtype_name {
    my ( $tokens_ref ) = @_;
    my ( $word_subtype );

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

sub subtype_address {
    my ( $tokens_ref ) = @_;
    my ( $word_subtype );
    
    my $token = @$tokens_ref[0] // '';
    if ( $token eq 'prefecture' || $token eq 'city' || $token eq 'town' ) {
        shift @$tokens_ref;
	$word_subtype = $token;
    }

    return $word_subtype;
}

# romaji not supported in WORD_TYPE = 'address'
sub render {
    my ( $tokens_ref ) = @_;
    my $render = 'kanji';
    
    my $token = @$tokens_ref[0] // '';
    if ( $token ) {
	$render = $token;
    }
    if ( $token eq 'name' ) {
        $render = "kanji";
    }

    return $render;
}

1;
