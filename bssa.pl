#!/usr/bin/perl

# 04/03/2014
#
# bssa.pl - bootstrap a silex ( and soon a symfony app ) in seconds
# (c) André Friedli <a@frian.org>

# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.

# -- version -VERSION-
# -- released -DATE-

use strict;
use warnings;

use Cwd;
use Getopt::Std;
use File::Path;

# -- OPTIONNAL CONFIGURATION --------------------------------------------------

# -- replace with yours or any
my $gitRepo = 'frian/silex-bootstrap-skel';

# -- set path to cache and log dirs
my @dirsToChmod = qw( var/cache var/logs );

# -- permissions
my $perms = 0777;

# -- web
my $webDir = 'web';

# -- END

my $gitDir = '.git';

# -- help message
my $help = qq~
  usage : $0 [-r github_repo] folder

~;

# -- parse command line options 
# -- die on error
{
  local $SIG{__WARN__} = sub { };  # Supress warnings
  getopts('r:') or die $help;
}

# die if no folder paramter
unless ( @ARGV ) { die $help }

# die if folder not writable
unless ( -d $ARGV[0] && -w _ ) { 
  die "\n  $ARGV[0] not found or is not a folder or is not writable\n\n" 
}

our ( $opt_r );

if (( $opt_r ) && ( $opt_r =~ m|^[\w/-]+$| )) {
  $gitRepo = $opt_r;
}

my $composerInstallCmd = 'curl -sS https://getcomposer.org/installer | php';
my $skelDlCmd = 'git clone git://github.com/' . $gitRepo . '.git';
my $compassInitCmd = 'compass init';
my $nullRedirect = ' > /dev/null 2>&1';


# os detection
if ( $^O eq 'MSWin32' ) {
  $nullRedirect = ' >nul 2>nul';
}

# store folder name
my $baseDir = getcwd() . '/' . $ARGV[0];

chdir $baseDir or die " cannot cd to $baseDir";

print " creating new silex app in $baseDir\n";

# -- download silex skel ------------------------------------------------------
print " downloading silex skel $gitRepo from github ... ";
(system($skelDlCmd . ' ' . '.' . $nullRedirect) == 0)
  ?print "done\n"
    :die "  failed to clone from github (directory not empty ?)";


# -- install composer ---------------------------------------------------------
print " installing composer ... ";
(system($composerInstallCmd . $nullRedirect ) == 0)
  ?print "done\n"
    :die " failed to install composer;";


# -- install silex ------------------------------------------------------------
print " installing silex ... ";
(system( 'php composer.phar install' . $nullRedirect ) == 0)
  ?print "done\n"
    :die "  failed to install silex;";


# -- change permissions on special dirs ---------------------------------------
print " changing permissions on " . join( ', ' , @dirsToChmod ) . " ... ";
foreach ( @dirsToChmod ) {
  chmod($perms, $_) or warn "Couldn't chmod $_ : $!";
}
print "done\n";

chdir $webDir or die " cannot cd to $webDir";

# -- try to launch compass ----------------------------------------------------
print " trying to launch compass ... ";

(system($compassInitCmd . $nullRedirect ) == 0)
  ?print "done\n"
    :warn " failed to initilize compass\n";

chdir $baseDir or die " cannot cd to $baseDir";

# -- remove .git folder -------------------------------------------------------
print " removing $gitDir ... ";
if ( -d $gitDir ) {
  rmtree($gitDir)
    ?print "done\n"
      :warn " cannot remove $gitDir : $!";
}

# -- init git repo ------------------------------------------------------------
my $gitInitCmd = 'git init';
print " running $gitInitCmd ... ";
(system($gitInitCmd . $nullRedirect) == 0 )
  ?print "done\n"
    :warn "  failed to run $gitInitCmd\n";


# -- add files to repo --------------------------------------------------------
my $gitAddCmd = 'git add .';
print " running $gitAddCmd ... ";
(system($gitAddCmd . $nullRedirect) == 0)
  ?print "done\n"
    :warn "  failed add files to git repo\n";


# -- initial commit -----------------------------------------------------------
my $gitCommitCmd = "git commit -m 'intital commit'";
print " initial commit ... ";
(system($gitCommitCmd . $nullRedirect) == 0)
  ?print "done\n"
    :warn "  failed create initial commit\n";


print " silex app ready \\o/ \n";
