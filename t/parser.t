use v5.40;

use App::Gimei::Parser;

use Test2::V1 -utf8;
use Test2::Tools::Spec;
use Test2::Tools::Exception qw/dies/;

describe "App::Gimei::Parser" => sub {

    it "parse(): no args" => sub {
        my @args   = ();
        my $parser = App::Gimei::Parser->new( args => \@args );
        my @gs     = $parser->parse->to_list;

        T2->is( scalar @gs, 0, "contains no generator" );
    };

    it "_parse_arg(): word_type(name|male|female)" => sub {
        my @args = ( 'name', 'male', 'female' );

        my $parser = App::Gimei::Parser->new( args => \@args );
        my @gs     = $parser->parse()->to_list;

        T2->is( scalar @gs,         3, "contains 3 generator" );
        T2->is( $gs[0]->word_class, 'Data::Gimei::Name' );
        T2->is( $gs[0]->gender,     undef );
        T2->is( $gs[1]->word_class, 'Data::Gimei::Name' );
        T2->is( $gs[1]->gender,     'male' );
        T2->is( $gs[2]->word_class, 'Data::Gimei::Name' );
        T2->is( $gs[2]->gender,     'female' );
    };

    it "_parse_arg(): word_type(address)" => sub {
        my @args = ('address');

        my $parser = App::Gimei::Parser->new( args => \@args );
        my @gs     = $parser->parse()->to_list;

        T2->is( scalar @gs,         1 );
        T2->is( $gs[0]->word_class, 'Data::Gimei::Address' );
    };

    it "_parse_arg(): unknown word_type" => sub {
        my @args   = ('unknown');
        my $parser = App::Gimei::Parser->new( args => \@args );
        T2->like( dies { $parser->parse() }, qr/unknown word_type/ );
    };

    it "_parse_arg(): unknown subtype/rendering" => sub {
        my $parser;
        $parser = App::Gimei::Parser->new( args => ['name:unknown'] );
        T2->like( dies { $parser->parse() }, qr/unknown subtype/ );

        $parser = App::Gimei::Parser->new( args => ['name:family:unknown'] );
        T2->like( dies { $parser->parse() }, qr/unknown rendering/ );
    };

    it "_subtype_name()" => sub {
        my @args = (
            'name:family', 'name:last', 'name:given', 'name:first',
            'name:gender', 'name:sex',  'name:kanji', 'name'
        );

        my $parser = App::Gimei::Parser->new( args => \@args );
        my @gs     = $parser->parse()->to_list;

        T2->is( scalar @gs,           8 );
        T2->is( $gs[0]->word_subtype, 'surname' );
        T2->is( $gs[1]->word_subtype, 'surname' );
        T2->is( $gs[2]->word_subtype, 'forename' );
        T2->is( $gs[3]->word_subtype, 'forename' );
        T2->is( $gs[4]->word_subtype, 'gender' );
        T2->is( $gs[5]->word_subtype, 'gender' );
        T2->is( $gs[6]->word_subtype, undef );
        T2->is( $gs[7]->word_subtype, undef );
    };

    it "_subtype_address()" => sub {
        my @args = (
            'address:prefecture', 'address:city',
            'address:town',       'address:kanji',
            'address'
        );
        my $parser = App::Gimei::Parser->new( args => \@args );
        my @gs     = $parser->parse->to_list;

        T2->is( scalar @gs,           5 );
        T2->is( $gs[0]->word_subtype, 'prefecture' );
        T2->is( $gs[1]->word_subtype, 'city' );
        T2->is( $gs[2]->word_subtype, 'town' );
        T2->is( $gs[3]->word_subtype, undef );
        T2->is( $gs[4]->word_subtype, undef );
    };

    it "_rendering(): " => sub {
        my @args =
          ( 'name:kanji', 'name:hiragana', 'name:katakana', 'name:romaji', 'name' );
        my $parser = App::Gimei::Parser->new( args => \@args );
        my @gs     = $parser->parse->to_list;

        T2->is( scalar @gs,        5 );
        T2->is( $gs[0]->rendering, 'kanji' );
        T2->is( $gs[1]->rendering, 'hiragana' );
        T2->is( $gs[2]->rendering, 'katakana' );
        T2->is( $gs[3]->rendering, 'romaji' );
        T2->is( $gs[4]->rendering, 'kanji' );
    };
};

T2->done_testing;
