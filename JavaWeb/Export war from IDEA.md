## Export war file from IDEA
### 1. 新增 plugin 於 maven
`` <packaging>war</packaging>``


### 2. 將sources code 加進 war 中
在 ``pox.xml`` 中添加此code
``` xml
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-war-plugin</artifactId>
                <version>3.3.2</version>
                <configuration>
                    <webResources>
                        <resource>
                            <directory>${project.build.sourceDirectory}</directory>
                            <targetPath>WEB-INF/classes</targetPath>
                        </resource>
                    </webResources>
                </configuration>
            </plugin>
        </plugins>
    </build>

```

https://stackoverflow.com/questions/3642811/how-to-generate-a-war-with-the-source-code-in-maven

### 3. 執行 war:war
