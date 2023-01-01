## SpringBoot Hello World 

### 1.配置 pom.xml (使用 tomcat 9)
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>org.example</groupId>
  <artifactId>SpringBoot</artifactId>
  <version>1.0-SNAPSHOT</version>
  <name>Archetype - SpringBoot</name>
  <url>http://maven.apache.org</url>

 <!--
 繼承 spring-boot-starter-parent.xml "pom file" ，
 而 spring-boot-starter-parent.xml 又繼承了spring-boot-dependencies.xml (而此 pom 僅定義了 version) ，
 所以要哪些 .jar包還是要自己指名
 -->
  <parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.7.6</version>
  </parent>

  <dependencies>
    <!-- https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter -->
    <!-- spring-boot-starter-web: 導入 hibernate、springmvc、jackson相關jar包 -->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <!-- spring-boot-starter-web: 導入 hibernate、springmvc、jackson相關jar包 -->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter</artifactId>
    </dependency>

    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-test</artifactId>
      <scope>test</scope>
    </dependency>
  </dependencies>

   <!-- 用於部署 -->
      <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>


```

### 2. 建立主配置類: @SpringBootApplication
@SpringBootApplication 其實是組合註解，它裡面又包含了非常多其他註解
```java
@Target({ElementType.TYPE}) 
@Retention(RetentionPolicy.RUNTIME) 
@Documented 
@Inherited 
@SpringBootConfiguration 
@EnableAutoConfiguration 
@ComponentScan(excludeFilters = {@org.springframework.context.annotation.ComponentScan.Filter(type = org.springframework.context.annotation.FilterType.CUSTOM, classes = {org.springframework.boot.context.TypeExcludeFilter.class}),@org.springframework.context.annotation.ComponentScan.Filter(type = org.springframework.context.annotation.FilterType.CUSTOM, classes = {org.springframework.boot.autoconfigure.AutoConfigurationExcludeFilter.class})}) 
public @interface SpringBootApplication
extends java.lang.annotation.Annotation
```
**@SpringBootApplication**
1. 屬於配置類 (`@SpringBootConfiguration`)
2. 開啟自動配置 (`@EnableAutoConfiguration`):  `@EnableAutoConfiguration` 屬於組合註解
```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@SpringBootConfiguration
@EnableAutoConfiguration
@ComponentScan
```
**其作用是把主配置類(@SpringBootApplication所標註的類)的所在package與下面所有sub-package 的組件，全數掃描進 Spring Containe，所以，配置類不能亂放!否則會報 404**

```java
package com.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @author Yu-Jing
 * @create 2023-01-01-下午 01:28
 */

/*
* @SpringBootApplication: 標註此 class 是 "主程序類"，用於啟動 Spring 
|---- folder1
        |----- folder2
        |---- @SpringBootApplication
|----  folder3
 這樣子僅掃描 folder2
*/
@SpringBootApplication
public class HelloWorldMainApplication {
    public static void main(String[] args) {
        SpringApplication.run(HelloWorldMainApplication.class, args);
    }
}

```

### 3. 建立 controller 
```java
package com.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author Yu-Jing
 * @create 2023-01-01-下午 01:32
 */

@Controller
public class HelloWorldController {
    @RequestMapping("/hello")
    @ResponseBody
    public String hello(){
        return "Hello World";
    }
}

```

### 4. Embedded Tomcat 運行
基本上，SpringBoot內建 Tomcat，而Tomcat版本則是看 `spring-boot-starter-parent` 使用哪個 version 而定。
在 SpringBoot中，我們只要啟動 **主程序類** 即可達到 Embedded Tomcat 運行。


### 5. Deploy Tomcat 部署
傳統上，我們要部署 webapp 的話，需要將其打包成 war 包，然後再把這個 war 包放在 tomcat 下的 webapp folder。而在 SprongBoot中，不需要這麼麻煩，我們只要在 pom.xml 中添加一個 plugin即可，
1. 此plugin可以將我們的webapp 打包成 jar包，(maven-lifecycle-package)，這個jar 會放在 /target 資料夾中。
2. 我們可以直接在 cmd 中使用命令 `java -jar xxx.jar`
3. 完成
```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

6. 快速建立 SpringBoot

使用 Spring Initializr 快速創建 SpringBoot 專案
1. pom.xml 根據你的要求幫你寫好
2. 主配置類 @SpringBootApplication
3. resources 資料夾，該資料夾包含:
    - static folder: 存放css, html 與 js
    - templates folder: 存放模板，例如: html，不支援 jsp；可以使用模板引擎，例如: thymeleaf, freemaker
    - application.properties: SpringBoot默認配置，我們可以修改默認設置。