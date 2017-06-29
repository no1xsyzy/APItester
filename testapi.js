(function(w,d){ "use strict";

var host="http://127.0.0.1";
var testapi=function(obj){
  var tbody=obj.parentElement.parentElement.parentElement;
  var
    url=tbody.querySelector("td.url").innerText,
    method=tbody.querySelector("td.method").innerText,
    pkeys=tbody.querySelectorAll("tr.param td.pkey"),
    optionals=tbody.querySelectorAll("tr.param td.optional"),
    inputs=tbody.querySelectorAll("tr.param input");
  var count=pkeys.length;
  var search="?";
  for(let i=0;i<count;i++){
    if( inputs[i].value === "" && optionals[i].innerText === "Y" ){
      return Promise.reject("Missing field:"+pkeys[i].innerText);
    }
    if( inputs[i].value !== "" ){
      search+=pkeys[i].innerText+"="+inputs[i].value+"&";
    }
  }
  url+=search.slice(0,-1);
  return fetch(host+url, {method})
};

testapi.config={}
testapi.config.setHost=function(newHost){
  host=newHost
}

w.testapi=testapi;

})(window,document);
