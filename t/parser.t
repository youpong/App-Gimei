use warnings;
use v5.22;

use App::Gimei::Context;
use App::Gimei::Parser;
use Test::More;

{
    1;
#    my @args = ();
#    my $context = App::Gimei::Context->new(@args);
#    my $parser = App::Gimei::Parser->new($context);

    #say $parser->to_s;
    #my @irs = $parser->parse();
    #my $ir = $parser->parse_arg();
    
    #foreach my $ir (@irs) {
    #say %$ir;
    #}
}

{
    my @args = ();
    my $context = App::Gimei::Context->new(@args);
    my $parser = App::Gimei::Parser->new($context);
    my $ir = $parser->parse_arg();

    is $ir, undef;
}

{
    my @args = ('name:family:kanji');
    my $context = App::Gimei::Context->new(@args);
    my $parser = App::Gimei::Parser->new($context);
    my $ir = $parser->parse_arg();

    is $ir->{type}, 'name';
    is $ir->{sub_type}, 'family';
    is $ir->{rendering}, 'kanji';
}

{
    my @args = ('address:prefecture:kanji');
    my $context = App::Gimei::Context->new(@args);
    my $parser = App::Gimei::Parser->new($context);
    my $ir = $parser->parse_arg();

    is $ir->{type}, 'address';
    is $ir->{sub_type}, 'prefecture';
    is $ir->{rendering}, 'kanji';
}

{ #100
    my @args = ('name');
    my $context = App::Gimei::Context->new(@args);
    my $parser = App::Gimei::Parser->new($context);
    my $ir = $parser->parse_arg();

    is $ir->{type}, 'name';
    is $ir->{sub_type}, 'family';
    is $ir->{rendering}, 'kanji';
}

{ # 101
    my @args = ('name:kanji');
    my $context = App::Gimei::Context->new(@args);
    my $parser = App::Gimei::Parser->new($context);
    my $ir = $parser->parse_arg();

    is $ir->{type}, 'name';
    is $ir->{sub_type}, 'family';
    is $ir->{rendering}, 'kanji';
}

{ # 110
    my @args = ('name:family');
    my $context = App::Gimei::Context->new(@args);
    my $parser = App::Gimei::Parser->new($context);
    my $ir = $parser->parse_arg();

    is $ir->{type}, 'name';
    is $ir->{sub_type}, 'family';
    is $ir->{rendering}, 'kanji';
}

{ # 201
    my @args = ('address:kanji');
    my $context = App::Gimei::Context->new(@args);
    my $parser = App::Gimei::Parser->new($context);
    my $ir = $parser->parse_arg();

    is $ir->{type}, 'address';
    is $ir->{sub_type}, 'prefecture';
    is $ir->{rendering}, 'kanji';
}

done_testing;
