## Spring and Spring pom.xml

### 1. Spring MVC
```xml
 <properties>
        <failOnMissingWebXml>false</failOnMissingWebXml>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <spring.version>5.0.3.RELEASE</spring.version>
        <thymeleaf.version>3.0.9.RELEASE</thymeleaf.version>
    </properties>
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>

    <!-- SpringMVC -->
      <dependency>
          <groupId>org.springframework</groupId>
          <artifactId>spring-webmvc</artifactId>
          <version>${spring.version}</version>
      </dependency>


    <!-- 日志 -->
    <dependency>
      <groupId>ch.qos.logback</groupId>
      <artifactId>logback-classic</artifactId>
      <version>1.2.9</version>
    </dependency>


    <!-- ServletAPI -->
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>4.0.0</version>
        <!-- 因為 tomcat 有提供servlet 與 jsp的 jar包，因此，實際運行時是不需要這個jar包的，我們可以直接用 tomcat 提供的     -->
      <scope>provided</scope>
    </dependency>

    <!-- Spring5和Thymeleaf整合包 -->

      <dependency>
          <groupId>org.thymeleaf</groupId>
          <artifactId>thymeleaf-spring5</artifactId>
          <version>${thymeleaf.version}</version>
      </dependency>
  </dependencies>

```

### 2. SpringBoot for tomcat9
```xml
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
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

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


    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
```