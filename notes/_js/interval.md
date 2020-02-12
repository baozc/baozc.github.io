```javascript
var clock_interval = setInterval("clock()",1000);
function clock()
{
  var d=new Date();
  var t=d.toLocaleTimeString();
  document.getElementById("clock").value=t;
}
function stop(){
  window.clearInterval(clock_interval);
}
```
