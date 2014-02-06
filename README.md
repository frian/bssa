#bssa

bootstrap a silex ( and soon a symfony ) app in seconds.

##what it does

* download a silex app skeleton from github.com
* install composer
* install silex
* initialize compass *

##what it does not

* launch compass (compass watch)

#requirements

* curl (http://curl.haxx.se/)
* git (http://git-scm.com/)
* compass (http://compass-style.org/) *

\* if compass is not installed or fails, you still have a working app !

#configuration

at the top pf the script

* $gitRepo : repo of default skeleton (frian/silex-bootstrap-skel)
* @dirsToChmod : some dirs needs special permissions (var/cache var/logs)
* $perms : permissions for the dirs above (0777)
* $webDir : the public folder (web)

#usage

    ./bssa.pl folder

folder must be an empty existing folder (htdocs or your docs base directory)



