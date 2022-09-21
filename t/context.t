use warnings;
use v5.22;

use App::Gimei::Context;
use Test::More;

my @args = ("name-kanji", "addres:city:hiragana");
my $context = App::Gimei::Context->new(@args);
say $context->to_s;
