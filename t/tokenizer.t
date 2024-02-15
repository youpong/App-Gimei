use v5.36;

use App::Gimei::Token qw($TK_NAME $TK_MALE $TK_FEMALE $TK_ADDRESS
    $TK_FAMILY $TK_GIVEN $TK_PREFECTURE $TK_CITY $TK_TOWN
    $TK_KANJI $TK_HIRAGANA $TK_KATAKANA $TK_ROMAJI
    $TK_END $TK_UNKNOWN);
use App::Gimei::Tokenizer;
use Test::More;

# test
{
    my $args = ['name:kanji', 'address'];
    # say $$args[0];
    my $t = App::Gimei::Tokenizer->new( args => $args );

    my $tokens = $t->tokenize();

    is_deeply($tokens, 
        [$TK_NAME, $TK_KANJI, $TK_END, $TK_ADDRESS, $TK_END]);
    #say App::Gimei::Tokenizer::TK_NAME;
    #NG say Tokenizer::TK_NAME;
    #is_deeply([1], [$t->TK_NAME]);

    #is_deeply($tokens, [TK_NAME]);
    #is $g->execute($cache), $previous;
}

done_testing();
