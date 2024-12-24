use v5.38;

use App::Gimei::Generator;
use Test2::Bundle::More;

# test caching
{
    my $cache = {};
    my $g     = App::Gimei::Generator->new( word_class => "Data::Gimei::Name" );

    my $previous = $g->execute($cache);

    is $g->execute($cache), $previous;
}

# test gender('')
{
    my %params = ( word_class => 'Data::Gimei::Name' );
    my $g      = App::Gimei::Generator->new(%params);
    is $g->gender, undef;
}

# test gender('male')
{
    my $cache  = {};
    my %params = (
        word_class   => 'Data::Gimei::Name',
        word_subtype => 'gender',
        gender       => 'male'
    );
    my $g      = App::Gimei::Generator->new(%params);
    my $gender = $g->execute($cache);

    is $g->gender(), 'male';
    is $gender,      'male';
}

done_testing();
