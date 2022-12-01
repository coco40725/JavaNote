## Java Volatile

### 1. Java Memory Model
<img src="https://img-blog.csdn.net/20170608221857890?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvamF2YXplamlhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" height = 45%>

1.**主內存（Main Memory）**
主內存可以簡單理解為計算機當中的內存，但又不完全等同。主內存被所有的線程所共享，對於一個共享變量（比如靜態變量，或是堆內存中的實例）來說，主內存當中存儲了它的“本尊”。

2.**工作內存（Working Memory）**
工作內存可以簡單理解為計算機當中的CPU高速緩存，但又不完全等同。每一個線程擁有自己的工作內存，對於一個共享變量來說，工作內存當中存儲了它的“副本”。

線程對共享變量的所有操作都必須在工作內存進行，不能直接讀寫主內存中的變量。不同線程之間也無法訪問彼此的工作內存，變量值的傳遞只能通過主內存來進行。 (Thread 直接操作main memory 會沒有效率)

以下給個實際例子
```java
static int s = 0；

Thread A 執行以下code:
s = 3；
```
而JVM 的工作流程如下:

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/JVM1.png" height = 30% width = 30%>

這時候我們加入Thread B，並執行 `` System.out.println("s = " + s) ``

這時JVM 的工作流程有可能出現兩種情況，情況1:

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/JVM2.png" height = 30% width = 30%>


情況2，因為工作內存所更新的變量並不會立即同步到主內存，所以雖然線程A在工作內存當中已經把變量s的值更新成3，但是線程B從主內存得到的變量s的值仍然是0，從而輸出 s=0。

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/JVM3.png" height = 30% width = 30%>

為了避免情況2產生，我們便引入 volatile。

---

### 2. Volatile
volatile關鍵字具有許多特性，其中最重要的特性就是保證了用volatile修飾的變量對所有線程的可見性。

這里的可見性是什麽意思呢？當一個線程修改了變量的值，新的值會立刻同步到主內存當中。而其他線程讀取這個變量的時候，也會從主內存中拉取最新的變量值。

為什麽volatile關鍵字可以有這樣的特性？這得益於java語言的先行發生原則（happens-before）。先行發生原則在維基百科上的定義如下：

>In computer science, the happened-before relation is a relation between the result of two events, such that if one event should happen before another event, the result must reflect that, even if those events are in reality executed out of order (usually to optimize program flow).

在計算機科學中，先行發生原則是兩個事件的結果之間的關系，如果一個事件發生在另一個事件之前，結果必須反映，即使這些事件實際上是**亂序執行的（通常是優化程序流程）**。

這里所謂的事件，實際上就是各種指令操作，比如讀操作、寫操作、初始化操作、鎖操作等等。

先行發生原則作用於很多場景下，包括同步鎖、線程啟動、線程終止、volatile。我們這里只列舉出volatile相關的規則：

**對於一個volatile變量的寫操作先行發生於後面對這個變量的讀操作。**

回到上述的代碼例子，如果在靜態變量s之前加上volatile修飾符：

volatile static int s = 0；

線程A執行如下代碼：
``s = 3；``

這時候我們引入線程B，執行如下代碼：
``System.out.println(“s=” + s);``

當線程A先執行的時候，把s = 3寫入主內存的事件必定會先於讀取s的事件。所以線程B的輸出一定是s = 0。

### 2.1  Volatile 是否保證 Thread-Safety 
答案是: 無法!
考慮以下情況:
>開啟10個線程，每個線程當中讓靜態變量count自增100次。執行之後會發現，最終count的結果值未必是1000，有可能小於1000。

使用volatile修飾的變量，為什麽多線程自增的時候會出現這樣的問題呢？這是因為count++這一行代碼本身並不是原子性操作，在字節碼層面可以拆分成如下指令：

```
getstatic //讀取靜態變量（count）
iconst_1 //定義常量1
iadd //count增加1
putstatic //把count結果同步到主內存
```
<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/JVM4.png" height = 30% width = 30%>

---

### 3. Memory Reording (指令重排)
指令重排是指JVM在編譯Java代碼的時候，或者CPU在執行JVM字節碼的時候，對現有的指令順序進行重新排序。
指令重排的目的是為了在不改變程序執行結果的前提下，優化程序的運行效率。需要注意的是，這里所說的不改變執行結果，指的是不改變單線程下的程序執行結果。

然而，指令重排是一把雙刃劍，雖然優化了程序的執行效率，但是在某些情況下，會**影響到多線程的執行結果**。我們來看看下面的例子：
```java
// Thread A 執行:
context = loadContext();
contextReady = true;

 
// Thread B 執行:
while( ! contextReady ){ 
   sleep(200);
}
doAfterContextReady (context);
```

但是，如果 Thread A執行的代碼發生了指令重排，初始化和contextReady的賦值交換了順序：
```java
// Thread A 執行:
contextReady = true;
context = loadContext();

 
// Thread B 執行:
while( ! contextReady ){ 
   sleep(200);
}
doAfterContextReady (context);
```
這個時候，很可能context對象還沒有加載完成，變量contextReady 已經為true，Thread B 直接跳出了循環等待，開始執行doAfterContextReady 方法，結果自然會出現錯誤。
(需要注意的是，這里java代碼的重排只是為了簡單示意，真正的指令重排是在字節碼指令的層面。)

---

### 4. Memory Barriers
> A memory barrier, also known as a membar, memory fence or fence instruction, is a type of barrier instruction that causes a CPU or compiler to enforce an ordering constraint on memory operations issued before and after the barrier instruction. This typically means that operations issued prior to the barrier are guaranteed to be performed before operations issued after the barrier.

Memory Barriers 共分為四種類型：
1. **LoadLoad Barriers**：
   * 抽象場景：Load1; LoadLoad; Load2
   * Load1 和 Load2 代表兩條讀取指令。在Load2要讀取的數據被訪問前，保證Load1要讀取的數據被讀取完畢。

2. **StoreStore Barriers**：
   * 抽象場景：Store1; StoreStore; Store2
   * Store1 和 Store2代表兩條寫入指令。在Store2寫入執行前，保證Store1的寫入操作對其它處理器可見

3. **LoadStore Barriers**:
   * 抽象場景：Load1; LoadStore; Store2
   * 在Store2被寫入前，保證Load1要讀取的數據被讀取完畢。

4. **StoreLoad LoadStore**
   * 抽象場景：Store1; StoreLoad; Load2
   * 在Load2讀取操作執行前，保證Store1的寫入對所有處理器可見。StoreLoad屏障的開銷是四種屏障中最大的。

#### 4.1 volatile做了什麽？
在一個變量被volatile修飾後，JVM會為我們做兩件事：
1. 在每個volatile寫操作前插入StoreStore屏障，在寫操作後插入StoreLoad屏障。
2. 在每個volatile讀操作前插入LoadLoad屏障，在讀操作後插入LoadStore屏障。

```java
// Thread A 執行
context = loadContext();
contextReady = true;
```
我們給contextReady 增加 volatile 修飾符: ``static volatile contextReady ``，會帶來什麽效果呢？

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C/img/JVM5.png" height = 40% width = 40%>

由於加入了StoreStore屏障，屏障上方的普通寫入語句 context = loadContext()  和屏障下方的volatile寫入語句contextReady = true 無法交換順序，從而成功阻止了指令重排序。

---

### 5. 經典例子
Double Check Singleton Pattern 沒有 volatile，會發生甚麼事?
```java
public final class Singleton {
    private static  Singleton instance = null;
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

```java
memory = allocate(); // 1. 分配記憶體空間
instance(memory); // 2.初始化對象
instance = memory; // 3.設置instance指向記憶體位址，此時 instance != null
```
而由於 instance 沒有使用 volatile，因此步驟2與3可能會重排

```java
memory = allocate(); // 1. 分配記憶體空間
instance = memory; // 3.設置instance指向記憶體位址，此時 instance != null
instance(memory); // 2.初始化對象
```
假設 Thread A 執行到 ```instance = memory;``` 而使 instance != null，而這時 Thread B 要執行以下code:
```java
if (instance != null){
    instance = new Singleton(); 
}
```
但由於instance沒有初始化完全，因此會導致程式出錯。

### 6. Synchronized and volatile
大部分的情況下，擇一即可，兩者的目的都是要讓 multiple thread 得到 consistent value，但採用不同的做法。
* volatile 是透過 memory barrier，保證特定code不進行指令重排，並使的更新的變數"立刻"存到main memory，
使其他的thread可以"得到最新的value"。

* Synchronized 則是可以透過其他方法讓thread之間知道"最新的value是多少"，不需要動用 main memory。
>synchronized ensures you have a consistent view of the data. This means you will read the latest value and other caches will get the latest value. Caches are smart enough to talk to each other via a special bus (not something required by the JLS, but allowed) This bus means that it doesn't have to touch main memory to get a consistent view.

https://stackoverflow.com/questions/11733632/synchronized-data-read-write-to-from-main-memory
#### Reference
https://blog.csdn.net/u013309870/article/details/73088852 

https://blog.51cto.com/u_14982143/2550846

https://blog.51cto.com/u_15303890/3235266
