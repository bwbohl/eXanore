(: eXanore - EXist-db ANnotator stORE API
 : Copyright Benjamin W. Bohl 2014.
 : bohl(at)edirom.de
 :
 : http://www.github.com/edirom/ediromSourceManager
 : 
 : ## Description & License
 : 
 : This query is to implement the Annotator Store API index functionality
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

declare variable $annots2json := element json {attribute type {'array'},for $file in fn:collection($exanoreParam:dataCollectionURI || '?=*.xml')[1] return element item { attribute type {'object'}, $file//json/*}};
(: data_depr [1]//annotation return exanore:annot2json-xml3($annot):)

xqjson:serialize-json($annots2json)
(:$annots2json:)