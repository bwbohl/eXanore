(: eXanore - EXist-db ANnotator stORE API
 : Copyright Benjamin W. Bohl 2014.
 : bohl(at)edirom.de
 :
 : http://www.github.com/edirom/ediromSourceManager
 : 
 : search.xql author: Mathias Göbel, SUB Göttingen
 : prepared for TextLab/Kolimo App
 : founded by Campuslabor
 : 
 : ## Description & License
 : 
 : This query is to return the API info
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
import module namespace console="http://exist-db.org/xquery/console";
import module namespace xqjson="http://xqilla.sourceforge.net/lib/xqjson";
import module namespace exanoreParam="http://www.eXanore.com/param" at "params.xqm";

declare option exist:serialize "method=text media-type=text/plain";

(:declare variable $uri := request:get-header('Referer');:)
declare variable $uri := request:get-parameter('uri', '');
(:declare variable $limit := request:get-parameter('limit', '20');
 : LIMIT is ignored at this time :)
declare variable $userId := xmldb:get-current-user();

declare variable $results :=
for $object at $pos in collection($exanoreParam:dataCollectionURI)//pair[@name = "uri"][. = $uri]/parent::item[//pair[@name="read"]/string(.) = ($userId, "")]
(:where $pos <= xs:integer($limit):)
return $object;

declare variable $total := count($results);

declare variable $response := 
    element json {
        attribute type { "object" },
        element pair {
            attribute name { "total" },
            attribute type { "number" },
            $total
        },
        element pair { 
            attribute name { "rows" },
            attribute type { "array" },
            $results
        }
    };

xqjson:serialize-json($response)