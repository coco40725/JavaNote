## Dispatcher Servlet in Spring
In Spring MVC, all incoming requests go through a single servlet. This servlet - DispatcherServlet - is the front controller.
The job of the DispatcherServlet is to take an incoming URI and find the right combination of handlers (generally methods on Controller classes). 
(去找這個request 對應到 @Controller上的哪個 method)

<img src="https://jeromejaglale.com/wiki/lib/exe/fetch.php?w=&h=&cache=cache&media=java:spring:spring_mvc.png">





### 1. Static content vs Dynamic content
Static content 是儲存在伺服器中的任何檔案，每次傳遞給使用者時都相同。譬如，HTML 檔案和圖像就是此類內容。靜態內容就如報紙一般：一期報紙一旦發行後，拿起一份閲讀的人都會看到相同的文章和照片，不論這一整天發生什麽新的情況。

<img src="https://www.cloudflare.com/resources/images/slt3lc6tev37/1wXlf7IjxWvr2ivJyzC9iv/4acfec55339c30d2c01eee7d80c9a183/caching-static-content.svg" width=60%>

Dynamic content 是根據使用者特定的因素 (例如造訪時間、位置和裝置) 而變化的內容。一個動態網頁在每個人眼中皆不相同，而且可以隨著使用者與之互動而改變，就像報紙能夠在讀者閱讀過程中重新編寫一般。這使得網頁更加個人化，更具互動性。

<img src="https://www.cloudflare.com/resources/images/slt3lc6tev37/6ijRQV6QxiyG4zyidpgJmi/23088f026f5b01cd671274b9b994096f/caching-dynamic-content.svg" width=60%>

### 2. Dispatcher Servlet 攔截 static contents 的問題
一般我們在替 DispatcherServlet servlet 文件會寫成 ``<url-pattern>/</url-pattern>``，以達到攔截所有 request，然而，這樣的寫法卻會與 container 本身的 default servlet 造成衝突，以 tomcat 為例子:
檔案``conf/web.xml``，其中有一段:
```xml
<servlet-mapping>
    <servlet-name>default</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
```
一般container的default servlet 可以處理 request of static contents，然而DispatcherServlet 不具該功能，進而會出現以下情況:
client send request of static contents --> 被 DispatcherServlet 搶先攔截，但又無法處理 --> 出現``[WARN] cannot find handler method`` --> 404 錯誤

為了避免這種情況，有以下兩種解決方案:
#### 2.1 mvc:default-servlet-handler/
當我們在 spring 配置文件中 聲明  `` <mvc:default-servlet-handler/>`` 後， springMVC 框架會在容器中創建 DefaultServletHttpRequestHandler 處理器對象。它會像一個檢查員，對進入 DispatcherServlet的 URL 進行篩查，如果發現是request of static contents，就將該請求轉由 Web 應用服務器 default Servlet 處理。(一般的服務器都有默認的 Servlet)

#### 2.2 mvc:resources/
Spring 3.0 之後的版本，Spring 定義了專門用於處理靜態資源訪問請求的處理器ResourceHttpRequestHandler。
```xml
<!-- 
locaiton 代表的是 static content所在的位置，而該位置"不可以" 
在 WEB-INF 下或其子目錄下。

mapping 表示對該資源的 request，如: /static/xx.jpg 或 /static/uu.html

 -->
<mvc:resources mapping="/static/**" location="static/"/>
```




#### reference
https://stackoverflow.com/questions/2769467/what-is-dispatcher-servlet-in-spring

https://blog.csdn.net/qq_45401910/article/details/122285626
