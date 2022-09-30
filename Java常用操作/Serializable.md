## Java Serializable
>電腦與網路的世界中，所有的資訊都是由01010011等(位元)所組成，因此無論透過任何介質在傳輸資料時，都要先將資料轉換為(位元)。對於Java來說，
Serializable (序列化) 就是將數據結構 (例如: class, 或 variable等) 變成可傳輸的(位元)型式，便可保存到硬碟中或傳輸到網路上，而反序列化則是把位元型式重新組合成原來的數據結構，讀進JVM中。


### 1.  如何使 Class 可以序列化
(1) implements Serializable (較常用) 或 implements Externalizable，值得注意的是 Serializable 是屬於標示接口，也就是接口內部甚麼都沒寫，只是拿來標示用的
(2) 當前class需提供 static final long serialVersionUID，值正負隨意: 545121L 或 -41245L
(3) 保證內部 Field 可序列化，另外，primitive variable 可序列化。

```java
public class Person implements Serializable { //  (1) implements Serializable 
    // (3) Field 可序列化
    private static String name;
    private transient int age;
    private boolean gender;

    // (2) 提供 static final long serialVersionUID
    public static final long serialVersionUID = 42521552L;

    public Person(){}

    public Person(String name, int age, boolean gender) {
        this.name = name;
        this.age = age;
        this.gender = gender;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", gender=" + gender +
                '}';
    }
}

```
---

### 2. 解釋serialVersionUID
serialVersionUID可以看做是這個 class 的 "**標籤**"，雖然JVM本身會自行根據 class 的內容自行生成，但每更動一次class，這個號碼就會改。因此為了保持id的統一性，還是建議自行提供這個id。
* 範例1 : 不提供id ，系統自行生成
          1. 序列化 Person class (系統生成 ID = 123L)，存在硬碟中
          2. 修改 Person class， 系統生成 ID 也跟著變動為 256L。
          3. 反序列化 (1) 的 Person class ，這時系統會去找 Person class + ID = 123L 的 Class，***這時發現找不到，因為 Person class ID更動了***。


* 範例2 : 提供id
         1. 序列化 Person class ，自行寫 ID = 123L，存在硬碟中
         2. 修改 Person class， ID 仍然是 123L。
         3. 反序列化 (1) 的 Person class ，這時系統會去找 Person class + ID = 123L 的 Class， ***找到 Person class + ID = 123L***。

---

### 3. 實現序列化與反序列化
透過 ObjectInputStream 進行反序列化， 與 ObjectOutputStream 進行序列化
* note: ObjectInputStream 與 ObjectOutputStream 不能序列化 static與 transient 所修飾的member variable，雖然過程中不會報錯，但是那個variable的值不會存取，會直接存成預設值。 因此，如果你不想要序列化某個變數，可以可慮添加這個標籤。

```java
/*
序列化過程: 將記憶體中的class 保存到硬碟中 或 通過網路傳輸。
使用ObjectOutputStream 實現
*/
public class InputOutputStreamTest {
    @Test
    public void test(){
        ObjectOutputStream oos = null;
        try {
            FileOutputStream fis = new FileOutputStream("Target Path");
            oos = new ObjectOutputStream(fis);
            oos.writeObject(new String("FUCK YOU! 很酷!"));
            oos.writeObject(new Person("桃園",153,true));
            oos.flush();
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                if (oos != null){
                    oos.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }
}


```


```java
/*
反序列化: 將硬碟中的class 讀進JVM, 即記憶體中。
使用 ObjectInputStream 實現
*/
public class InputOutputStreamTest {
    @Test
    public void test1(){
        ObjectInputStream ois = null;
        String str;
        try {
            FileInputStream fis = new FileInputStream("D:\\Java_lession\\1_basic\\code\\JavaSenior\\day27\\TestClass.dat");
            ois = new ObjectInputStream(fis);

            Object obj = ois.readObject();
            Object obj1 = ois.readObject();
            str = (String) obj;
            Person person = (Person) obj1;
            System.out.println(person);

        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                if (ois != null){
                    ois.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
        System.out.println(str);
    }
}



```
