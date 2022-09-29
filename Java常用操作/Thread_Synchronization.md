## Java Thread Synchronization
### 0. Thread Safety 
>Thread safety，指某個函式、函式庫在多執行緒環境中被呼叫時，能夠正確地處理多個執行緒之間的公用變數，使程式功能正確完成。

以購票為例，若存有Thread safety的問題，則會導致 錯票 或 重票的狀況。原因在於 Thread 1 正在執行購票行為時，還沒把 ticket 扣除並更新，結果Thread 2 也跟著過if判斷(因為還沒把票扣除，故仍顯示有票)，然後進來搶票，導致公用變數 (ex. static variable) 出現異常。

```java
if (ticket > 0 ){
 System.out.println(ticket);
ticket --;
 }
```

* 如何解決: 當有Thread在方法體中操作公用變數時，其它的Thread不得進入，直到Thread 處理完畢離開，其它Thread才可進入! 即使方法體裡面的Thread出現阻塞，其它Thread亦不可進入!
* 在Java中我們會使用 同步機制 (Synchronized)來解決。雖然說同步機制可以預防安全問題，然而這樣的操作卻使方法體變成 "**Single Thread
**"，效率降低。

以下提供兩種方式: Synchronized Code Block 與 Synchronized Method

### 1. Synchronized Code Block
格式如下:
```java
synchronized ( 同步監視器 ){ // 對象可以作為同步監視器
   需要同步的code，即有操作公用變數的 code!
 }

```
---

### 2. Synchronized Method
如果操作共享數據的code正好在一個方法中，則可以把這個方法聲明成 synchronized method。另外，synchronized method 也是有監視器 (或稱為鎖)，它是用 this 或 當前類.class 來充當。

```java
private synchronized boolean buyTicket() //非靜態方法，默認的鎖為 this
private static synchronized boolean buyTicket() //靜態方法，默認的鎖為 當前類.class
```
---

### 3. 簡易例子
仍以購票為例，使用Synchronized Code Block 或 Synchronized Method 來達到 Thread Safety。

#### 3.1 使用 Synchronized Code Block 
```java
class Window extends Thread{
    private static int ticket = 10000; // 讓所有對象共用同一個變數
    private static Object obj = new Object(); // 必須保證所有thread共用同一個鎖

    @Override
    public void run() {
        while (true){
            synchronized (obj) { // 或使用 Window.class ，這個只會存一個
                if (ticket > 0 ) {
                    System.out.println(this.getName() + " 賣票，票號: " + ticket);
                    ticket--;
                }else {
                    break;
                }
            }
        }
    }
}

public class WindowTest2 {
    public static void main(String[] args) {
        Window w1 = new Window();
        Window w2 = new Window();
        Window w3 = new Window();

        w1.setName("Window 1");
        w2.setName("Window 2");
        w3.setName("Window 3");

        w1.start();
        w2.start();
        w3.start();

    }

}

```

#### 3.2 使用 Synchronized Method

```java
class Window1 implements Runnable{
    private int ticket = 10000; // 不需要 static !
    Object obj = new Object(); // 必須共用一個鎖
    @Override
    public void run() {
        boolean is_ticket = true;
        while (is_ticket){
             is_ticket = buyTicket();
        }
    }

    private synchronized boolean buyTicket(){
        if (ticket > 0 ) {
            System.out.println(Thread.currentThread().getName() + " 賣票， 票號: " + ticket);
            ticket--;
            return true;
        }else{
            System.out.println(Thread.currentThread().getName() + ": 沒票了，滾啦!");
            return false;
        }
    }
}

public class WindowTest1 {
    public static void main(String[] args) {
        Window1 w1 = new Window1(); // 都是使用同一個 w1，故不需要對 ticket加 static!
        Thread t1 = new Thread(w1);
        Thread t2 = new Thread(w1);
        Thread t3 = new Thread(w1);

        t1.start();
        t2.start();
        t3.start();
    }
}

```

#### 3.3 公共變數
- 使用 Thread class 實現 Multiple Thread時，由於會創建多個 Thread instance，故需要將公共變數設定成 static。
- 使用 Runnable 實現 Multiple Thread時，由於僅實現一次Runnable instance 並將這一個 instance 作為Thread class constructor 參數，故不需要特別將公共變數設定成 static。

---

### 4. Thread Communication : 
複數個Thread 交互使用，例如:  使 Thread 1 與 Thread 2 交互print 出 1~100。
常用的method包含 notify ()、 notifyall() 與 wait() :
1. **wait()**: Thread進入阻塞，並將同步監視器拋出，換言之，別的Thread可以進入synchronized code block。
2. **notify()**: 喚醒正在 被wait的 single Thread，若有多個被wait()則喚醒優先級高的。
3. **notifyall()**: 喚醒正在 wait的 all thread

這三種方法有以下4種特性:
1. 這三種methods 必須使用在 synchronized () 或 synchronized method ; 不適用在 lock unlock
2. 這3個method 必須由 synchronized () 或 synchronized method 中 的 "**同步監視器**" 進行調用，否則會出現IllegalMonitorStateException，正確的調用方式如下:
```java
synchronized (this){
 this.notify();
 this.wait();
}

synchronized (obj){
 obj.notify();
 obj.wait();
}

```
3. 這三個方法其實是在 Object class中定義的
4. sleep 與 wait的差異:

    a. **定義位置**: sleep是定義在 Thread class 中; wait是定義在 Object class
    
    b. **調用的範圍**: sleep可以在任何需要的場景下調用; wait則需要被 "同步監視器" 調用，故只能在 synchronized () 或 synchronized method 中 使用
    
    c. **是否釋放同步監視器**: sleep不釋放; wait會釋放

#### 4.1 實現 Thread 1 與 Thread 2 交互print數字
```java
class Number implements Runnable{
    private int num = 1;
    private Object obj = new Object();

    @Override
    public void run() {
        while(true){
            synchronized (obj) {
                obj.notify();
                if (num <= 500){
                    System.out.println(Thread.currentThread().getName()+ ", 輸出數字: " + num);
                    num++;
                    try {
                        obj.wait();
                    } catch (InterruptedException e) {
                        throw new RuntimeException(e);
                    }
                } else{
                    break;
                }
            }
        }
    }
}

public class ThreadCommunication {
    public static void main(String[] args) {
        Number num = new Number();
        Thread t1 = new Thread(num);
        Thread t2 = new Thread(num);

        t1.start();
        t2.start();


    }
}

```
