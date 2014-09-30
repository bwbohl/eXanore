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

(: declare namespaces :)
declare namespace eX = "htp://www.edirom.de/ns/eXanore";

(: set serialization options :)
declare option exist:serialize "method=text media-type=text/plain";

(: file information - submitted parameters :)
declare variable $json := request:get-parameter('data','{"key":"value"}');

(: declare additional variables :)
declare variable $id := concat('eXanore_',util:hash(string($json), "md5"));
declare variable $xmlFromJSON := xqjson:parse-json($json);
declare variable $readyXML := eX:makeXMLready($xmlFromJSON);

(: functional variables :)
declare variable $sourceCollectionPath := 'xmldb::exist:///db/eXanore_data/';
declare variable $expath-descriptor := config:expath-descriptor();
declare variable $filename := $id  || ".xml";

declare function eX:addRootAttributes($filename){
  (: TODO?  xml:id="eXanore_39fc339cf058bd22176771b3e3187320" annotator_schema_version="v1.0" created="2011-05-24T18:52:08.036814" updated="2011-05-26T12:17:05.012544" :)
  let $file := xmldb:document($exanoreParam:dataCollectionURI || $filename)
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
    $xml/*
  }
};

(: declare function for storing file in eXist-db :)
declare function local:store($collection-uri,$resource-name,$contents){
  if(xmldb:collection-available($collection-uri))
  then(xmldb:store($collection-uri, $resource-name, $contents)
    (:  'open ressource in eXide':)
  )
  else()
};

declare function eX:store(){
  xmldb:store($exanoreParam:dataCollectionURI, $filename, $readyXML)
};

(: TODO file exists handling :)
(:if(fn:doc-available(concat($sourceCollectionPath,$filename)))
then(fn:error(fileExists,concat('a file with the spcified filename (',$filename,') already exists ')))
else( :) (:  local:return():)

let $store := eX:store()
let $xml := xmldb:document($exanoreParam:dataCollectionURI || $filename)/*
return(
  xqjson:serialize-json($xml)
)
