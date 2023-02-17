## SperingBoot DataBase yml config
### 1. MySQL 
```yml
spring:
  datasource:
    # 如果有使用 Atomikos，則要加 pinGlobalTxToPhysicalConnection=true，否則會出現 XAER_INVAL: Invalid arguments (or unsupported command)
    url: jdbc:mysql://111.111.111.111/myDB?pinGlobalTxToPhysicalConnection=true
    username: root
    password: aaaaa
    driver-class-name: com.mysql.cj.jdbc.Driver
    type: com.zaxxer.hikari.HikariDataSource

    # 解決（springboot項目）mysql表名大寫，造成jpa Table doesn't exist問題
    jpa:
      hibernate:
        naming:
          physical-strategy: org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
```

### 2. MongoDB
```yml
spring:
  data:
    mongodb:
      uri: mongodb://username:password@111.111.111.111:27017/mysb?authSource=admin
      username: username
      password: password
```

