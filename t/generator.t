use warnings;
use v5.22;

use App::Gimei::Generator;
use Test::More;

# test caching
{
    my $cache = {};
    my $g = App::Gimei::Generator->new(word_class => "Data::Gimei::Name");
    
    my $previous = $g->execute($cache);
    
    is $g->execute($cache), $previous;
}

done_testing();

