use v5.36;

use App::Gimei::Token qw($TK_NAME $TK_MALE $TK_FEMALE $TK_ADDRESS
    $TK_FAMILY $TK_LAST $TK_GIVEN $TK_FIRST $TK_GENDER $TK_SEX
    $TK_PREFECTURE $TK_CITY $TK_TOWN
    $TK_KANJI $TK_HIRAGANA $TK_KATAKANA $TK_ROMAJI
    $TK_END $TK_UNKNOWN);
use App::Gimei::Tokenizer;
use Test::More;

{
    my $args = ['name:kanji', 'address'];
    my $t = App::Gimei::Tokenizer->new( args => $args );

    my $tokens = $t->tokenize();

    my @data = ([$TK_NAME, 'name'], [$TK_KANJI, 'kanji'], [$TK_END, undef], [$TK_ADDRESS, 'address'], [$TK_END, undef]);
    foreach my $t (@data) {
        my $got = shift(@$tokens);
        is $got->type, ${$t}[0];
        is $got->name, ${$t}[1];
    }
}

done_testing();
