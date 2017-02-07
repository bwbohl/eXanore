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
declare variable $jsonReq := util:base64-decode(request:get-data());
declare variable $json := replace($jsonReq, '"delete":\[\],', '"delete":["'|| string($user//jwt:userId) ||'"],' );

(: set delete permission to the contributing user :)
declare variable $uri := request:get-parameter('uri', '');

(: declare additional variables :)
declare variable $id := request:get-parameter('id', '');
declare variable $xmlFromJSON := xqjson:parse-json($json);
declare variable $readyXML := eX:makeXMLready($xmlFromJSON);

(: functional variables :)
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
(:    element pair {:)
(:      attribute name {"id"},:)
(:      attribute type {"string"},:)
(:      string($id):)
(:    },:)
(:    element pair {:)
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
    (:  'open ressource in eXide':)
  )
  else()
};

declare function eX:store(){
let $login:= xmldb:login($exanoreParam:dataCollectionURI, "annotator", "annotator")
return
    xmldb:store($exanoreParam:dataCollectionURI, $filename, $readyXML)
};

let $origin := "*"
let $store := eX:store()
let $xml := doc($exanoreParam:dataCollectionURI || "/" || $filename)/*
return
    (response:set-header("Access-Control-Allow-Origin", $origin),
    xqjson:serialize-json($xml))
