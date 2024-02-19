use v5.36;

package App::Gimei::Tokenizer;

use App::Gimei::Token qw($TK_NAME $TK_MALE $TK_FEMALE $TK_ADDRESS
    $TK_FAMILY $TK_LAST $TK_GIVEN $TK_FIRST $TK_GENDER $TK_SEX
    $TK_PREFECTURE $TK_CITY $TK_TOWN
    $TK_KANJI $TK_HIRAGANA $TK_KATAKANA $TK_ROMAJI
    $TK_END $TK_UNKNOWN);
use App::Gimei::Generator;
use App::Gimei::Generators;

use Class::Tiny qw ( args );

# $self->args: ('name:kanji', 'address')
# returns: (TK_NAME, TK_KANJI, TK_END, TK_ADDRESS, TK_END)
# TODO: utf-8
sub tokenize($self) {
    my %map = ( 
        name => $TK_NAME,
        male => $TK_MALE,
        female => $TK_FEMALE, 
        address => $TK_ADDRESS,
        family => $TK_FAMILY,
        last => $TK_LAST,
        given => $TK_GIVEN,
        first => $TK_FIRST,
        gender => $TK_GENDER,
        sex => $TK_SEX,
        prefecture => $TK_PREFECTURE,
        city => $TK_CITY,
        town => $TK_TOWN,
        kanji => $TK_KANJI,  
        hiragana => $TK_HIRAGANA,
        katakana => $TK_KATAKANA,
        romaji => $TK_ROMAJI,
    );

    my @result;

    foreach my $arg (@{$self->args}) {
        my @tokens = split(/[-:]/, $arg);
        foreach my $token (@tokens) {
            push(@result, $map{$token} // $TK_UNKNOWN);
        }
        push(@result, $TK_END);
    }
    return \@result;
}
1;