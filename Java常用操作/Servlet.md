## 透過 Intellij Idea 建立 Servlet 
###  Intellij Idea Ultimate
**總流程:**
1. 建立 Project
2. 對此 Project  Add FrameWork Support
3. 在 WEB-INF 資料夾中增加 classes 和 lib 兩個資料夾
4. 將 output 路徑換到classes路徑
5. 將欲使用的 Library 放置 lib並載入
6. 創建 Servlet 的 class 並編寫內容
7. 使用 Tomcat 執行此　class
8. 完成

**詳細流程含圖文，如下:**
#### 1. 建立 Project
建立一般java project

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU1.png" height="50%" width="50%">

#### 2.對此 Project  Add FrameWork Support
選擇 javaEE &rarr; Web Application

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU2.png" height="50%" width="50%">

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU3.png" height="50%" width="50%">

#### 3. 在 WEB-INF 資料夾中增加 classes 和 lib 兩個資料夾

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU4.png" height="50%" width="50%">


#### 4. 將 output 路徑換到classes路徑

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU5.png" height="50%" width="50%">

#### 5. 將欲使用的 Library 放置 lib並載入

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU6.png" height="50%" width="50%">

#### 6. 創建 Servlet 的 class 並編寫內容
注意: 必須將 ``super.deGet(req, resp)`` 與 ``super.doPost(req, resp)``  刪除，否則會出現 405 錯誤。

```java
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/ServletTest1")
public class ServletTest1 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // super.deGet(req, resp)
        resp.getWriter().write("my first server!! Fuck you");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // super.doPost(req, resp)
    }
}

```

#### 7. 使用 Tomcat 執行此　class
選擇 Tomcat server - Local

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU7.png" height="50%" width="50%">

注意，需要特別處理 Warning: No artifacts marked for deployment，點選 fix

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU8.png" height="50%" width="50%">

將 Project 名字填入 Application context，例如: /Test，這裡沒設定好會一直出現404錯誤。

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU9.png" height="50%" width="50%">

#### 8. 完成

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU10.png" height="50%" width="50%">

---

###  Intellij Idea Community
若要做java web 相關開發，**建議使用 Intellij Idea Ultimate**，而Community版本雖然也能做，但需要下載很多插件且有許多設定要自行處理，以下提供Intellij Idea Community 將如何建立 Servlet。

**總流程:**
1. 建立 Project
2. 在 WEB-INF 資料夾中增加 classes 和 lib 兩個資料夾; 在 main 資料夾下，創建 java 資料夾
3. 將 output 路徑換到classes路徑
4. 將欲使用的 Library 放置 lib並載入
5. 創建 Servlet 的 class 並編寫內容
6. 下載 smart tomcat 
7. 修改 web.xml 
8. 使用 Tomcat 執行此　class
9. 如果有出現錯誤: java: error: release version 5 not supported， 請依序排錯:
    * 於 pom.xml 新增properties來指定maven版本
    * Java Project 版本確認是否正確
    * Java Module 版本確認是否正確
    * Java Complier Target bytecode version 版本確認是否正確 (通常都是這裡有問題)
10. 完成

**詳細流程含圖文，如下:**
#### 1. 建立 Project
使用 Maven Archetype，而 Archetype 選擇 webapp

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC1.png" height="50%" width="50%">

#### 2. 在 WEB-INF 資料夾中增加 classes 和 lib 兩個資料夾; 在 main 資料夾下，創建 java 資料夾

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC2.png" height="50%" width="50%">


#### 3. 將 output 路徑換到classes路徑

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC3.png" height="50%" width="50%">

#### 3. 將欲使用的 Library 放置 lib並載入

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC4.png" height="50%" width="50%">


#### 5. 創建 Servlet 的 class 並編寫內容
注意: 必須將 ``super.deGet(req, resp)`` 與 ``super.doPost(req, resp)``  刪除，否則會出現 405 錯誤。
```java
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/ServletTest1")
public class ServletTest1 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // super.deGet(req, resp)
        resp.getWriter().write("my first server!! Fuck you");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // super.doPost(req, resp)
    }
}

```

#### 6. 下載 smart tomcat 

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC5.png" height="50%" width="50%">

#### 7. 修改 web.xml 成如下:
如果沒有修改，會出現404錯誤

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC404.png" height="50%" width="50%">

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
</web-app>
```

#### 8. 使用 Tomcat 執行此　class
選擇 smart tomcat

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC6.png" height="50%" width="50%">

注意: deployment directory 位置不要寫錯，否則會出 404 錯誤。

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC7.png" height="50%" width="50%">

#### 9. (如果有出現以下錯誤) 請依以下流程排錯
```java
java: error: release version 5 not supported
Module Test1 SDK 17 does not support source version 1.5. 
Possible solutions:
- Downgrade Project SDK in settings to 1.5 or compatible. Open project settings.
- Upgrade language version in Maven build file to 17. Update pom.xml and reload the project.

```

1. 於 pom.xml 新增properties來指定maven版本
``` xml
  <properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
  </properties>
```

2. Java Project 版本確認是否正確

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC8-1.png" height="50%" width="50%">

3. Java Module 版本確認是否正確

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC8-2.png" height="50%" width="50%">

4. Java Complier Target bytecode version 版本確認是否正確 (通常都是這裡有問題)

以下圖發現 Target bytecode version  是不正確的，必須將1.5改成17

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC8-3.png" height="50%" width="50%">

#### 10. 完成
<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC9.png" height="50%" width="50%">
