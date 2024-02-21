use v5.36;

use App::Gimei::Token qw($TK_NAME $TK_MALE $TK_FEMALE $TK_ADDRESS
    $TK_FAMILY $TK_LAST $TK_GIVEN $TK_FIRST $TK_GENDER $TK_SEX
    $TK_PREFECTURE $TK_CITY $TK_TOWN
    $TK_KANJI $TK_HIRAGANA $TK_KATAKANA $TK_ROMAJI
    $TK_END $TK_UNKNOWN);
use Test::More;

{ # Each variable should have unique value
    my @array = ($TK_NAME, $TK_MALE, $TK_FEMALE, $TK_ADDRESS,
        $TK_FAMILY, $TK_LAST, $TK_GIVEN, $TK_FIRST, $TK_GENDER, $TK_SEX,
        $TK_PREFECTURE, $TK_CITY, $TK_TOWN,
        $TK_KANJI, $TK_HIRAGANA, $TK_KATAKANA, $TK_ROMAJI,
        $TK_END, $TK_UNKNOWN);

    my $prev = 0;
    foreach my $curr (sort @array) {
        isnt $prev, $curr;
        $prev = $curr;
    }
}

{ # check generation an object
    my $token = App::Gimei::Token->new(type => $TK_UNKNOWN, name => 'unknown');
    
    is $token->type, $TK_UNKNOWN;
    is $token->name, 'unknown';
}

done_testing();
