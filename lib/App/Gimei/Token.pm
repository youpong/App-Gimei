use v5.36;

package App::Gimei::Token;

use Exporter 'import';
our @EXPORT_OK = qw($TK_NAME $TK_MALE $TK_FEMALE $TK_ADDRESS
    $TK_FAMILY $TK_GIVEN $TK_PREFECTURE $TK_CITY $TK_TOWN
    $TK_KANJI $TK_HIRAGANA $TK_KATAKANA $TK_ROMAJI
    $TK_END $TK_UNKNOWN);

my $iota = 0xF500_0000;

our $TK_NAME = ++$iota;
our $TK_MALE = ++$iota;
our $TK_FEMALE = ++$iota;
our $TK_ADDRESS = ++$iota;

our $TK_FAMILY = ++$iota;
our $TK_GIVEN = ++$iota;

our $TK_PREFECTURE = ++$iota;
our $TK_CITY = ++$iota;
our $TK_TOWN = ++$iota;

our $TK_KANJI = ++$iota;
our $TK_HIRAGANA = ++$iota;
our $TK_KATAKANA = ++$iota;
our $TK_ROMAJI = ++$iota;

our $TK_END = ++$iota;
our $TK_UNKNOWN = ++$iota;

1;