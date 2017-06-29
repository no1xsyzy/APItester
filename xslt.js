function doXSLT(xmlPath,xslPath,appendDOM){
  return Promise.all([
    new window.DOMParser(),
    new XSLTProcessor(),
    fetch(xmlPath).then(response=>response.text()),
    fetch(xslPath).then(response=>response.text())
  ])
  .then(([domParser,xsltProcessor,xmlStr,xslStr])=>{
    var xmlDoc=domParser.parseFromString(xmlStr, "text/xml");
    var xslDoc=domParser.parseFromString(xslStr, "text/xml");
    return [xsltProcessor, xmlDoc, xslDoc];
  })
  .then(([xsltProcessor, xmlDoc, xslDoc])=>{
    xsltProcessor.importStylesheet(xslDoc);
    var fragment=xsltProcessor.transformToFragment(xmlDoc, document);
    appendDOM.appendChild(fragment);
  })
}
