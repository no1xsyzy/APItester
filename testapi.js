(function(w){"use strict";

var host="http://localhost";
var testapi=function(obj){
  var tbody=obj.parentElement.parentElement.parentElement;
  w.tbody=tbody;
  var
    url=tbody.querySelector("td.url").innerText,
    method=tbody.querySelector("td.method").innerText,
    pkeys=tbody.querySelectorAll("tr.param td.pkey"),
    optionals=tbody.querySelectorAll("tr.param td.optional"),
    inputs=tbody.querySelectorAll("tr.param input");
  var count=pkeys.length;
  var search="?";
  (()=>{
    for(let i=0;i<count;i++){
      if( inputs[i].value === "" && optionals[i].innerText === "N" ){
        return Promise.reject("Missing field: "+pkeys[i].innerText);
      }
      if( inputs[i].value !== "" ){
        search+=pkeys[i].innerText+"="+inputs[i].value+"&";
      }
    }
    url+=search.slice(0,-1);
    return fetch(host+url, {method})
  })()
  .then(function(response){
    var statusLine=response.status+" "+response.statusText;
    var resHeaders="";
    for(let [k,v] of response.headers){
      resHeaders+=k+": "+v+"\n";
    }
    var resBody=response.text();
    return Promise.all([
      statusLine,
      resHeaders,
      response.headers.get("content-type").split("/")[1],
      resBody
    ]);
  })
  .then(function([statusLine,resHeaders,resType,resBody]){
    const entityMap = {
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#39;',
      '/': '&#x2F;',
      '`': '&#x60;',
      '=': '&#x3D;'
    };
    let newHTML=
    '<tr class="response tester">\
      <td rowspan="3" class="key">\u54cd\u5e94\u6d4b\u8bd5</td>\
      <td class="key">HTTP\u54cd\u5e94\u72b6\u6001\u7801</td>\
      <td class="width-3" colspan="3">\
      <pre><code class="language-http">'+statusLine+'</code></pre></td>\
    </tr>\
    <tr class="tester">\
    <td class="key">HTTP\u54cd\u5e94\u5934</td>\
    <td class="width-3" colspan="3"><pre><code class="language-http">'+resHeaders+'</code></pre></td>\
    </tr>\
    <tr class="tester">\
    <td class="key">HTTP\u54cd\u5e94\u4f53</td>\
    <td class="width-3" colspan="3">\
    <pre><code class="language-'+resType+'">'+
    (resBody).replace(/[&<>"'`=\/]/g, s=>entityMap[s]);
    +'</code></pre>\
    </td>\
    </tr>';
    tbody.querySelectorAll("tr.tester")
      .forEach((el)=>{el.parentElement.removeChild(el)});
    var m=tbody.querySelector("tr.response");
    m.outerHTML=newHTML+m.outerHTML;
    tbody.querySelectorAll("tr.tester code").forEach((el)=>{
      Prism.highlightElement(el);
    });
  })
  .catch(function(error){
    console.error(error)
  })
};

testapi.config={}
testapi.config.setHost=function(newHost){
  host=newHost
}

w.testapi=testapi;

})(window);
