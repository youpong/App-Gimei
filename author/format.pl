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
    # instance variables
    #

    field @target_patterns :reader = ( qr/.+\.pl$/, qr/.+\.pm$/, qr/.+\.t$/, qr/^cpanfile$/ );
    field $root_dir        :reader = abs_path( File::Spec->catdir( $FindBin::Bin, '..' ) );

    #
    # private instance methods
    #

    my method _format($file) {
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
    # public instance method
    #

    method run() {
        my @files = `git -C "$root_dir" ls-files `;
        chomp @files;
        foreach my $f (@files) {
            if ( any { $f =~ $_ } @target_patterns ) {
                $self->&_format($f);
            }
        }
        say "Done $#files files.";
    }
}

Formatter->new->run;
