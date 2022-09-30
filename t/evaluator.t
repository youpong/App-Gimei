use warnings;
use v5.34;
binmode STDOUT, ":utf8";

use App::Gimei::Context;
use App::Gimei::Parser;
use App::Gimei::Evaluator;

use Test::More;

{
    my @irs = ({type => 'name', sub_type => 'full',   rendering=>'kanji'});
    my $evaluator = App::Gimei::Evaluator->new(@irs);

    say $evaluator->evaluate();
}

{
    my @irs = ({type => 'name', sub_type => 'family',   rendering=>'kanji'});
    my $evaluator = App::Gimei::Evaluator->new(@irs);

    say $evaluator->evaluate();
}

{
    my @args = ("name");
    my $context = App::Gimei::Context->new(@args);
    my $parser = App::Gimei::Parser->new($context);
    my @irs = $parser->parse();

    foreach my $ir (@irs) {
        my $evaluator = App::Gimei::Evaluator->new($ir);

        say $evaluator->evaluate();
    }
}

ok 1;
done_testing;
