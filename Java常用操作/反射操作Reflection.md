## Java Reflection
Java Reflection is a process of examining or modifying the run time behavior of a class at run time.
**The java.lang.Class** class provides many methods that can be used to get metadata, examine and change the run time behavior of a class.
**java.lang.reflect** provide the package which is essential in order to understand reflection.

<img src="https://media.geeksforgeeks.org/wp-content/cdn-uploads/reflection.png" hieight = 50% width = 50%>

### 1. 類的加載過程 Java Class Loader Process
>舉個通俗點的例子來說，JVM在執行某段代碼時，遇到了class A， 然而此時內存中並沒有class A的相關信息，於是JVM就會到相應的class文件中去尋找class A的類信息，並加載進內存中，這就是我們所說的類加載過程。

>由此可見，JVM不是一開始就把所有的類都加載進內存中，而是只有第一次遇到某個需要運行的類時才會加載，且**只加載一次**。

* 加載到記憶體內的類，稱為 "**執行時類**"，此class可視為 "Class" 的一個對象。
    ``` Class p = Person.class ```
* 體現了 "萬事萬物皆對象"
* 另外，只要是加載到記憶體內的結構，皆可以視為 Class的對象。例如: interface, primitive variable , array, enum, 內部類, void, annotation，甚至Class也是。以下列出各種Class的對象:
   * Comparable.class;
   * int[10].class;
   * int.class;
   * ElementType.class;
   *  Override.class;
   *  void.class;
   *  Class.class;
另外，只要數組的類型 與 維度相同，則視為同一個對象

類的加載可以分為: Loading、Linking 與 Initialization

* **Loading (加載)**
簡單來說，是把.class 文件檔通過各種Class Loader加載至記憶體中。這里有兩個重點：

  1. **字節碼來源**: 一般的加載來源包括從本地路徑下編譯生成的.class文件，從jar包中的.class文件，從遠程網絡，以及動態代理實時編譯
  2. **類加載器**: 一般包括啟動類加載器 (Bootstrap Class Loader)，擴展類加載器(Extension Class Loader)，應用類加載器 (Application Class Loader)，以及用戶的自定義類加載器。
**注：為什麼會有自定義類加載器？**
一方面是由於java代碼很容易被反編譯，如果需要對自己的代碼加密的話，可以對編譯後的代碼進行加密，然後再通過實現自己的自定義類加載器進行解密，最後再加載。
另一方面也有可能從非標準的來源加載代碼，比如從網絡來源，那就需要自己實現一個類加載器，從指定源進行加載。



* **Linking (鏈接)**
Linking 又可以細分成: Verify (驗證), Prepare (準備), 與 Resolve(解析)

  1. **Verify (驗證)**
     主要是為了保證加載進來的字節流符合虛擬機規範，不會造成安全錯誤。
     包括
     - **文件格式的驗證**: 常量中是否有不被支持的常量？文件中是否有不規範的或者附加的其他信息？
     - **對於元數據的驗證** : 該類是否繼承了被final修飾的類？類中的字段，方法是否與父類沖突？是否出現了不合理的重載？
     - **對於字節碼的驗證，保證程序語義的合理性** : 要保證類型轉換的合理性。對於符號引用的驗證，比如校驗符號引用中通過全限定名是否能夠找到對應的類？校驗符號引用中的訪問性（private，public等）是否可被當前類訪問？

   2. **Prepare (準備)**
      主要是為類變量（注意，不是實例變量）分配內存，並且賦予初值。特別需要注意，**初值，不是代碼中具體寫的初始化的值，而是JVM根據不同變量類型的默認初始值**。比如8種基本類型的初值，默認為0；引用類型的初值則為null；常量的初值即為代碼中設置的值，final static tmp = 456， 那麽該階段tmp的初值就是456

   3. **Resolve(解析)** 
      將常量池內的符號引用替換為直接引用的過程。兩個重點：
      - **符號引用** : 即一個字符串，但是這個字符串給出了一些能夠唯一性識別一個方法，一個變量，一個類的相關信息。
      - **直接引用** : 可以理解為一個內存地址，或者一個偏移量。比如類方法，類變量的直接引用是指向方法區的指針；而實例方法，實例變量的直接引用則是從實例的頭指針開始算起到這個實例變量位置的偏移量

      舉個例子來說，現在調用方法hello()，這個方法的地址是1234567，那麽hello就是符號引用，1234567就是直接引用。

      在解析階段，虛擬機會把所有的類名，方法名，字段名這些符號引用替換為具體的內存地址或偏移量，也就是直接引用。

* **Initialization (初始化)**
類加載過程只是一個類生命周期的一部分，在其前，有編譯的過程，只有對源代碼編譯之後，才能獲得能夠被虛擬機加載的字節碼文件；在其後還有具體的類使用過程，當使用完成之後，還會在方法區垃圾回收的過程中進行卸載。

<img src="https://javatutorial.net/wp-content/uploads/2017/11/jvm-featured-image-760x330.png" height=45% width=80%>


---

### 2. 如何透過 Reflection 獲得 Class
加載到記憶體的**運行時類**會緩存一段時間，此期間我們可以透過 4 種方式獲得此對象 (唯一) : 
- 類.class
- 對象.getClass()
- Class 的靜態方法(較常使用Class.forName) 
- ClassLoader (前3種需要掌握)。

**問題:  對象的創造應該使用 先前的方法(new) 還是 反射的方法?**
大多數情況還是用先前的方法，當你無法確定要new 甚麼class的時候，再考慮用反射的方法。 例如: 伺服器運行中，伺服器會需要接收使用者的操作，但每一種操作都是一種class，然而伺服器並不知道使用者會調用哪種class，此時可使用反射。(動態性)


```java
public class ReflectionTest {
  @Test
    public void test3() throws ClassNotFoundException {
        // 方式1: 調用運行時類的屬性 class
        Class<Person> clazz1 = Person.class;
        System.out.println(clazz1);

        // 方式2: 通過運行時類的對象， getClass() return .class
        Person p1 = new Person();
        Class clazz2 = p1.getClass();
        System.out.println(clazz2);

        // 方式3: 調用 Class 的靜態方法: forName(String classPath)，路徑要寫完整一點
        Class clazz3 = Class.forName("Test1.Person");
        System.out.println(clazz3);

        System.out.println(clazz1 ==  clazz2); // true
        System.out.println(clazz1 == clazz3); // true

        // 方式4: 使用 ClassLoader
        ClassLoader classLoader = ReflectionTest.class.getClassLoader();
        Class clazz4 = classLoader.loadClass("Test1.Person");
        System.out.println(clazz4);
        System.out.println(clazz1 == clazz4); // true
    }
}

```

---


### 3. 如何透過 Reflection 獲得 Field
* **獲取多個屬性**
  1. getFields() return Field[]: 獲取當前運行時類及其父類的 public 的屬性
  2. getDeclaredFields() return Field[]: 獲取當前運行時類 所有屬性

* **獲取 Field 的權限修飾子** : getModifiers() return int
      Public = 1; PRIVATE = 2; PROTECTED = 4; Default = 0;
* **獲取 Field 的數據類型** : getType() return Class<?>
* **獲取 Field 的變數名** : getName() return String

```java
public class FieldTest {
    @Test
    public void test(){
        Class clazz = Person.class;

        // 獲取多個屬性: getFields() 獲取當前運行時類及其父類的 public 的屬性
        Field[] fields =  clazz.getFields();
        for(Field f : fields){
            System.out.println(f);
        }

        // 獲取多個屬性: getDeclaredFields() 獲取當前運行時類 所有屬性
        System.out.println("*********************");
        Field[] fields1 =  clazz.getDeclaredFields();
        for(Field f : fields1){
            System.out.println(f);
        }
    }

    // 獲取屬性的 權限修飾子、數據類型、變數名
    @Test
    public void test1(){
        Class clazz = Person.class;
        Field[] fields = clazz.getDeclaredFields();

        for (Field f : fields){
            // 獲取權限修飾子: Public = 1; PRIVATE = 2; PROTECTED = 4; Default = 0;
            int modifier = f.getModifiers();
            System.out.print(Modifier.toString(modifier) + "\t") ; // 將數字轉回對應的型態

            // 獲取數據類型
            Class<?> type = f.getType();
            System.out.print(type.getName() + "\t");


            // 獲取變數名
            System.out.print(f.getName() + "\t");
            System.out.println();
        }
    }
}

```
---

### 4. 如何透過 Reflection 獲得 Constructor
* **獲取構造器**
  1. getConstructors() return Constructor[] : 獲取當前運行時類的 public構造器
  2. getDeclaredConstructors() return Constructor[] : 獲取當前運行時類的 所有構造器
* **獲取運行時類的父類** : getSuperclass() return Class
* **獲取運行時類的 帶泛型父類， Type 為interface** : getGenericSuperclass() return Type
* **獲取運行時類的 帶泛型父類的 泛型** : getGenericSuperclass() return Type / ParameterizedType
* **獲取運行時類的 接口** : getInterfaces() return Class
* **獲取運行時類的 所在的package** : getPackage() return Package
* **獲取運行時類的 申明的註解** : getAnnotations() return Annotation[]

```java
public class OtherTest {

    // 獲取構造器
    @Test
    public void  test(){
        Class clazz = Person.class;
        // getConstructors() 獲取當前運行時類的 public構造器
        Constructor[] constructors = clazz.getConstructors();
        for (Constructor c : constructors){
            System.out.println(c);
        }

        System.out.println("***********************");

        // getConstructors() 獲取當前運行時類的 所有構造器
        Constructor[] constructors1 = clazz.getDeclaredConstructors();
        for (Constructor c : constructors1){
            System.out.println(c);
        }
    }

    // getSuperclass() 獲取運行時類的父類
    @Test
    public void test1(){
        Class clazz  = Person.class;
        Class clazz_Par = clazz.getSuperclass();
        System.out.println(clazz_Par);
    }

    // getGenericSuperclass() 獲取運行時類的 帶泛型父類， Type 為interface
    @Test
    public void test2(){
        Class clazz  = Person.class;
        Type clazz_Par = clazz.getGenericSuperclass();
        System.out.println(clazz_Par);
    }

    // getGenericSuperclass()  + ParameterizedType : 獲取運行時類的 帶泛型父類的泛型
    @Test
    public void test3(){
        Class clazz  = Person.class;
        Type clazz_Par = clazz.getGenericSuperclass();
        ParameterizedType parameterizedType = (ParameterizedType) clazz_Par;
        Type[] actualTypeArguments = parameterizedType.getActualTypeArguments();
        System.out.println(actualTypeArguments[0].getTypeName());
    }

    // 獲取運行時類的 接口
    @Test
    public void test4(){
        Class clazz  = Person.class;
        for (Class anInterface : clazz.getInterfaces()) {
            System.out.println(anInterface.getName());
        }

        System.out.println("*******************************");
        for (Class anInterface : clazz.getSuperclass().getInterfaces()) {
            System.out.println(anInterface.getName());
        }
    }

    // 獲取運行時類的 所在的package
    @Test
    public void test5(){
        Class clazz  = Person.class;
        Package p  = clazz.getPackage();
        System.out.println(p.getName());
    }

    // 獲取運行時類的 申明的註解
    @Test
    public void test6(){
        Class clazz  = Person.class;
        Annotation[] a = clazz.getAnnotations();
        for (Annotation aa : a){
            System.out.println(aa);
        }
    }
}
```

---

### 5. 如何透過 Reflection 獲得 Method
* **獲取多個方法** 
  1. getMethods() return Method[]: 獲取當前運行時類及其父類的 public 的方法
  2. getDeclaredMethods() return Method[]: 獲取當前運行時類 所有方法  
* **獲取方法的註解** : getDeclaredMethods() return Annotation
* **獲取權限修飾子** : getModifiers() return int
* **獲取返回值類型** : getReturnType() return Class<?>
* **獲取方法名**: getName() return String
* **獲取形參列表** : getParameterTypes() return Class[]
* **獲取方法異常** : getExceptionTypes() return Class[]

```java
public class MethodTest {

    @Test
    public void test(){
        Class clazz = Person.class;

        //  獲取多個方法: getMethods() 獲取當前運行時類及其父類的 public 的方法
        Method[] methods = clazz.getMethods();
        for (Method m : methods){
            System.out.println(m);
        }
        System.out.println("*********************************");
        // 獲取多個方法: getDeclaredMethods() 獲取當前運行時類 所有方法
        Method[] methods1 = clazz.getDeclaredMethods();
        for (Method m : methods1){
            System.out.println(m);
        }


    }

    // 獲取方法的 權限修飾子、返回值類型、方法名(參數類型1 形參名,....) throws 異常、註解
    @Test
    public void test1(){
        Class clazz = Person.class;
        Method[] methods = clazz.getDeclaredMethods();
        for (Method m : methods){
            
            // 獲取方法的註解: 注意如果要在反射時獲取註解，註解週期必須定為RUNTIME
            for (Annotation annotation : m.getAnnotations()) {
                System.out.println(annotation);
            }

            // 獲取權限修飾子
            int i = m.getModifiers();
            System.out.print(Modifier.toString(i) + "\t");

            // 獲取 返回值類型
            Class<?> returnType = m.getReturnType();
            System.out.print(returnType.getName()+ "\t");

            // 獲取方法名
            System.out.print(m.getName());
            System.out.print("(");

            // 獲取形參列表
            Class[] ParameterTypes = m.getParameterTypes();
            if (ParameterTypes.length != 0  && ParameterTypes != null){
                for (int j = 0; j < ParameterTypes.length; j++) {
                    if (j == ParameterTypes.length - 1) {
                        System.out.print(ParameterTypes[j].getName() + " args_" + j );
                    }else{
                        System.out.print(ParameterTypes[j].getName() + " args_" + j + ", ");
                    }

                }
            }


            System.out.print(")");

            // 獲取方法異常
            Class[] exceptionType = m.getExceptionTypes();
            if (exceptionType.length != 0 && exceptionType != null){
                System.out.print(" throws ");
                for (int j = 0; j < exceptionType.length; j++){
                    if (j == exceptionType.length - 1) {
                        System.out.print( exceptionType[j].getName());

                    }else {
                        System.out.print(exceptionType[j].getName() + " , ");

                    }
                }
            }
            System.out.println();
        }
    }
}

```

---

### 6. 如何透過 Reflection 獲得 Instance
* **newInstance()**: 創建對應的 運行時類 的對象，但是他內部其實是會調用 "空參構造器 Person()" 或 "super()"，因此構造器必須要 "有空參的" 且 "權限不能太小，例如設為 public"。在javabean 中必須提供 空參的構造器且 權限為public，為了方便 "通過反射調對象" 與 "保證父類有構造器"

```java
public class NewInstanceTest {
    @Test
    public void test() throws InstantiationException, IllegalAccessException {
        Class<Person> clazz =  Person.class;
        Person obj = clazz.newInstance();
        System.out.println(obj);
    }
}
```
#### Reference
https://zhuanlan.zhihu.com/p/33509426 
