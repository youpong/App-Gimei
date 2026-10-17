use v5.42;

use lib ".";
use t::Util;

my @tests = (
    {
        Name                   => '-sep :',
        args                   => [ '-sep', ':' ],
        expected_stdout        => qr/^\S+\s\S+$/,
        expected_stderr        => '',
        expected_error_message => '',
    },
    {
        Name                   => '-sep : pref, city',
        args                   => [ '-sep', ':', 'address:prefecture', 'address:city' ],
        expected_stdout        => qr/^[^:]+:[^:]+$/,
        expected_stderr        => '',
        expected_error_message => '',
    },
);

t::Util->run(@tests);
