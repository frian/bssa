#!/usr/bin/perl

# 05/02/2014
#
# bssa.pl - bootstrap a silex ( and soon a symfony app ) in seconds
# (c) André Friedli <a@frian.org>

# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.


use strict;
use warnings;

# -- OPTIONNAL CONFIGURATION --------------------------------------------------

# -- replace with yours or any
my $gitRepo = 'frian/silex-bootstrap-skel';

# -- set path to cache and log dirs
my @dirsToChmod = qw( var/cache var/logs );

# -- END

# -- help message
my $help = qq~
  usage : $0 folder

~;

my $composerInstallCmd = 'curl -sS https://getcomposer.org/installer | php';
my $skelDlCmd = 'git clone git://github.com/' . $gitRepo . '.git' ;
my $nullRedirect = ' > /dev/null 2>&1';


# die if no paramter
unless ( @ARGV ) { die $help }

# die if folder not writable
unless ( -d $ARGV[0] && -w _ ) { die "\n  $ARGV[0] not found or is not a folder or is not writable\n\n" }

# store folder name
my $baseDir = $ARGV[0];

chdir $baseDir or die " cannot cd to $baseDir";

print " creating new silex app in $baseDir\n";

print " downloading silex skel from github ... ";
system($skelDlCmd . ' ' . $baseDir . $nullRedirect) == 0 or die "  failed to clone from github (directory not empty ?)";
print "done\n";

print " installing composer ... ";
system($composerInstallCmd . $nullRedirect ) == 0 or die "  failed to install composer;";
print "done\n";

print " installing silex ... ";
system( './composer.phar install' . $nullRedirect ) == 0 or die "  failed to install silex;";
print "done\n";

print " changing permissions on ";
print join( ', ' , @dirsToChmod );
print " ... ";

foreach ( @dirsToChmod ) {
  chmod(0777, $_) or warn "Couldn't chmod $_ : $!";
}

print "done\n";

print " silex app ready \\o/ \n";

