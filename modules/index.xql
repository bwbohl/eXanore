(: eXanore - EXist-db ANnotator stORE API
 : Copyright Benjamin W. Bohl 2014.
 : bohl(at)edirom.de
 :
 : http://www.github.com/edirom/ediromSourceManager
 : 
 : ## Description & License
 : 
 : This query is implements the Annotator Store API index functionality
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

declare option exist:serialize "method=text media-type=text/plain";

let $annots := <json type="array">{for $json in xmldb:xcollection($exanoreParam:dataCollectionURI)/root() return $json}</json>

return xqjson:serialize-json($annots)