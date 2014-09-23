xquery version "3.0";

declare namespace json="http://www.json.org";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

import module namespace xqjson="http://xqilla.sourceforge.net/lib/xqjson";

import module namespace exanore="https://www.exanore.com" at "eXanore.xqm";
import module namespace exanoreParam="http://www.eXanore.com/param" at "params.xqm";

(: Switch to JSON serialization :)
(: [{ba}, {"ba2"}] :)
(:declare option output:method "json";:)
(:declare option output:media-type "application/json";:)
declare option exist:serialize "method=text media-type=text/plain";

declare variable $annots2json := for $annot in fn:collection($exanoreParam:dataCollectionURI || '?=*.xml')[1]//annotation
                                 return exanore:annot2json-xml3($annot);


xqjson:serialize-json(<json type="array">{$annots2json}</json>)
(:element annots {$annots2json}:)