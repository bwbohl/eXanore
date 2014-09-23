xquery version "3.0";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

(:
<div class="row">
            <div class="col-md-12">
              <ul>
                <li>annotation format: <a href="http://docs.annotatorjs.org/en/latest/annotation-format.html">http://docs.annotatorjs.org/en/latest/annotation-format.html</a></li>
                <li>asorage API requirements: <a href="http://docs.annotatorjs.org/en/latest/storage.html">http://docs.annotatorjs.org/en/latest/storage.html</a></li>
              </ul>
              
            </div>
          </div>
:)

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
    (: forward root annotations-POST to create.xql :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="modules/create.xql"/>
    </dispatch>

else if ($exist:path eq "/annotations/" and request:get-method() = 'GET') then
    (: forward root annotations-POST to create.xql :)
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
    (: forward root annotations-POST to create.xql :)
    (: TODO: handle id :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="modules/delete.xql"/>
    </dispatch>

else if ($exist:path eq "/search" and request:get-method() = 'GET') then
    (: forward root annotations-POST to create.xql :)
    (: TODO: handle id :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="modules/search.xql"/>
    </dispatch>

else
    (: everything else is passed through :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </dispatch>
