## JDBC 

### 1. Object Relational Mapping (ORM)
ORM in java 中心思想:
*  Table &rarr;　java 的一個類
* A record &rarr; java 的一個對象
* Column &rarr; java 的一個屬性

---

### 2. JDBC 流程
建立流程:
 1.  建立Properties
 2.  取得連接connection
 3.  撰寫 預編譯SQL
 4.  填充佔位符
 5.  執行sql (並整理資料)
 6.  關閉資源

#### 2.1 建立Properties
將基本資料輸入 Properties，如下:

* 使用 PrepareStatement 連接數據庫，其Properties內容:
```
user=root
password=abc123
url=jdbc:mysql://localhost:3306/test?rewritebatchedstatements=true
DriverClass=com.mysql.cj.jdbc.Driver
```

* 使用 Druid 連接數據庫，其Properties內容:
```
username=root
password=abc123
url=jdbc:mysql://localhost:3306/test?rewritebatchedstatements=true
driverClassName=com.mysql.cj.jdbc.Driver
initialSize=10
maxActive=10
```

url – the URL of the database to which to connect,
格式如下: [協議]: //[ip位址 + port]/[database名稱]，
jdbc:mysql://localhost:3306/test
 - jdbc:mysql 為協議
 - localhost:3306 為ip位址 + port
 - test 為 database



#### 2.2 取得連接connection
建立流程:
1. 載入 properties
2. 撈出 properties 資料
3. 加載 Driver
4. 連接數據庫

* 使用 PrepareStatement 連接數據庫 
```java
public class JDBCUtils {
    // 獲取connection
    public static Connection getConnection() throws Exception {
        Connection connection = null;
        PreparedStatement ps = null;
        // 1. 載入 properties
        InputStream is = ClassLoader.getSystemClassLoader().getResourceAsStream("jdbc.properties");
        Properties properties = new Properties();
        properties.load(is);

        // 2. 撈出 properties 資料
        String user = properties.getProperty("user");
        String password = properties.getProperty("password");
        String url = properties.getProperty("url");
        String driver = properties.getProperty("DriverClass");

        // 3. 加載 driver
        Class.forName(driver);

        // 4. 連接
        connection = DriverManager.getConnection(url, user, password);
        return connection;
        }
}
```

* 使用 Druid 連接數據庫 
```java
public class JDBCUtils {
    // 獲取 connection 使用druid
    public static Connection getConnectionDruid() throws Exception{
        Properties pro = new Properties();
        InputStream is = ClassLoader.getSystemClassLoader().getResourceAsStream("jdbcDruid.properties");
        pro.load(is);

        DataSource dataSource = DruidDataSourceFactory.createDataSource(pro);
        Connection connection = dataSource.getConnection();
        return connection;
    }
}

```

##### 2.2.1 PreparedStatement 與 Statement
**為何 PreparedStatement 會取代 Statement ?**
1. Statement有嚴重的弊端：需要拼寫sql語句，並且存在SQL注入的問題,
>所謂的SQL注入 問題是指 刻意使用 "特殊寫法(此寫法與SQL語法有所關連)" 鑽漏洞，以達到非法訪問， 例如: 帳號隨便輸入，但是密碼輸入aaa' or '1'='1 ，理論上應該訪問失敗，但透過STATEMENT 卻能訪問成功。

原因如下:
```SQL
SELECT user, password
FROM user_table
WHERE user = 'F454D54D5F' AND password = 'aaa' OR '1'='1';
```
2. Preparedstatement 的優勢:
* 可以避免sql注入問題，以防止非訪訪問
* 可以操作Blob類型的數據
* 可以實現高校批量操作


#### 2.3 撰寫 預編譯SQL
引入佔位符"**?**"。
```java
// 增添
String sql = "insert into customers(name, email, birth) values(?,?,?);";

// 刪
String sql = "delete from customers where id = ?";

// 改
 String sql = "update customers set name = ?, email = ?, birth = ? where id = ?; ";

// 查
String sql = "select id, name, email from customers where id = ? OR id = ?;";
```

#### 2.4 填充佔位符
```java
public static void update(Connection conn, String sql, Object... args){
  // args 為佔位符的值
 for (int i = 0; i < args.length; i++){
         ps.setObject(i + 1, args[i]);
    }
}
```

#### 2.5 執行sql
1. **PreparedStatement.execute()**: 無返回值，適用於 insert, delete, update
2. **PreparedStatement.executeQuery()**: return ResultSet，適用於select 

#### 2.6 關閉資源
```java
    public static void closeConnection(Connection con, PreparedStatement ps){
        try {
            if (ps != null)  ps.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        try {
            if (con != null) con.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    public static void closeConnection(Connection con, PreparedStatement ps, ResultSet rs){
        try {
            if (ps != null)  ps.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        try {
            if (con != null) con.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
// 可以透過 overload型式 定義多個方法

```

---

### 3. Data Access Object (DAO)
DAO 結構:
1. **[Class] BaseDAO** : 通用的增刪改操作、通用查詢 multiple instance、通用查詢 single instance、通用查詢Table相關性質。

2. **Table1 相關的物件**:
    * 2.1 **[Interface] Table1DAO** : 針對Table1 這張表，你想要什麼樣的功能? 寫成abstract methods
    * 2.2 **[Class] Table1DAOImpl** : 實現 Table1DAO interface
    * 2.3 **[Class] Table1DAOImplTest** : 檢查 Table1DAOImpl 功能是否正常


3. **Table2 相關的物件**:
   * 3.1 **[Interface] Table2DAO** : 針對Table1 這張表，你想要什麼樣的功能? 寫成abstract methods
   * 3.2 **[**Class] Table2DAOImpl** : 實現 Table2DAO interface
   * 3.3 **[Class] Table2DAOImplTest**  : 檢查 Table2DAOImpl 功能是否正常
... (以此類推，看數據庫有多少Table)

詳細的寫法請見[code](https://github.com/coco40725/JavaNote/tree/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/JDBC_code)

---

### 4. DbUtils 應用
commons-dbutils 封裝了JDBC所有的 增刪改查功能，因此值接調用即可。
1. 增加、刪除與更改: ``` QueryRunner.update(Connection conn, String sql, Object .. args) ```
```java
public class QuerryRunnerTest {
    @Test
    public void test() throws Exception {
        QueryRunner runner = new QueryRunner();
        Connection conn = JDBCUtils.getConnectionDruid();
        String sql = "insert into customers(name,email, birth) values(?,?,?)";
        int dog = runner.update(conn, sql, "Cat", "ssppps@gamil.com", "1995-6-3");
        System.out.println("添加幾條數據?" + dog);
        JDBCUtils.closeConnection(conn,null);
    }
}
```
2. 查詢 instance: ```QueryRunner.query(Connection conn, String sql, ResultSetHandler rsh, Object .. args) ``` 
```java
public class QuerryRunnerTest {
    @Test
    public void test1() throws Exception{
        QueryRunner  runner = new QueryRunner();
        Connection conn = JDBCUtils.getConnectionDruid();
        String sql = "select id, name, birth from customers where id = ?";
        ResultSetHandler<Customer> rsh = new BeanHandler<>(Customer.class);
        Customer customer = runner.query(conn, sql, rsh, 8);
        System.out.println(customer);
        JDBCUtils.closeConnection(conn,null);
    }
}
```

3. 查詢 Table 相關資訊:  ```QueryRunner.query(Connection conn, String sql, ResultSetHandler rsh, Object .. args) ``` 搭配 ```ScalarHandler```

```java
public class QuerryRunnerTest {
    @Test
    public void test3() throws Exception{
        QueryRunner  runner = new QueryRunner();
        Connection conn = JDBCUtils.getConnectionDruid();
        String sql = "select count(1) from customers";
        ScalarHandler rsh = new ScalarHandler();
        Object query = runner.query(conn, sql, rsh);
        query = (Long) query;
        System.out.println(query);
        JDBCUtils.closeConnection(conn,null);
     }
}
``` 
4. 自訂義實現類

```java 
public class QuerryRunnerTest {
    @Test
    public void test4() throws Exception {
        QueryRunner  runner = new QueryRunner();
        Connection conn = JDBCUtils.getConnectionDruid();
        String sql = "select id, name,email, birth from customers where id = ?";

        ResultSetHandler<Customer> rsh = new ResultSetHandler<>() {
            @Override
            public Customer handle(ResultSet rs) throws SQLException {
                if (rs.next()){
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String email = rs.getString("email");
                    Date birth = rs.getDate("birth");
                    return new Customer(id,name, email, birth);
                }else{
                    return null;
                }
            }
        };
        Customer query = runner.query(conn,sql,rsh,8);
        System.out.println(query);
        JDBCUtils.closeConnection(conn,null);
    }
}
```
