package App::Gimei::Context;

use warnings;
use v5.34;

use Class::Tiny qw ( index tokens );

sub BUILDARGS {
    my ( $class, @cl_args ) = @_;

    my @tokens;
    foreach my $arg (@cl_args) {
        push @tokens, split( /[-:]/, $arg), ':';
    }
    push @tokens, '-';

    return { tokens => \@tokens };
}

sub next_token {
    my $self = shift;

    my $index = $self->{index}++;
    return $self->{tokens}[$index];
}

sub step_back {
    my $self = shift;

    $self->{index}--;
}

# TODO need?
sub consume_token {
    my ( $self, $token ) = @_;

    $self->{index}++;
}

sub to_s {
    my $self = shift;

    $self->{index}++;
    say $self->index;
    foreach my $token (@{$self->tokens}) {
        say $token;
    }
}
1;
