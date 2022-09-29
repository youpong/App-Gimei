use warnings;
use v5.34;

use App::Gimei::Context;
use Test::More;

{
    my @args = ("name:family-kanji");
    my $context = App::Gimei::Context->new(@args);

    is $context->next_token(), "name";
    is $context->next_token(), "family";
    is $context->next_token(), "kanji";
    is $context->next_token(), ':'; # end of arg
    is $context->next_token(), '-'; # end of args
}

{ # step_back
    my @args = ("name:kanji");
    my $context = App::Gimei::Context->new(@args);

    is $context->next_token(), "name";
    is $context->next_token(), "kanji";
    $context->step_back();
    is $context->next_token(), "kanji";
    is $context->next_token(), ':'; # end of arg
    is $context->next_token(), '-'; # end of args
}

{
    my @args = ("name", "address");
    my $context = App::Gimei::Context->new(@args);

    is $context->next_token(), "name";
    is $context->next_token(), ':'; # end of arg

    is $context->next_token(), "address";
    is $context->next_token(), ':'; # end of arg

    is $context->next_token(), '-'; # end of args
}

{ # 0 arsg
    my @args = ();
    my $context = App::Gimei::Context->new(@args);
    is $context->next_token(), 'name';
    is $context->next_token(), ':'; # end of arg
    is $context->next_token(), '-'; # end of args
}

done_testing;
