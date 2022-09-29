package App::Gimei::Parser;

use warnings;
use v5.22;

use App::Gimei;
use Data::Gimei;

use Class::Tiny qw ( context );

sub BUILDARGS {
    my ( $class, $context ) = @_;

    return { context => $context };
}

# (* the Syntax in extended BNF *)
# arg               =  type , [':' sub type] , [':' rendering]
# type              = 'name'           | 'male'     | 'female'   | 'address'
# sub type(name)    = 'family'         | 'given'    | 'gender'
# sub type(address) = 'prefecture'     | 'city'     | 'town'
# rendering         = 'name' | 'kanji' | 'hiragana' | 'katakana' | 'romaji'

# parse
sub parse {
    my $self = shift;

    my @irs;

    my $ir;
    while ( $ir = $self->parse_arg() ) {
        push @irs, $ir;
    }

    return @irs;
}

# undef
# ref to hash
sub parse_arg {
    my $self = shift;

    my %ir;
    my $token = $self->context->next_token();
    if ($token eq '-') {
        return undef
    }
    if ($token eq 'name' || $token eq 'male' || $token eq 'female') {
        $ir{type} = 'name';
        $ir{sub_type} = $self->name_subtype();
    } elsif ($token eq 'address') {
        $ir{type} = 'address';
        $ir{sub_type} = $self->address_subtype();
    } else {
        die "Error: unknown word_type: NOT_SUPPORTED\n";
    }
    $ir{rendering} = $self->rendering();

    $token = $self->context->next_token(); # consume ':', '-'
    if ($token ne ':' && $token ne '-') {
        die "Error: unknown subtype or rendering: unknown\n";
    }

    return \%ir;
}

sub name_subtype {
    my $self = shift;

    my $token = $self->context->next_token();
    if ($token eq '-') {
        $self->context->step_back();
        return 'full';
    }
    if ($token eq 'name') {
        return 'full';
    }
    if ($token eq 'family' || $token eq 'last') {
        return 'family';
    }
    if ($token eq 'given' || $token eq 'first') {
        return 'given';
    }
    if ($token eq 'gender' || $token eq 'sex') {
        return 'gender';
    }

    $self->context->step_back();
    return 'full';
}

sub address_subtype {
    my $self = shift;

    my $token = $self->context->next_token();
    if ($token eq '-') {
        $self->context->step_back();
        return 'full';
    }
    if ($token eq 'prefecture') {
        return 'prefecture';
    }
    if ($token eq 'city') {
        return 'city';
    }
    if ($token eq 'town') {
        return 'town';
    }

    $self->context->step_back();
    return 'full';
}

sub rendering {
    my $self = shift;

    my $token = $self->context->next_token();
    if ($token eq '-') {
        $self->context->step_back();
        return 'kanji';
    }
    if ($token eq 'kanji' || $token eq 'name' ) {
        return 'kanji';
    }
    if ($token eq 'hiragana') {
        return 'hiragana';
    }
    if ($token eq 'katakana') {
        return 'katakana';
    }
    if ($token eq 'romaji' ) {
        return 'romaji';
    }

    $self->context->step_back();
    return 'kanji';
}

sub to_s {
    my $self = shift;

    return $self->context->next_token();
}

1;
