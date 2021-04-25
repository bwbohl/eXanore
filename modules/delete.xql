(: eXanore - EXist-db ANnotator stORE API
 : Copyright Benjamin W. Bohl 2014.
 : bohl(at)edirom.de
 :
 : http://www.github.com/edirom/ediromSourceManager
 :
 : ## Description & License
 :
 : This file creates a XML file in eXist-db according to submitted parameters
 :
 : This program is free software: you can redistribute it and/or modify
 : it under the terms of the GNU General Public License as published by
 : the Free Software Foundation, either version 3 of the License, or
 : (at your option) any later version.
 :
 : This program is distributed in the hope that it will be useful,
 : but WITHOUT ANY WARRANTY; without even the implied warranty of
 : MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 : GNU General Public License for more details.
 :
 : You should have received a copy of the GNU General Public License
 : along with this program.  If not, see <http://www.gnu.org/licenses/>.
 :)

xquery version "3.0";
(: import relevant eXist-db modules :)
import module namespace exanoreParam="http://www.eXanore.com/param" at "params.xqm";
import module namespace jwt="http://de.dariah.eu/ns/exist-jwt-module";

(: declare namespaces :)
declare namespace eX = "htp://www.edirom.de/ns/eXanore";

(: set serialization options :)
declare option exist:serialize "method=text media-type=text/plain";

declare variable $authToken := request:get-header('x-annotator-auth-token');
declare variable $user := jwt:verify($authToken, $exanoreParam:JwtSecret);
declare variable $userValid := $user/@valid eq "true";

(: file information - submitted parameters :)
if($userValid) then
    let $id := request:get-parameter("id", "")
    let $annotation := doc( $exanoreParam:dataCollectionURI || "/" || $id || ".xml" )
    return
        if( $annotation//pair[@name="admin"]/item/text() = $user//jwt:userId/text() )
        then
            let $login:= xmldb:login($exanoreParam:dataCollectionURI, "annotator", "annotator")
            let $DELETE := if($id != "") then xmldb:remove($exanoreParam:dataCollectionURI, $id || ".xml") else ()
            return
                response:set-status-code( 204 )
        else response:set-status-code( 403 ) (: Forbidden :)
else response:set-status-code( 401 ) (: Unauthorized :)
