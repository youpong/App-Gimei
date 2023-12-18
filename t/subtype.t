use v5.36;

use lib ".";
use t::Util qw(run);

my @tests = (
    {
        Name => 'family',
        args => ['name:family'],
        # is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => qr/^\S+$/,
        expected_stderr => '',
    },
    {
        Name => 'last',
        args => ['name:last'],
        # is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => qr/^\S+$/,
        expected_stderr => '',
    },
    {
        Name => 'given',
        args => ['male:given'],
        # is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => qr/^\S+$/,
        expected_stderr => '',
    },
    {
        Name => 'first',
        args => ['female:first'],
        # is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => qr/^\S+$/,
        expected_stderr => '',
    },
    {
        Name => 'gender',
        args => ['name:gender'],
        #is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => qr/^\S+$/,
        expected_stderr => '',
    },
    {
        Name => 'sex',
        args => ['name:sex'],
        # is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => qr/^\S+$/,
        expected_stderr => '',
    },
    {
        Name => 'unknown',
        args => ['female:unknown'],
        #is $app->exit_code, 255;
        expected_error_message => "Error: unknown subtype or rendering: unknown\n",
        expected_stdout => '',
        expected_stderr => '',
    },
    {
        Name => 'prefecture',
        args => ['address:prefecture'],
        # is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => qr/^\S+$/,
        expected_stderr => '',
    },
    {
        Name => 'city',
        args => ['address:city'],
        # is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => qr/^\S+$/,
        expected_stderr => '',
    },
    {
        Name => 'town',
        args => ['address:town'],
        # is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => qr/^\S+$/,
        expected_stderr => '',
    },
    {
        Name => 'unknown',
        args => ['address:unknown'],
        #is $app->exit_code, 255;
        expected_error_message =>
        "Error: unknown subtype or rendering: unknown\n",
        expected_stdout => '',
        expected_stderr => '',
    },
);
run(@tests);
