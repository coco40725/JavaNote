# Servlet 登入

### 1. 建立 login.html
* form label: 用於裝需要傳輸出去的資料
    - action : The action attribute defines the location (URL) where the form's     collected data should be sent when it is submitted.[資料要傳到哪裡.]
    - method : The method attribute defines which HTTP method to send the data with (it can be "get" or "post"). [定義用哪個 HTTP 方法(get 或 post)發送數據。預設用 get]

* get 
    - 通常用來跟 web server 請求查看資源(不修改資源)。
    - 用 get 方法發送表單，發送的數據會附加到URL。

* post 
    - 用來將數據發送到 web server 以 create/update 資源。
    - 用 post 方法發送表單，發送的數據不會附加到URL，而是附加到 HTTP 請求的 body。

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<form action="http://localhost:8080/WebApp1/login" method="post">
    帳號: <input type="text" name="name"> <br>
    密碼: <input type="password" name="password"> <br>
    <button type="submit">登入</button>
</form>

</body>
</html>
```

### 2. 建立 Servlet 
#### 2.1 建立 Servlet class
當點開 login.html， 並於裡面輸入 
帳號: admin 
密碼: 123 
login.html 會自動跳轉到 http://localhost:8080/WebApp1/login (並且資料送到這個位置)， 接著調用對應的Servlet處理送進來數據，評估帳密是否為 admin 與 123，若是，則Servlet 會response html，使畫面會顯示 success，若帳密輸入錯誤則顯示 fail。



```java
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // request
        String name = req.getParameter("name");
        String password = req.getParameter("password");
        String html = null;

        if ("admin".equals(name) && "123".equals(password)) {
            html = "<div style='color:green'>success</div>";
        }else{
            html = "<div style='color:red'>fail</div>";
        }

        // response
        PrintWriter pw = resp.getWriter();
        pw.println(html);
    }
}
```

#### 2.2 設定Servlet連接
基本上會有一個Web.xml檔案（或者可以用annotation的方式設定），告訴我們的Container（例如Tomcat）當某一個路徑進來的時候，請呼叫哪一個Servlet來處理。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
    <servlet>
        <servlet-name>TestServlet</servlet-name>
        <servlet-class>TestServlet</servlet-class>
    </servlet>
    <servlet>
        <servlet-name>LoginServlet</servlet-name>
        <servlet-class>LoginServlet</servlet-class>
    </servlet>

    <servlet-mapping>
        <servlet-name>TestServlet</servlet-name>
        <url-pattern>/TestServlet/*</url-pattern>
    </servlet-mapping>

    <servlet-mapping>
        <servlet-name>LoginServlet</servlet-name>
        <url-pattern>/login</url-pattern>
    </servlet-mapping>
</web-app>

```

### 3. 測試
1. 點開 login.html
2. 輸入 帳號: admin / 密碼: 123 
3. 網頁自動跳轉至 http://localhost:8080/WebApp1/login 並回報 success


###### tags: `Java Note` `Java 常用操作` `Servlet` `Servlet登入`