## Java Multiple Thread
> Multithreading in Java is a process of executing two or more threads simultaneously to maximum utilization of CPU. Multithreaded applications execute two or more threads run concurrently. Hence, it is also known as Concurrency in Java. Each thread runs parallel to each other. Mulitple threads don’t allocate separate memory area, hence they save memory. Also, context switching between threads takes less time.

目前有四種方式創建 Multiple Threads : Thread Class 、 Runnable Interface 、 Callable Interface 、Thread Pool

### 1. Thread Class
#### 1.1 創建流程
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
#### 2.1 創建流程
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

---

### 4. Callable Interface
#### 4.1 創建流程
1. 創建一個實現Callable的類
2. override call method，將Thread欲操作的code，聲明其中，且此方法可以有返回值
3. 於main方法:
       3.1  創建 實現Callable的類 之對象
       3.2  創建 FutureTask 類的對象
       3.3  啟動thread: 將FutureTask 作為參數填入Thread class
       3.4  (option): 使用Callable的類 中的get 方法調出call的返回值


```java
// 1. 創建一個實現Callable的類
class NumThread implements Callable{
    // 2. override call method，將thread欲操作的code，聲明其中，且此方法可以有返回值
    @Override
    public Object call() throws Exception {
        int sum = 0;
        for (int i = 0 ; i < 101 ; i++){
            if (i % 2 == 0){
                System.out.println(i);
                sum += i;
            }
        }
        return sum;
    }
}


public class ThreadNew {
    public static void main(String[] args) {
        // 3.1 創建 實現Callable的類 之對象
        NumThread thread1 = new NumThread();
        // 3.2 創建 FutureTask 類的對象
        FutureTask task = new FutureTask(thread1);
        // 3.3 啟動thread: 將FutureTask 作為參數填入Thread class
        new Thread(task).start(); // 因為Callable 也實現了 Runnable


        // 3.4 (option): 使用Callable的類 中的get 方法調出call的返回值
        try {
            // get method的返回值 即為 Callable call method(override) 所回傳的值
            Object sum = task.get();
            System.out.println("總合為: " + sum);

        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        } catch (ExecutionException e) {
            throw new RuntimeException(e);
        }
    }
}

```
#### 4.2 Callable 的特性
1. Callable call() 可以有返回值
2. Callable call() 可以throw Exception
3. Callable 支持泛型

---

### 5. Thread Pool 【推薦】
> Thread Pool 的概念如同其名，就是一個 Thread 的 Pool，
其中有固定或變動量的 Thread，當 request 進來時，若有閒置的 Thread 就執行，
若沒有的話，可能產生新的 Thread 或把 request 放入 queue 中等待被執行，
當一條 Thread 執行完工作而 queue 中仍有 request 在等待時，
此 Thread 應該要被分發新的 request 並處理。

由以上幾行，我們可以看出 Thread Pool 的工作有：
- 管控 Thread 的產生與回收
- 分發 Thread 處理 request
- 處理 request 的 queue

#### 5.1 創建流程
1. 創建池子: ExecutorService service = Executors.newFixedThreadPool(10)
  a. newFixedThreadPool: 固定數量thread的池子
  b. newScheduledThreadPool: 給定延遲後執行thread 或 週期性執行
  c. newSingleThreadExecutor: 只有一個thread
  d. newCachedThreadPool: 可根據需要創建thread

2. 啟動Thread: service.execute(Runnable) 或 service.submit(Callable)
3. 關閉Thread: service.shutdown()
4. (optional)，若使用callable想要取得return 值，則需要使用futureTask!

```java
class NumThread1 implements Runnable{


    @Override
    public void run() {
        for (int i = 0; i < 101; i++){
            if (i % 2 == 0) {
                System.out.println(Thread.currentThread().getName() + ": " + i);
            }
        }
    }
}
class NumThread2 implements Runnable{


    @Override
    public void run() {
        for (int i = 0; i < 101; i++){
            if (i % 2 != 0) {
                System.out.println(Thread.currentThread().getName() + ": " + i);
            }
        }
    }
}

class NumThread3 implements Callable {


    @Override
    public Object call() throws Exception {
        for (int i = 0; i < 101; i++){
            if (i % 3 == 0) {
                System.out.println(Thread.currentThread().getName() + ": " + i);
            }
        }
        return 123;
    }
}


public class ThreadPool {
    public static void main(String[] args) throws ExecutionException, InterruptedException {
        ExecutorService service = Executors.newFixedThreadPool(10); // 創一個池子

        // 設定 Thread Pool的屬性
        System.out.println(service.getClass()); // ThreadPoolExecutor
        ThreadPoolExecutor service1 = (ThreadPoolExecutor) service;
        service1.setCorePoolSize(5);


        NumThread3 numThread3 = new NumThread3();
        FutureTask futureTask = new FutureTask(numThread3);
        // newFixedThreadPool ()會返回 ExecutorService，而 ExecutorService 為 interface

        // 從pool中分發thread 給NumThread1()、NumThread2() 與 futureTask
        service.execute(new NumThread1());  //  輸入 Runnable，開啟thread
        service.execute(new NumThread2());  // 輸入 Runnable，開啟thread
        service.submit(futureTask); //  輸入 Callable，開啟thread

        // 若想return ，則要使用 FutureTask
        Object num = futureTask.get();
        service.shutdown(); // 關掉
        System.out.println("輸出" + num);

    }
}
```


#### 5.2 Thread Pool 屬性 
* **corePoolSize**: 核心池的大小
* **maximumPoolSize**: 最大thread 數量
* **keepAliveTime**: thread閒置時，最多保持多久時間後便終止
值得注意的是這些屬性不在ExecutorService Interface中，而是在其實現類ThreadPoolExecutor中。
```java
public class ThreadPoolExecutor extends AbstractExecutorService
abstract public class AbstractExecutorService implements ExecutorService
```
#### 5.3 Thread Pool 好處
1. 減少重複創建 / 刪除 thread的時間與流程
2. 降低資源消耗
3. 便於管理，可以控制各種屬性
因此開發中常用Thread Pool。




