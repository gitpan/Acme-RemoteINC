use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'Acme::RemoteINC',
    VERSION_FROM => 'lib/Acme/RemoteINC.pm', # finds $VERSION
    AUTHOR       => 'William Hererra (whererra@skylightview.com)',
    ABSTRACT     => 'Slowest Possible Module Loading',
    PREREQ_PM    => { Net::FTP => 0, Tie::FTP => 0, Test::Simple => 0 },
);
