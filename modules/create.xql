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
import module namespace request="http://exist-db.org/xquery/request";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.edirom.de/tools/eXanore/config" at "config.xqm";
import module namespace xqjson="http://xqilla.sourceforge.net/lib/xqjson";
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
declare variable $jsonRequest := util:base64-decode(request:get-data());

(: set delete permission to the contributing user :)
declare variable $json := replace($jsonRequest, '"delete":\[\],', '"delete":["'|| string($user//jwt:userId) ||'"],' );
declare variable $uri := request:get-parameter('uri', '');

(: declare additional variables :)
declare variable $id := 'eXanore_' || util:hash(string($json), "md5");
declare variable $xmlFromJSON := xqjson:parse-json($json);
declare variable $readyXML := eX:makeXMLready($xmlFromJSON);

(: functional variables :)
declare variable $sourceCollectionPath := 'xmldb::exist:///db/eXanore_data/';
declare variable $expath-descriptor := config:expath-descriptor();
declare variable $filename := $id  || ".xml";

declare function eX:addRootAttributes($filename){
  let $file := doc($exanoreParam:dataCollectionURI || $filename)
  let   $root := $file/json
  let   $content := $root/*
  return (
    update insert element item {attribute type {'object'}, $content} into $root
  )
};

declare function eX:makeXMLready($xml){
  element item{
    attribute type {'object'},
    element pair {
      attribute name {"id"},
      attribute type {"string"},
      string($id)
    },
(: do not inject the uri at DARIAHs AnnoStore!
 :   element pair {:)
(:        attribute name { "uri" },:)
(:        attribute type {"string"},:)
(:        $uri:)
(:    },:)
(: work around bug:
 : https://github.com/openannotation/annotator/issues/638
 :    element pair {:)
(:        attribute name { "user" },:)
(:        attribute type { "string" },:)
(:        xmldb:get-current-user():)
(:    },:)
    $xml/*
  }
};

(: declare function for storing file in eXist-db :)
declare function local:store($collection-uri,$resource-name,$contents){
  if(xmldb:collection-available($collection-uri))
  then(xmldb:store($collection-uri, $resource-name, $contents)
  )
  else()
};

declare function eX:store(){
let $login:= xmldb:login($exanoreParam:dataCollectionURI, "annotator", "annotator")
return
    xmldb:store($exanoreParam:dataCollectionURI, $filename, $readyXML)
};

(: TODO file exists handling :)
(:if(fn:doc-available(concat($sourceCollectionPath,$filename)))
then(fn:error(fileExists,concat('a file with the spcified filename (',$filename,') already exists ')))
else( :) (:  local:return():)


if($userValid) then
let $store := eX:store()
let $xml := doc($exanoreParam:dataCollectionURI || "/" || $filename)/*
return(
  xqjson:serialize-json($xml)
)
 else response:set-status-code( 401 ) (: Unauthorized :)
