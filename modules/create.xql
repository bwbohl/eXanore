(: eXanore - EXist-db ANnotator stORE API
 : Copyright Benjamin W. Bohl 2014.
 : bohl(at)edirom.de
 :
 : http://www.github.com/edirom/ediromSourceManager
 : 
 : ## Description & License
 : 
 : This file creates a MEI file in eXist-db according to submitted parameters
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
 
 <!-- 

{
  "id": "39fc339cf058bd22176771b3e3187329",  # unique id (added by backend)
  "annotator_schema_version": "v1.0",        # schema version: default v1.0
  "created": "2011-05-24T18:52:08.036814",   # created datetime in iso8601 format (added by backend)
  "updated": "2011-05-26T12:17:05.012544",   # updated datetime in iso8601 format (added by backend)
  "text": "A note I wrote",                  # content of annotation
  "quote": "the text that was annotated",    # the annotated text (added by frontend)
  "uri": "http://example.com",               # URI of annotated document (added by frontend)
  "ranges": [                                # list of ranges covered by annotation (usually only one entry)
    {
      "start": "/p[69]/span/span",           # (relative) XPath to start element
      "end": "/p[70]/span/span",             # (relative) XPath to end element
      "startOffset": 0,                      # character offset within start element
      "endOffset": 120                       # character offset within end element
    }
  ],
  "user": "alice",                           # user id of annotation owner (can also be an object with an 'id' property)
  "consumer": "annotateit",                  # consumer key of backend
  "tags": [ "review", "error" ],             # list of tags (from Tags plugin)
  "permissions": {                           # annotation permissions (from Permissions/AnnotateItPermissions plugin)
    "read": ["group:__world__"],
    "admin": [],
    "update": [],
    "delete": []
  }
}

{"url":"http://upload.wikimedia.org/wikipedia/commons/e/e4/Hallstatt_300.jpg","l":[{"type":"rect","a":{"x":251,"width":168,"y":47,"height":124}}],"text":"my test annot","ranges":[],"quote":"","uri":"/exist/apps/edirom-SIC/index.html"}

-->
 
 :)

xquery version "3.0";

(: import relevant eXist-db modules :)
import module namespace request="http://exist-db.org/xquery/request";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace system="http://exist-db.org/xquery/system";
import module namespace config="http://www.edirom.de/tools/eXanore/config" at "config.xqm";
import module namespace xqjson="http://xqilla.sourceforge.net/lib/xqjson";
import module namespace exanoreParam="http://www.eXanore.com/param" at "params.xqm";

(: declare namespaces :)
declare namespace eX = "htp://www.edirom.de/ns/eXanore";
declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace expath="http://expath.org/ns/pkg";
declare namespace repo="http://exist-db.org/xquery/repo";

(: file information - submitted parameters :)
declare variable $id := concat('eXanore','bla');
declare variable $json := (:request:get-data();:)
'{"url":"http://upload.wikimedia.org/wikipedia/commons/e/e4/Hallstatt_300.jpg","l":[{"type":"rect","a":{"x":251,"width":168,"y":47,"height":124}}],"text":"my test annot","ranges":[],"quote":"","uri":"/exist/apps/edirom-SIC/index.html"}';
declare variable $xmlFromJSON := xqjson:parse-json($json);
declare variable $xmlJSON := element root {$json};
(: functional variables :)
declare variable $sourceCollectionPath := 'xmldb::exist:///db/eXanore_data/';
declare variable $expath-descriptor := config:expath-descriptor();
declare variable $filename := concat($id,'.xml');

(: declare function for storing file in eXist-db :)
declare function local:store($collection-uri,$resource-name,$contents){
  if(xmldb:collection-available($collection-uri))
  then(xmldb:store($collection-uri, $resource-name, $contents)
    (:  'open ressource in eXide':)
  )
  else()
};

declare function local:generateID(){
  fn:generate-id()
};

declare function local:return(){
	local:store($sourceCollectionPath, $filename, $xmlFromJSON)
};

(:if(fn:doc-available(concat($sourceCollectionPath,$filename)))
then(fn:error(fileExists,concat('a file with the spcified filename (',$filename,') already exists ')))
else( :)
(:  local:return():)
(:):)


xmldb:store($exanoreParam:dataCollectionURI, $filename, $xmlFromJSON)
 
 
