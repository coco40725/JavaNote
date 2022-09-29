## 使用 module-info.java (Java 9 的特性)
### 0. module-info.java 功能
module-info.java 可以用於宣告module間的相依性以及其公開性，因此當我們需要讓部分結構 (例如: class, method等) 是 "**跨module**" 來執行時，
便會透過編輯module-info.java來達到此目的。

### 1. module-info.java 寫法
```
module [module的名稱]{

 exports [欲對外暴露的package];
 
 requires [欲依賴的module];
 
}
```

### 2. 簡易範例

* module A 含有 pcakage Book

* module B

假設想要在module B 調用 module A 中的package Book，則

- 於 module A 創建 module-info.java 
```
module A{
 exports Book;
}
```
- 於 module B  創建 module-info.java 
```
module B{
 requires A;
}
```
### 3. 指令介紹
* ***exports [package]*** : We use the exports directive to expose "all public members" of the named package
* ***exports [package] to [module]*** : Similar to the exports directive, we declare a package as exported. But, we also list "which modules we are allowing to import this package" as a requires. Let's see what this looks like:
* ***requires [module]*** : This module directive allows us to declare module dependencies.
* ***requires static [module]*** : we create a compile-time-only dependency.
* ***requires transitive [module]*** : we can use the requires transitive directive to force any downstream consumers also to read our required dependencies.

For example:

The modules depending on bar are the ones that are impacted by transitive: Any module that reads bar can also read drink. In other words readability of drink is implied (which is why this is called implied readability). A consequence is that customer can access drink's types.
So if bar requires transitive drink and customer requires bar, then customer can read drink even though it doesn't explicitly depend on it.
<img src = "https://i.stack.imgur.com/fbZwV.png">
* **uses [interface or abstract class]*** : We designate the services our module consumes with the uses directive. Note that the class name we use is either the interface or abstract class of the service, not the implementation class:
* ***provides [interface or abstract class] with [implements]***: A module can also be a service provider that other modules can consume.
* ***open module [module]{...}*** : Before Java 9, it was possible to use reflection to examine every type and member in a package, even the private ones. Nothing was truly encapsulated, which can open up all kinds of problems for developers of the libraries. Because Java 9 enforces strong encapsulation, we now have to explicitly grant permission for other modules to reflect on our classes. "An open module grants reflective access to all of its packages to other modules."
* ***open module[module]*** : we now have to explicitly grant permission for other modules to reflect on our classes.
* ***opens[package]*** : If we need to allow reflection of private types, but we don't want all of our code exposed, we can use the opens directive to expose specific packages. (只允許在執行期間能存取特定套件)
* ***opens[package] to [module]*** : We can selectively open our packages to a pre-approved list of modules, in this case, using the opens…to directive(只允許在執行期間讓指定模組能存取特定套件).

### 4. 常見問題
#### 4.1 Caused by: java.lang.module.InvalidModuleDescriptorException: Test1.class found in top-level directory (unnamed package not allowed in module)

此錯誤是因為沒有把classs 定義在 package 中，只要把class 放進package即可解決

#### 4.2 Caused by: java.lang.reflect.InaccessibleObjectException: Unable to make public main1.Test1() accessible: module moduleC does not "exports main1" to module org.testng

當你使用JUnit Test的時候，便有可能出現此錯誤，此錯誤是代表 "執行JUnit Test" 的module 其 "module-info.java" 少寫 exports [package] to org.testng，補上即可解決。

#### 4.3 Caused by: java.lang.RuntimeException: java.lang.reflect.InaccessibleObjectException: Unable to make field private java.lang.String Test.Customer.name accessible: module statement does not "opens Test" to module DAO

當你要export的package，裡面有class, method等結構，其隱私性屬於 private，則若要另其他module可以使用這類型的class的話，便必須將預暴露的module設定成open，如下:
```java
open module statement {
    requires java.sql;
    requires org.testng;
    exports Util;
    exports Test; // 裡面的class其屬性為private
}
```

#### 4.4 java: cannot access javax.naming.spi.ObjectFactory. class file for javax.naming.spi.ObjectFactory not found
[ref](https://stackoverflow.com/questions/46488346/error32-13-error-cannot-access-referenceable-class-file-for-javax-naming-re)
當你有使用module-info.java時，同時又有用DataSources 時，則有可能會出現此錯誤，只要將module-info.java 新增 requires java.naming; 即可解決。

---
#### Reference

https://blog.csdn.net/qq_43472877/article/details/104171769

https://www.baeldung.com/java-9-modularity

https://stackoverflow.com/questions/46502453/whats-the-difference-between-requires-and-requires-transitive-statements-in-jav

https://medium.com/java-magazine-translation/%E7%90%86%E8%A7%A3-java-9-%E7%9A%84%E6%A8%A1%E7%B5%84-4aa30e1c7df9

https://stackoverflow.com/questions/46482364/what-is-an-open-module-in-java-9-and-how-do-i-use-it
