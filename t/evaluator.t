use warnings;
use v5.34;
binmode STDOUT, ":utf8";

use App::Gimei::Context;
use App::Gimei::Parser;
use App::Gimei::Evaluator;

use Test::More;

{
    my $ir = {type => 'name', sub_type => 'full',   rendering=>'kanji'};
    my $evaluator = App::Gimei::Evaluator->new($ir);

    say $evaluator->to_s();
    say $evaluator->evaluate();
}

{
    my $ir = {type => 'name', sub_type => 'family',   rendering=>'kanji'};
    my $evaluator = App::Gimei::Evaluator->new($ir);

    say $evaluator->to_s();
    say $evaluator->evaluate();
}

done_testing;
