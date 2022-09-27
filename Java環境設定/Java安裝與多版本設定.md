## Java安裝與多版本設定 

### 1. Java 下載位置:

https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html 
<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E7%92%B0%E5%A2%83%E8%A8%AD%E5%AE%9A/img/web_img1.png" width="60%" height="60%" >

Note: Java9之後便不需要額外下載jre，因為其jdk已包含jre了。



### 2. 將資料夾解壓縮後，放在專門的位置 (自訂):
<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E7%92%B0%E5%A2%83%E8%A8%AD%E5%AE%9A/img/java_img1.png" width="60%" height="60%" >

### 3. 確認除步驟2外的位置中，沒有Java檔案，若有則需要移除，
例如:

C:\Program Files\Common Files\Oracle\Java\javapath 需移除java.exe 等

C:\Program Files (x86)\Common Files\Oracle\Java\javapath 需移除java.exe 等

可以於 terminal執行 where java 確認是否有額外的java


### 4. 於 "系統變數" 建立 JAVA_HOME，值則填入 欲使用的JAVA版本路徑
<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E7%92%B0%E5%A2%83%E8%A8%AD%E5%AE%9A/img/java_img2..png" width="60%" height="60%" >


### 5. 於 "系統變數"的PATH加入 %JAVA_HOME%\bin，須至頂
<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E7%92%B0%E5%A2%83%E8%A8%AD%E5%AE%9A/img/java_img3..png" width="60%" height="60%" >

### 6. 開啟”java設定”，點選Java --> 點選 View --> 勾選你要的版本
<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E7%92%B0%E5%A2%83%E8%A8%AD%E5%AE%9A/img/java_img4..png" width="60%" height="60%" >
