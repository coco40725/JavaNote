##  Mavern Dependency
### 1. dependencies
Artifacts specified in the ``<dependencies>`` section will ALWAYS be included as a dependency of the child module(s).


### 2. dependencyManagement
`<dependencyManagement> </dependencyManagement>` this tah only define the **version** of `.jar` in all child modules. Also, Artifacts specified in the ``<dependencyManagement>`` section, will only be included in the child module if they were also specified in the ``<dependencies> ``section of the child module itself.

**parent pom.xml**
``` xml
 <!-- child will inherit all content -->
    <dependencies>
        <dependency>
            <groupId>com.google.protobuf</groupId>
            <artifactId>protobuf-java</artifactId>
            <version>3.11.0</version>
        </dependency>
    </dependencies>

    <!-- child will inherit only version-->
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.apache.zookeeper</groupId>
                <artifactId>zookeeper</artifactId>
                <version>3.5.7</version>
            </dependency>
        </dependencies>
    </dependencyManagement>
```

**child pom.xml**
```xml
    <dependencies>
        <dependency>
            <groupId>org.apache.zookeeper</groupId>
            <artifactId>zookeeper</artifactId>
        </dependency>
    </dependencies>
```

### 3. parent
`<parent></parent>` is  to define which parent `pom.xml` is inherited in this child `pom.xml`. That is, This child pom file will inherit all properties and dependencies from the parent POM and can also include extra sub-project-specific dependencies.

**parent pom.xml**
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd;
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.howtodoinjava.demo</groupId>
  <artifactId>MavenExamples</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <packaging>pom</packaging>
 
  <name>MavenExamples Parent</name>
  <url>http://maven.apache.org</url>
 
  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <junit.version>3.8.1</junit.version>
    <spring.version>4.3.5.RELEASE</spring.version>
  </properties>
 
  <dependencies>
   
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>${junit.version}</version>
      <scope>test</scope>
    </dependency>
     
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-core</artifactId>
      <version>${spring.version}</version>
    </dependency>
     
  </dependencies>
</project>
```


**child pom.xml**
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
 
  <!--The identifier of the parent POM-->
  <parent>
    <groupId>com.howtodoinjava.demo</groupId>
    <artifactId>MavenExamples</artifactId>
    <version>0.0.1-SNAPSHOT</version>
  </parent>
 
  <modelVersion>4.0.0</modelVersion>
  <artifactId>MavenExamples</artifactId>
  <name>MavenExamples Child POM</name>
  <packaging>jar</packaging>
 
  <dependencies>    
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-security</artifactId>
      <version>${spring.version}</version>
    </dependency>
  </dependencies>
 
</project>

```


### 4. Maven scope
maven中三種 classpath，包含 編譯，測試，運行，且有4種 scope:
  1. compile：默認範圍，編譯測試運行都有效
  2. provided：在編譯和測試時有效
  3. runtime：在測試和運行時有效
  4. test:只在測試時有效
  5. system:在編譯和測試時有效，與本機系統關聯，可移植性差

classpath 與 scope 的關係如下:
<img src="https://pic1.xuehuaimg.com/proxy/csdn/https://img-blog.csdnimg.cn/20190606102824209.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NzYxODMx,size_16,color_FFFFFF,t_70">
maven 的依賴傳遞姓
只要將對下層的import，該jar 所依賴的上層 jar 也會一併import，
ex. A 依賴 B, B 依賴 C，我們可以僅 import A， B C會自動一起 import。

#### reference
1. https://howtodoinjava.com/maven/maven-parent-child-pom-example/
2. https://stackoverflow.com/questions/49715759/what-is-the-difference-between-parent-parentanddependencydependency-in-m
3. https://stackoverflow.com/questions/8026447/what-does-the-parent-tag-in-maven-pom-represent
4. https://blog.csdn.net/weixin_41979002/article/details/120678635