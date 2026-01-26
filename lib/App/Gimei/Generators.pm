use v5.40;
use feature 'class';
no warnings 'experimental::class';

class App::Gimei::Generators {

    use Data::Gimei;

    field $body :param = [];

    method push ( $generator ) {
        CORE::push @{$body}, $generator;
    }

    method execute () {
        my ( @words, %cache );
        foreach my $g ( @{$body} ) {
            CORE::push( @words, $g->execute( \%cache ) );
        }
        return @words;
    }

    method to_list () {
        return @{$body};
    }
}

1;
