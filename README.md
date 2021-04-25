# eXanore
JWT enabled implementation of annotatorjs.org Storage API as eXist-db library
used by the DARIAH-DE Annotation Store.
View, share and export your annotations with the [AnnotationViewer](https://github.com/DARIAH-DE/eXv).

## Build
Call `ant` in the root directory of the repo.

### Dependencies
environment:
* eXist-db >= 2.2

required by installation:
* [XQJson](https://github.com/joewiz/xqjson/blob/master/src/content/xqjson.xql)
* JWT implementation

## Setup
insert your JWT secret in modules/params.xqm at $exanoreParam:JwtSecret

## References
* [AnnotatorJS](http://annotatorjs.org/)
* [Annotator Storage API](http://docs.annotatorjs.org/en/latest/storage.html)
* [JWT](https://jwt.io)

## Limitations
Annotators generic API URLs are not implemented due to limitations in
eXist-db's URL rewrite (DELETE requests not routeable)

## Credits
* First implementation created by Benjamin Bohl: [eXanore](https://github.com/bwbohl/eXanore)
* Further development by Mathias Göbel
* JWT implementation by Ubbo Veentjer

## License
This package is available under the terms of [GNU GPL-3 License](https://www.gnu.org/licenses/gpl.html) a copy of the license can be found in the repository [gpl-3.0.txt](gpl-3.0.txt).
