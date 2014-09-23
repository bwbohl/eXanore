xquery version "3.0";

(:
TODO return something like {
  "name": "Annotator Store API",
  "version": "2.0.0"
}
:)

import module namespace config = "http://www.edirom.de/tools/eXanore/config" at "config.xqm";

declare namespace json="http://www.json.org";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

(: Switch to JSON serialization :)
declare option output:method "json";
declare option output:media-type "application/json";

config:expath-descriptor()