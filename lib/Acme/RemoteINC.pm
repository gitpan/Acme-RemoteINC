package Acme::RemoteINC;

use 5.008;
use strict;
use warnings;
use Net::FTP;
use File::Temp;
our $VERSION = 0.10;

sub new { 
    my($class, %args) = @_;
    my $self = {};
    bless $self, $class;
    foreach my $k ( qw(ftp host user password perl_root) ) 
     { $self->{$k} = $args{$k} if $args{$k} }
    unless( $self->{ftp} ) {
        my $ftp = new Net::FTP($self->{host}) or return;
        $ftp->login( $self->{user} => $self->{password} ) or return;
        if($self->{perl_root}) { $ftp->cwd($self->{perl_root}) or return }
        $self->{ftp} = $ftp;
    }
    # register ourselves in @INC.
    push @INC, $self;
    return $self;
}

sub Acme::RemoteINC::INC {
    my($self, $filename) = @_;
    my($tmpFH, $tmpname) = File::Temp::tmpnam();
    $self->{ftp}->get($filename, $tmpname) or return undef;
    return $tmpFH;
}

=head1 NAME

Acme::RemoteINC - Slowest Possible Module Loading

=head1 DESCRIPTION

For your SlowCGI pleasure, loads perl modules via FTP from remote sites.
Plase don thick rubber gloves and consider version and binary XS module 
compatibility before using. Requires Perl 5.8 or greater.

=head1 (IR)RATIONALE

Who do you want to kid today? A paranoid ISP admin who won't let you load 
your favorite CPAN module on his system? Yourself, for considering this as 
a valid solution to a social problem like that one?

=head1 SYNOPSIS

    use strict;
    use warnings;
    use DBI;  # load local DBI by default
    use DBD::Esoterica;  # if cannot load locally, will try the FTP method
    ...etc.
 BEGIN {
    require Acme::RemoteINC;
    my $rinc = new Acme::RemoteINC(
        host      => 'ftp.esoteric-perl.com',
        user      => 'anonymous',
        password  => 'pwd@myhost.com',
        perl_root => '/usr/lib/perl5/site_perl/5.8.1'
    );
 }

=head1 METHODS

=over 4

=item B<new>

    my $rinc = new Acme::RemoteINC(
      host      => 'ftp.myserver.com',
      user      => 'anonymous',
      password  => 'pwd@myhost.com',
      perl_root => '/usr/lib/perl5/site_perl'
    );
    
    or 
    my $ftp = new Net::FTP;
    ...
    my $rinc = Acme::RemoteINC->new(ftp => $ftp);
    
    push $rinc, @INC if($rinc);


    The new method creates a new Acme::RemoteINC object.
    Three paired hash entry named arguments are required for new:

    host => $hostname
      The name of the ftp server.
      
    user => $loginname
        Login user name.
        
    password => $pwd
        Login password.
    
    Two paired hash entry named arguments are optional arguments for new:

    perl_root => $wdir
        Perl module directory name relative to the FTP service root.
        Defaults to the default ftp service's base working directory.
        
    ftp => $ftp
        When given as an argument, this overrides use of the other arguments.
        ftp is then expected to be a Net::FTP object which has already been 
        logged in and pointed to the proper Perl root library directory.

NOTE: It is advisable that the call to new be done in a BEGIN block. It is 
also advisable to load Acme::RemoteINC via require in the BEGIN block.

=item B<INC>

    This method is used by the use and require directives after the 
    reference to the Acme::RemoteINC object has been placed in @INC.
    For details, see the perlfunc docs for require.

=head1 BUGS

  This code is beyond bugs. Here there be monsters. The entire concept of 
  loading modules via hooks to Net::FTP may well be fatally flawed. Enjoy :).

=head1 B<SEE ALSO>

B<Acme::Everything>
B<Net::FTP>
B<Tie::FTP>
    
=head1 TODO
  
  perl_root should also accept an array ref to a list of directories.
    
=head1 AUTHOR

William Herrera (wherrera@skylightview.com)

=head1 SUPPORT

    Rude noises, questions, feature requests and inquiries regarding the 
    mental state required to upload code this slow are referred to the 
    Acme, Incorporated Perl suggestion box (thanks@dev.null).

=head1 COPYRIGHT

     Copyright (C) 2004 William Hererra.  All Rights Reserved.

    This module is free software; you can redistribute it and/or mutilate it
    under the same terms as Perl itself.

=cut

1;
