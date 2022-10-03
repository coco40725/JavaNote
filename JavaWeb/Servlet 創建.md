# 建立 Servlet (By Intellij Idea)
### Servlet 
#### 1. what is Servlet 

Servlets are the Java programs that run on the Java-enabled web server or application server. They are used to **handle the request** obtained from the webserver, process the request, produce the response, then **send a response back** to the webserver. And A web container (Servlet container) is the component of a web server that interacts with or control the Java servlets.

#### 2. Servlet lify Cycle

There are five steps: 
1. Load Servlet Class.
2. Create Instance of Servlet.
3. Call the servlets init() method.
4. Call the servlets service() method.
5. Call the servlets destroy() method.

Step 1, 2 and 3 are executed only once, when the servlet is initially loaded. By default the servlet is not loaded until the first request is received for it. You can force the container to load the servlet when the container starts up though.

Step 4 is executed multiple times - once for every HTTP request to the servlet.
Step 5 is executed when the servlet container unloads the servlet.

<img src="https://s1.o7planning.com/en/10169/images/12877.png">


#### 3. Execution of Servlets 

Basically involves the following steps:
1. The clients send the request to the Web server.
2. The Web server redirects the request to the servlet container
3. The servlet container redirects the request to the appropriate servlet.
4. The servlet is dynamically retrieved and loaded into the address space of the container, if it is not in the contain
5. The servlet container invokes servlet ``init ()`` method once when the servlet is loaded first time for initialization.
6. The servlet container invokes the ``service ()`` methods of the servlet to process the HTTP request, i.e., read data in the request and formulate a response. The servlet remains in the container’s address space and can process other HTTP requests.
7. The servlet generates the response in the form of output.
8. The servlet sends the response back to the webserver.
9. The web server sends the response back to the client and the client browser displays it on the screen


<img src="https://qph.cf2.quoracdn.net/main-qimg-69b5c1ed78f885e6e2ff7d1c373f0324">



---


### web.xml
A web application's deployment descriptor describes the classes, resources and configuration of the application and how the web server uses them to serve web requests. When the web server receives a request for the application, it uses the deployment descriptor to map the URL of the request to the code that ought to handle the request.

The deployment descriptor is a file named web.xml. It resides in the app's WAR under the WEB-INF/ directory. 

#### 1. \<servlet>
The ``<servlet>`` element **declares the servlet**, including a name used to refer to the servlet by other elements in the file, the class to use for the servlet, and initialization parameters. You can declare multiple servlets using the same class with different initialization parameters. The name for each servlet must be unique across the deployment descriptor.

```xml
<servlet>
    <!--    Servlet 名字  -->
    <servlet-name>redteam</servlet-name> 
     <!--    Servlet 的 class，需要Fully Qualified Name，即包含package名稱  -->
    <servlet-class>mysite.server.TeamServlet</servlet-class>
    
    <init-param>
        <!--    Paramwter 名字  -->
        <param-name>teamColor</param-name>
        <!--    Paramwter 初始值 -->
        <param-value>red</param-value>
    </init-param>
    
    <init-param>
        <param-name>bgColor</param-name>
        <param-value>#CC0000</param-value>
    </init-param>
    
</servlet>
```
    

#### 2. \<servlet-mapping>
The ``<servlet-mapping>`` element **specifies a URL pattern and the name of a declared servlet to use for requests whose URL matches the pattern**. The URL pattern can use an asterisk (*) at the beginning or end of the pattern to indicate zero or more of any character. The standard does not support wildcards in the middle of a string, and does not allow multiple wildcards in one pattern. The pattern matches the full path of the URL, starting with and including the forward slash (/) following the domain name.

``` xml
<servlet-mapping>
    <!--    Servlet 名字  -->
    <servlet-name>redteam</servlet-name>
    <!--    當使用此url時，會去調用上面的servlet -->
    <url-pattern>/red/*</url-pattern>
</servlet-mapping>

<servlet-mapping>
    <servlet-name>blueteam</servlet-name>
    <url-pattern>/blue/*</url-pattern>
</servlet-mapping>

```
With this example, a request for the URL http://www.example.com/blue/teamProfile is handled by the TeamServlet class, with the teamColor parameter equal to blue and the bgColor parameter equal to #0000CC. The servlet can get the portion of the URL path matched by the wildcard using the ServletRequest object's getPathInfo() method.

#### 3. @WebServlet(String name, String urlPattern)

This annotation is processed by the container at deployment time, and the corresponding servlet made available at the specified URL patterns.

在servlet3.0以後，我們可以不用再web.xml裡面配置servlet，只需要加上@WebServlet註解就可以修改該servlet的屬性了。

```java
@WebServlet(name="HelloWorld", urlPatterns={"/helloworld"})
```

---


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

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU1.png?raw=true" height="50%" width="50%">

#### 2.對此 Project  Add FrameWork Support
選擇 javaEE &rarr; Web Application

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU2.png?raw=true" height="50%" width="50%">

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU3.png?raw=true" height="50%" width="50%">

#### 3. 在 WEB-INF 資料夾中增加 classes 和 lib 兩個資料夾

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU4.png?raw=true" height="50%" width="50%">


#### 4. 將 output 路徑換到classes路徑

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU5.png?raw=true" height="50%" width="50%">

#### 5. 將欲使用的 Library 放置 lib並載入

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU6.png?raw=true" height="50%" width="50%">

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

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU7.png?raw=true" height="50%" width="50%">

注意，需要特別處理 Warning: No artifacts marked for deployment，點選 fix

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU8.png?raw=true" height="50%" width="50%">

將 Project 名字填入 Application context，例如: /Test，這裡沒設定好會一直出現404錯誤。

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU9.png?raw=true" height="50%" width="50%">

#### 8. 完成

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletU10.png?raw=true" height="50%" width="50%">



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

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC1.png?raw=true" height="50%" width="50%">

#### 2. 在 WEB-INF 資料夾中增加 classes 和 lib 兩個資料夾; 在 main 資料夾下，創建 java 資料夾

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC2.png?raw=true" height="50%" width="50%">


#### 3. 將 output 路徑換到classes路徑

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC3.png" height="50%" width="50%">

#### 3. 將欲使用的 Library 放置 lib並載入

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC4.png?raw=true" height="50%" width="50%">


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

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC5.png?raw=true" height="50%" width="50%">

#### 7. 修改 web.xml 成如下:
如果沒有修改，會出現404錯誤

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC404.png?raw=true" height="50%" width="50%">

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
    <servlet>
        <servlet-name>ServletTest1</servlet-name>
        <servlet-class>ServletTest1</servlet-class>
    </servlet>

    <servlet-mapping>
        <servlet-name>ServletTest1</servlet-name>
        <url-pattern>/ServletTest1/*</url-pattern>
    </servlet-mapping>
</web-app>
```

#### 8. 使用 Tomcat 執行此　class
選擇 smart tomcat

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC6.png?raw=true" height="50%" width="50%">

注意: deployment directory 位置不要寫錯，否則會出 404 錯誤。

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC7.png?raw=true" height="50%" width="50%">

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

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC8-1.png?raw=true" height="50%" width="50%">

3. Java Module 版本確認是否正確

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC8-2.png?raw=true" height="50%" width="50%">

4. Java Complier Target bytecode version 版本確認是否正確 (通常都是這裡有問題)

以下圖發現 Target bytecode version  是不正確的，必須將1.5改成17

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC8-3.png?raw=true" height="50%" width="50%">

#### 10. 完成
<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/servletC9.png?raw=true" height="50%" width="50%">

##### Reference
https://o7planning.org/10169/java-servlet
https://cloud.google.com/appengine/docs/flexible/java/configuring-the-web-xml-deployment-descriptor


###### tags: `Java Note` `Java 常用操作` `Servlet` `建立 Servlet`
