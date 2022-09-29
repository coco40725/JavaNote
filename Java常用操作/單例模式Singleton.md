## 單例模式 Singleton Pattern
### 0. 目的
最廣泛使用的一種模式，主要是保證在java運行中，某個class僅會產生一個且唯一instance。
應用場景為需要頻繁創建和銷毀的對象、創建對象耗時過多或耗資源太多（重型對象）、工具類對象、頻繁訪問資料庫或者文件的對象（數據源、session工廠等），都應用單例模式去實現。單例模式有非常多種寫法，基本上皆需要滿足以下3個條件:

- **條件1**: 此class只能產生一個且唯一的instance。注意，如果instance是不斷創建覆蓋，縱使從頭到尾只有一個instance，但仍違反"唯一"這個條件。
- **條件2**: 此class自行在內部產生intance，不可在外部透過new()的方式產生instance。***暗示constructor必須設定成private，且getInstance()方法必須設定成static。***
- **條件3**: 此class必須提供方法另外部可以獲得此instance

### 1. 懶漢式 (Lazy Singleton)
- **優點**: 僅在呼叫方法時才創建class，因此不會過度佔用空間。
- **缺點**: 此處的懶漢式寫法存有Thread safety的問題，在multiple Thread 情況下，可能會執行複數次 ``` new Singleton();```  。
- **應用**: 此單例較占空間時可使用此模式。

```java
public final class Singleton {
    private static Singleton instance = null;
    private Singleton1(){}; 

    public static Singleton getInstance(){ 
        if (instance == null){
            instance = new Singleton();  
        }
        return instance;
    }
}

```
### 2. 懶漢式 + 同步方法 (Lazy Singleton with Synchronized Method)
- **優點**: 僅在呼叫方法時才創建class，因此不會過度佔用空間，且避開Thread safety的問題。
- **缺點**: 效率極差。

```java
public final class Singleton {
    private static Singleton instance = null;
    private Singleton1(){}; 

    public static synchronized Singleton getInstance(){ 
        if (instance == null){
            instance = new Singleton();  
        }
        return instance;
    }
}

```

### 3. 懶漢式 + 同步程式碼塊 (Lazy Singleton with Synchronized Code Block)
- **優點**: 僅在呼叫方法時才創建class，因此不會過度佔用空間，效率比方法2高。
- **缺點**: 仍有Thread safety的問題。
```java
public final class Singleton {
    private static Singleton instance = null;
    private Singleton1(){}; 

    public static  Singleton getInstance(){ 
        if (instance == null){
             synchronized(Singleton.class){
                instance = new Singleton();  
             }
        }
        return instance;
    }
}
```

### 4. 餓漢式 (Hurry Singleton)
- **優點**: 簡單，且不會有Thread safety的問題。
- **缺點**: 加載class的時候就會直接創instance，等於是直接先佔用空間。
- **應用**: 此單例較不占空間，且馬上就會使用。
```java
public final class Singleton {
    private Singleton(){}; 

    private static Singleton instance = new Singleton(); 

    public static Singleton getInstance(){ 
        return instance;
    }

}
```

### 4. 雙重檢查 (Double Check) 【推薦】
使用**volatile**特殊修飾符，參考 : [volatile](https://www.baeldung.com/java-volatile-variables-thread-safety)
> If we declare member variable as volatile, each thread sees its latest updated value in the main memory without any delay. 
- **優點**: 解決 Thread safety 問題，且效率也提高。
- **缺點**: volatile 的變數如果使用頻率過高，其效率反而還會低於使用synchronized。

```java
public final class Singleton {
    private static volatile Singleton instance = null;
    private Singleton(){}; 

    public static  Singleton getInstance(){ 
        // 第一次檢查
        if (instance == null){
            synchronized(Singleton.class){
                // 第二次檢查 
                if (instance == null) {
                    instance = new Singleton(); // 馬上更新instance
                }
             }
        } 
        return instance;
    }
}

```

### 5. 靜態內部類 (Static Nested Class) 【推薦】
類似餓漢式的寫法，但又達到了延遲加載的性質，主要是透過 Java類的加載機制來達成，
1. Class的內部結構被JVM加載順序: static code block $\rightarrow$ main method $\rightarrow$ code block $\rightarrow$ Constructor，而內部類則是當你要執行時才會加載。
2. static code block, memeber variable, 與 static inner class，只要加載過一次，就不會再載入。
3. ClassLoader.loadClass() 屬於synchronized method。

如此便同時達到 Thread sadety 與 延遲加載。
> 簡單來說:
Thread A 與 Thread B 都呼叫getInstance()，此時由於 ClassLoader.loadClass() 為synchronized method，因此只能有一個Thread 去加載 static inner class，並執行inner static method 產生instance，待完成所有加載後，便輪到另一個Thread，然而此時卻發現static inner class 已經被加載過了，Thread只能離開，因此從頭到尾只會產生過一次instance。

```java
public final class Singleton {
    private Singleton(){}; 

    // 內部類,其屬性是 目標instance
    private static class innerSingleton{
        private static Singleton instance = new Singleton();
    }

    public static  Singleton getInstance(){ 
        return innerSingleton.instance;
    }
}
```

### 6. 枚舉(Enum) 【推薦】
主要是透過Enum的性質:
1. Enum 的Constructor 皆是 private，無法由外部new()。
2. Enum 的memeber variable 都是 final static，即加載一次後便不會再加載，甚至不可變。

```java
public enum Singleton{
    INSTANCE;

    // INSTANCE的屬性與方法:
    // memeber variable
    int anyVariable = 0;

    // method
    public void doSomething(){
        System.out.println("Do something!");
    }
}
```
調用方式: 
```java
public class Main{
    public static void main(String[] args){
        Singleton.INSTANCE.doSomething();
    }
}
```

#### 總結:
1. 如果是一開始便要使用此class，可以考慮餓漢式寫法。
2. 如果是在寫工具類，則建議使用 "加載延遲" 的寫法。
目前，單例模式推薦的方式有四種：

餓漢式可用（雖然記憶體可能會浪費）；
雙重檢查；
靜態內部類；
枚舉

##### Reference
https://codingnote.cc/zh-tw/p/173410/
https://blog.csdn.net/fly910905/article/details/79286680
