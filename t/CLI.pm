package t::CLI;
use v5.36;

use App::Gimei::Runner;
use Capture::Tiny qw(capture);
use Class::Tiny   qw( stdout stderr exit_code error_message);

sub run {
    my ( $self, @args ) = @_;

    my @capture = capture {
        my $code = eval { App::Gimei::Runner->new->execute(@args) };
        if ( !$@ ) {
            $self->exit_code($code);
            $self->error_message(undef);
        } else {
            $self->exit_code(255);
            $self->error_message($@);
        }
    };

    $self->stdout( $capture[0] );
    $self->stderr( $capture[1] );
}

1;
