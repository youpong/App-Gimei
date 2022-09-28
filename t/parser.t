use warnings;
use v5.22;

use App::Gimei::Context;
use App::Gimei::Parser;
use Test::More;

{
    my @args = ('name', 'name:kanji', 'name:family', 'name:family:kanji');
    my @want = ( {type => 'name', sub_type => 'full',   rendering=>'kanji'},
                 {type => 'name', sub_type => 'full',   rendering=>'kanji'},
                 {type => 'name', sub_type => 'family', rendering=>'kanji'},
                 {type => 'name', sub_type => 'family', rendering=>'kanji'} );

    my $context = App::Gimei::Context->new(@args);
    my $parser = App::Gimei::Parser->new($context);

    my @irs = $parser->parse();
    for (my $i = 0; $i < @irs; $i++) {
        my $got = $irs[$i];
        my $want = $want[$i];

        is $got->{type}, $want->{type};
        is $got->{sub_type}, $want->{sub_type};
        is $got->{rendering}, $want->{rendering};
    }
}

{
     my @args = ();
     my $context = App::Gimei::Context->new(@args);
     my $parser = App::Gimei::Parser->new($context);

     my @irs = $parser->parse();
     foreach my $ir (@irs) {
         say $ir->{type};
     }
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


{ # 201
    my @args = ('address:kanji');
    my $context = App::Gimei::Context->new(@args);
    my $parser = App::Gimei::Parser->new($context);
    my $ir = $parser->parse_arg();

    is $ir->{type}, 'address';
    is $ir->{sub_type}, 'full';
    is $ir->{rendering}, 'kanji';
}

done_testing;
