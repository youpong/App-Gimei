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

    is_deeply($tokens, 
        [$TK_NAME, $TK_KANJI, $TK_END, $TK_ADDRESS, $TK_END]);
 
}

done_testing();
