package App::Gimei::Generator;

use warnings;
use v5.22;

use Carp;
use Class::Tiny qw(
    word_class
    gender
    word_subtype
    render
    cache
);
use Data::Gimei;

sub BUILDARGS {
    my ( $class, %args ) = @_;

    for my $arg ( qw/word_class/ ) {
	croak "$arg arg required" unless exists $args{$arg};
    }

    $args{gender} //= 'default';
    $args{render} //= "kanji";
    
    return \%args;
}

sub execute {
    my ( $self, $cache ) = @_;
    my ( $word );

    my $key = $self->word_class . $self->gender;
    $word = $cache->{$key};
    if (!defined $word) {
	$word = $self->word_class->new;
	$cache->{$key} = $word;
    }
	
    if ($self->word_subtype) {
	my $call = $word->can($self->word_subtype);
	$word = $word->$call();
    }

    if ($self->render) {
	my $call = $word->can($self->render);
	$word = $word->$call();
    }

    return $word;
}

1;
