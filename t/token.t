use v5.36;

use App::Gimei::Token qw($TK_NAME $TK_MALE $TK_FEMALE $TK_ADDRESS
    $TK_FAMILY $TK_GIVEN $TK_PREFECTURE $TK_CITY $TK_TOWN
    $TK_KANJI $TK_HIRAGANA $TK_KATAKANA $TK_ROMAJI
    $TK_END $TK_UNKNOWN);
use Test::More;

{
    my @array = ($TK_NAME, $TK_MALE, $TK_FEMALE, $TK_ADDRESS,
        $TK_FAMILY, $TK_GIVEN, $TK_PREFECTURE, $TK_CITY, $TK_TOWN,
        $TK_KANJI, $TK_HIRAGANA, $TK_KATAKANA, $TK_ROMAJI,
        $TK_END, $TK_UNKNOWN);

    @array = sort {$a <=> $b} @array;
    my $prev = shift(@array);
    foreach my $curr (@array) {
        isnt $prev, $curr;
        $prev = $curr;
    }
}

done_testing();
