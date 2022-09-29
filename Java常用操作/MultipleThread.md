## Java Multiple Thread
> Multithreading in Java is a process of executing two or more threads simultaneously to maximum utilization of CPU. Multithreaded applications execute two or more threads run concurrently. Hence, it is also known as Concurrency in Java. Each thread runs parallel to each other. Mulitple threads don’t allocate separate memory area, hence they save memory. Also, context switching between threads takes less time.

目前有兩種方式創建 Multiple Threads : Thread Class 與 Runnable Interface

### 1. Thread Class
1. 創建繼承Thread的subclass。
2. override Thread class 的 ```void run() ``` method，  將想要執行的code 聲明於 ```void run() ``` 中。
3. 創建subclass對象。
4. 通過此對象調用此```void start() ``` method，注意 不可以讓已經start的thread，再start，會報illegalthreadstateexception (因為 thread status != 0)。

```java
//1. 創建繼承Thread的子類
class Myclass extends Thread{
        //2.  override Thread類 的 run method，  將想要執行的code 聲明的run method中
    @Override
    public void run() {
        // print 1~100 之偶數
        for (int i = 0; i < 101; i++){
            if (i % 2 == 0) System.out.println(Thread.currentThread().getName() + ": " + i);
        }
    }
}


public class ThreadTest {
    public static void main(String[] args) {
        //  3. 創建子類對象
        Myclass mythread = new Myclass();
        Myclass mythread1 = new Myclass();

        // 4. 通過此對象調用此start method: 啟動新的thread (Thread 1 )--> 調用 thread run method
        mythread.start();
        mythread1.start(); 

        // 是主線程執行，且與Thread 1 "同時"執行
        for (int j = 0; j < 500; j++) {
            System.out.println(Thread.currentThread().getName() + ": " + j); 
          
        } 
    }

}

```
---

### 2. Runnable Interface
1. 創建一個實現 Runnable Interface 的 class。
2. 實現 Runnable 的 abstract method, 即 ```void run() ``` method。
3. 創建 Runnable Interface Impl class 其 instance 。
4. 將此 instance 作為 formal parameter 加入 Thread class 的 Constructor。
5. 通過Thread class 調用 ```void start() ``` method。


```java
// 1. 創建一個實現runnable 接口的類
class Mythread implements Runnable{

    // 2. 實現 runnable的 abstract method, 即run method
    @Override
    public void run() {
        for (int i = 0; i < 101; i++) {
            if (i % 2 == 0) System.out.println(Thread.currentThread().getName() + ": " + i);
        }
    }
}

public class ThreadTest1 {
    public static void main(String[] args) {
        //3. 創建 實現類 的instance
        Mythread m1 = new Mythread();

        //4. 將此instance 作為 formal parameter 加入 Thread constructor
        Thread t1 = new Thread(m1);
        Thread t2 = new Thread(m1);

        //5. 通過thread class 調用 start
        t1.start(); 
        t2.start();
    }
}


```
---

### 3. Thread Class 常用方法
1. **start()**: 啟動 當前thread 並調用 當前thread的run function
2. **run()**: 方法體為 欲執行的code，通常需要override
3. **currentThread()**: static method, return 當前thread (return Thread class)
4. **getName()**: 取得當前thread name (return String)
5. **setName(String)**: 設置當前thread 名字
6. **yield()**: 釋放當前cpu的執行權，讓cpu重新選擇要執行哪個thread(有可能又回到執行此thread!)
7. **join()**: 在 thread A 中調用 thread B .join，此時，thread A 會進入暫停狀態， 直到 thread B 執行完畢， thread A才會再次執行
8. **stop()**: thread 強制結束， 此方法已過時不推薦使用。
9. **sleep(long milltime)**: static method, 使當前 thread 進入休眠，自訂休眠時間。
10. **isAlive()**: 判斷當前thread 是否還在執行
11. **Thread Priority**:
     - MAX = 10
     - NORM = 5
     - MIN = 1
12. **setPriority(int newPriority)**: 設定優先度
13. **getPriority()**: 取得當前thread的優先度
Note: 這裡的 priority高，只代表 "高機率" 此thread會被cpu選中執行


