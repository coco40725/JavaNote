## Import war into IDEA
原生的 IDEA 無法直接接受WAR檔而 Eclipse 可以，因此如果要把 WAR 加入至 IDEA，可以先用 Eclipse 加載後再加進 IDEA。

### 0. 將 war 檔加入 Eclipse，變成 project
<img src="https://github.com/coco40725/JavaNote/blob/main/JavaWeb/img/import1.png?raw=true" width="70%">

### 1. 將 Eclipse project 加載至 IDEA 中
* File→New→Project from Existing Sources。
<img src="https://img-blog.csdnimg.cn/img_convert/b32f05cb6d06c8f4b60b2f5ce9a7df64.png" width="70%">
* import project from Eclipse
<img src="https://img-blog.csdnimg.cn/img_convert/bc0bff728213c8162bf540c2cbcc9912.png" width="70%">
* keep clicking "next" and Finish
<img src="https://img-blog.csdnimg.cn/img_convert/67526fb204c88734e437269ef9ef009f.png" width="70%"> 
<img src="https://img-blog.csdnimg.cn/img_convert/83ffa0faecc76971af7b3009dbb782ef.png" width="70%">

### 2. 調整 dependencies
* 移除紅色的lib
<img src="https://github.com/coco40725/JavaNote/blob/main/JavaWeb/img/import2.png?raw=true"  width="70%">

* 加入 web lib
<img src="https://github.com/coco40725/JavaNote/blob/main/JavaWeb/img/import3.png?raw=true"  width="70%">

* 設定 Application Server 
<img src="https://github.com/coco40725/JavaNote/blob/main/JavaWeb/img/import8.png?raw=true" width="70%">

* 加入 tomcat as lib
<img src="https://github.com/coco40725/JavaNote/blob/main/JavaWeb/img/import7.png?raw=true" width="70%">

### 3. 於 Facets 新增 Web
<img src="https://github.com/coco40725/JavaNote/blob/main/JavaWeb/img/import4.png?raw=true" width="70%">

並檢查webapp 的路徑
<img src="https://github.com/coco40725/JavaNote/blob/main/JavaWeb/img/import5.png?raw=true" width="70%">

### 4. 新增 Artifact
<img src="https://img-blog.csdnimg.cn/img_convert/5604ce2dad99ca2e05774e3215100d86.png" width="70%">

### 5. 完成!

#### reference
https://blog.csdn.net/yrq205/article/details/117108910
