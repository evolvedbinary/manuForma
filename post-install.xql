xquery version "3.0";

import module namespace xdb="http://exist-db.org/xquery/xmldb";

(: The following external variables are set by the repo:deploy function :)

(: file path pointing to the exist installation directory :)
declare variable $home external;
(: path to the directory containing the unpacked .xar package :)
declare variable $dir external;
(: the target collection into which the app is deployed :)
declare variable $target external;

(
   sm:chmod(xs:anyURI($target || '/modules/git-sync.xql'), "rwsr-xr-x"),
   sm:chmod(xs:anyURI($target || '/modules/login-helper.xql'), "rwsr-xr-x"),
   sm:chmod(xs:anyURI($target || '/modules/userManager.xql'), "rwsr-xr-x"),
   sm:chmod(xs:anyURI($target || '/services/submit.xql'), "rwsr-xr-x"),
   sm:create-group('manuForma')
)