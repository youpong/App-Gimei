use v5.36;

use App::Gimei;
use lib ".";
use t::Util qw(run);

my @tests = (
    {
        Name => 'long form',
        args => ['-version'],
        #is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => "$App::Gimei::VERSION\n",
        expected_stderr => '',
    },
    {
        Name => 'short form',
        args => ['-v'],
        # is $app->exit_code, 0;
        expected_error_message => '',
        expected_stdout => "$App::Gimei::VERSION\n",
        expected_stderr => '',
    },
);
run(@tests);
