package App::Gimei::Context;

use warnings;
use v5.22;

use Class::Tiny qw ( tokens );

sub BUILDARGS {
    my ( $class, @cl_args ) = @_;

    my @tokens;
    foreach my $arg (@cl_args) {
        push @tokens, split( /[-:]/, $arg);
    }

    return { tokens => \@tokens };
}

sub next_token {
    my $self = shift;

    $self->{index}++;
    return $self->token_at($self->{index});
    $self->{tokens}
}

sub token_at {
    my ( $self, $index )  = @_;

    return $self->{tokens}[$index];
}

sub consume_token {
}

sub to_s {
    my $self = shift;

    foreach my $token (@{$self->tokens}) {
        say $token;
    }
    #my $tokens_ref = $self->tokens;
    #say $tokens_ref;
    #return $self->{tokens};
}
1;
