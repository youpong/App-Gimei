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

my %conf = ( POD_FILE => pod_where( { -inc => 1 }, 'App::Gimei' ) );

#
# methods
#

sub parse_option {
    my ( $self, $args_ref, $opts_ref ) = @_;

    $opts_ref->{n}   = 1;
    $opts_ref->{sep} = ', ';

    my $p = Getopt::Long::Parser->new( config => ["no_ignore_case"], );

    local $SIG{__WARN__} = sub { die "Error: $_[0]" };
    my $ok = $p->getoptionsfromarray( $args_ref, $opts_ref, "help|h", "version|v", "n=i",
        "sep=s", );

    if ( $opts_ref->{n} < 1 ) {
        die
          "Error: value $opts_ref->{n} invalid for option n (must be positive number)\n";
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

    if ( !@args ) {
        push @args, 'name:kanji';
    }

    my @generators = parse_args( @args );

    foreach ( 1 .. $opts{n} ) {
	my ( @words, %cache );
	foreach my $g (@generators) {
	    push @words, $g->execute( \%cache );
	}
        say join $opts{sep}, @words;
    }

    return 0;
}

#
# functions ...
#

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
