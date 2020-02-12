## json转string
```javascript
  var json = {"name":"bzc","sex": 0}
  console.log(json);// 输出json
  //格式化json串，转换string，缩进两个空格
  var formatJsonStr=JSON.stringify(json,undefined, 2);
  console.log(formatJsonStr);
  //单纯把json转换成string
  var jsonStr = JSON.stringify(json,undefined);
  console.log(jsonStr);
```

## string转json
```javascript
  var jsonStr = "{\"name\":\"bzc\",\"sex\": 0}";
  console.log(jsonStr);

  var json = eval("(" + jsonStr + ")");
  console.log(json)
```

## 判断json为空
```javascript
if (!$.isEmptyObject(jsonArray)) {
//		paramStr = paramStr.substring(0,paramStr.length - 1);
        serviceCheck(jsonArray);
    }
```
