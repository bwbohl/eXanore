(: eXanore - EXist-db ANnotator stORE API
 : Copyright Benjamin W. Bohl 2014.
 : bohl(at)edirom.de
 :
 : http://www.github.com/edirom/ediromSourceManager
 : 
 : ## Description & License
 : 
 : This file controls the URL handling and rewriting
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

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;


if ($exist:path eq '') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-uri()}/"/>
    </dispatch>
    
else if ($exist:path eq "/") then
    (: forward root path to root.xql :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="modules/root.xql"/>
    </dispatch>
    
else if ($exist:path eq "/annotations" and request:get-method() = 'GET') then
    (: forward annotations-GET path to index.xql :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="modules/index.xql"/>
    </dispatch>

else if ($exist:path eq "/annotations" and request:get-method() = 'POST') then
    let $json := util:base64-decode(request:get-data())
    return (:TODO set view chain and forward create + redirect with id returned form create :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="modules/create.xql" method="POST">
          <add-parameter name="data" value="{$json}"/>
        </forward>
    </dispatch>

else if ($exist:path eq "/annotations/<id>" and request:get-method() = 'GET') then
    (: forward root annotations-get to read.xql :)
    (: TODO: handle id :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="modules/read.xql"/>
    </dispatch>

else if ($exist:path eq "/annotations/<id>" and request:get-method() = 'POST') then
    (: forward root annotations-POST to create.xql :)
    (: TODO: handle id :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="modules/update.xql"/>
    </dispatch>

else if ($exist:path eq "/annotations/<id>" and request:get-method() = 'DELETE') then
    (: forward root annotations-DELETE to delete.xql :)
    (: TODO: handle id :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="modules/delete.xql"/>
    </dispatch>

else if ($exist:path eq "/search" and request:get-method() = 'GET') then
    (: forward root annotations-GET search to search.xql :)
    (: TODO: handle id :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="modules/search.xql"/>
    </dispatch>

else
    (: everything else is passed through :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </dispatch>
