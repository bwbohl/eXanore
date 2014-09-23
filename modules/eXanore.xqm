xquery version "3.0";

module namespace exanore="https://www.exanore.com";

declare namespace json="http://www.json.org";

declare function exanore:returnAsArray($node as element()) as element(pair)?{
  
  if($node eq ($node/parent::*/*[name() = name($node)])[1])
  then(
    element pair {
      attribute type {'array'},
      attribute name {local-name($node)},
      for $item in $node | $node/following-sibling::*[name() = name($node)]
      return
        element item {
          attribute type {'string'},
          fn:string($item) cast as xs:string
        }
    }
  )
  else()
  
};

declare function exanore:returnPairSting($node){

  element pair {
    attribute type {'string'},
    fn:string($node)
  }

};

declare function exanore:returnPairNameString($node){

  element pair {
    attribute type {'string'},
    attribute name {local-name($node)},

    fn:string($node)
  }

};

declare function exanore:returnAttributeObject($node){

  element pair {
    attribute type {'object'},
    attribute name {local-name($node)},
    for $attribute in $node/@*
    return exanore:returnPairNameString($attribute)
  }

};

declare function exanore:annot2json-xml3($xml){

  switch(local-name($xml))
  case 'annotation' return(
    element pair {
      attribute type {'object'},
      attribute name {local-name($xml)},
      for $child in $xml/@* | $xml/*
      return exanore:annot2json-xml3($child)
    }
  )
  case 'ranges' return (
    element pair {
      attribute name {local-name($xml)},
      attribute type {'array'},
      for $range in $xml/range
      return exanore:returnAttributeObject($range)
    }
  )
  case 'tags' return exanore:returnAsArray($xml)
  case 'permissions' return (
    element pair {
      attribute name {local-name($xml)},
      attribute type {'object'},
      for $perm in $xml/*
      return exanore:returnAsArray($perm)
    }
  )
  case 'tags' return exanore:returnAsArray($xml)
  default return(
    typeswitch($xml)
    case attribute() return exanore:returnPairNameString($xml)
    case element() return(
      if(exists($xml/@* |$xml/*))
      then(
        element pair {
          attribute name {local-name($xml)},
          attribute type {'array'},
          for $child in $xml/@* | $xml/* 
          return
            exanore:annot2json-xml3($child)
        }
      )
      else(
       exanore:returnPairNameString($xml)
      )
    )
    default return()
  )

  
};