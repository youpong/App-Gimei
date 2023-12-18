use v5.36;

use lib ".";
use t::Util qw(run);

my @tests = (
    {
        Name => 'default',
        args => ['name'],
        #is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => qr/^\S+\s\S+$/,
        expected_stderr => '',
    },
    {
        Name => 'address->romaji',
        args => ['address:romaji'],
        #is $app->exit_code, 255;
        expected_error_message => 
        "Error: rendering romaji is not supported for address\n",
        expected_stdout => '',
        expected_stderr => '',
    },
    {
        Name => 'gender',
        args => ['name:gender'],
        # is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => qr/^\S+$/,
        expected_stderr => '',
    },
    {
        Name => 'kanji',
        args => ['name:kanji'],
        # is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => qr/^\S+\s\S+$/,
        expected_stderr => '',
    },
    {
        Name => 'hiragana',
        args => ['name:family:hiragana'],
        # is $app->exit_code, 0;
       expected_error_message => '',
       expected_stdout => qr/^\S+$/,
       expected_stderr => '',
    },
    {
        Name => 'katakana',
        args => ['address:katakana'],
        # is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => qr/^\S+$/,
        expected_stderr => '',
    },
    {
        Name => 'unknown rendering',
        args => ['address:prefecture:romaji'],
        #is $app->exit_code, 255;
        expected_error_message =>
        "Error: rendering romaji is not supported for address\n", 
        expected_stdout => '',
        expected_stderr => '',
    },
);
run(@tests);
