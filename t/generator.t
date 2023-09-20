use warnings;
use v5.22;

use App::Gimei::Generator;
use Test::More;

{
    my $cache = {};
    my $g = App::Gimei::Generator->new(word_class => "Data::Gimei::Name");
    say $g->execute($cache);
    say $g->execute({});
    $g->word_class("foo");
    say $g->word_class;
    
}

SKIP: {
    skip "hey" if 1;
    
    my $cache = {};
    my $g = App::Gimei::Generator->new(word_class => "Data::Gimei::Name", cache => $cache);
    $g->execute;
    say $cache->{"Data::Gimei::Name"}->kanji;
};

SKIP: {
    skip; "foo" if 1;
    
    my $cache = {};
    my $g = App::Gimei::Generator->new(
	word_class => "Data::Gimei::Name",
	gender => 'male', cache => $cache);
    say $g->execute;

    $g = App::Gimei::Generator->new(
	word_class => "Data::Gimei::Name", word_subtype => 'forename',
	gender => 'male', cache => $cache);
    
    say $g->execute;

    $g = App::Gimei::Generator->new(
	word_class => "Data::Gimei::Name", word_subtype => 'forename',
	gender => 'male', cache => $cache);
    say $g->execute;
};

# {
#    my $cache = {};
#    $cache->{'name'} = Data::Gimei::Name->new();
#    my $g = App::Gimei::Generator->new(word_class => "Data::Gimei::Name", cache => $cache);
#    say $g->cache->{'name'}->kanji;
#    say "h";
    #is 1 + 1, 2;
#}

done_testing();

