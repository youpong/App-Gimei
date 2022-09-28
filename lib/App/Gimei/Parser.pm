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
# type              = 'name'       | 'male'     | 'female'   | 'address'
# sub type(name)    = 'family'     | 'given'
# sub type(address) = 'prefecture' | 'city'     | 'town'
# rendering         = 'kanji'      | 'hiragana' | 'katakana' | 'romaji'

# parse
sub parse {
    my $self = shift;

    my @irs;

    my %ir;
    while ( (%ir = $self->parse_arg()) ) {
        say %ir;
        push @irs, %ir;
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
        $ir{sub_type} = address_subtype();
    }
    $ir{rendering} = rendering();

    return \%ir;
}

sub name_subtype {
    my $self = shift;

    my $token = $self->context->next_token();
    if ($token eq '-') {
        return 'family';
    }
    if ($token eq 'family' || $token eq 'last') {
        return 'family';
    }
    if ($token eq 'given' || $token eq 'first') {
        return 'given';
    }
    $self->context->step_back();
    return 'family';
}

sub address_subtype {
    return 'prefecture';
}

sub rendering {
    return 'kanji';
}

sub to_s {
    my $self = shift;

    return $self->context->next_token();
}

1;
