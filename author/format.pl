use v5.42;
use feature 'class';
no warnings 'experimental::class';

class Formatter {
    use FindBin;
    use File::Spec;
    use Cwd 'abs_path';
    use Perl::Tidy;
    use List::Util qw(any);

    #
    # class variables
    #

    my @target_patterns = ( qr/.+\.pl$/, qr/.+\.pm$/, qr/.+\.t$/, qr/^cpanfile$/ );
    my $root_dir        = abs_path( File::Spec->catdir( $FindBin::Bin, '..' ) );

    #
    # private class methods
    #

    my sub _format( $class, $file ) {
        my $perltidyrc = File::Spec->catfile( $root_dir, '.perltidyrc' );

        my $error = Perl::Tidy::perltidy(
            source      => $file,
            destination => $file,
            perltidyrc  => $perltidyrc,
        );
        if ($error) {
            die "perltidy failed on $file\n";
        }
    }

    #
    # public class method
    #

    sub run($class) {
        my @files = `git -C "$root_dir" ls-files `;
        chomp @files;
        foreach my $f (@files) {
            if ( any { $f =~ $_ } @target_patterns ) {
                $class->&_format($f);
            }
        }
        say "Done $#files files.";
    }
}

Formatter->run;
