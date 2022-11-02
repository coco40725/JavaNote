## Proxy Pattern
>代理顧名思義就是代理原本的物件 (Real Subject) 去處理事情，但注意真正做事的依舊是原本的物件，代理的角色只是客戶端接觸原物件的第一道關卡，負責卡控客戶端對原物件的存取。代理模式的使用時機為，當不想讓客戶端（呼叫端/調用端）直接使用原本的物件，則可以建立一個原物件的 代理物件 (Proxy) 讓客戶端來使用。

<img src="https://www.mscharhag.com/files/2020/proxy-pattern.jpg" height="30%" width="60%">

### 1. Static Proxy Pattern (靜態代理模式)
**靜態代理舉例**: 直接創建 代理類 與 被代理類，即 在編譯期間兩類都被確定下來。換言之，10個被代理類 就要有 10個對應的代理類，如此非常繁瑣! 因此衍生出另一個做法: 動態代理。

**靜態代理流程**:
1. 創建 1個 Interface 並將欲被執行的method 宣告其中
2. 創建 1個 Real Subject 被代理類 並 implement Interface
3. 創建 1個 Proxy 代理類 並 implement Interface


```java
public class StaticProxyTest {
    public static void main(String[] args) {
        // 1. 創建被代理類
        ClothFactory nikeClothFactory = new NikeClothFactory();

        // 2. 創建代理類
        ClothFactory proxtClothFactory = new ProxtClothFactory(nikeClothFactory);

        // 3. 調用Interface override方法
        proxtClothFactory.productCloth();
    }
}


// 代理類 Proxy
class ProxtClothFactory implements ClothFactory{

    private ClothFactory factory; // 有實現此interface 之 被代理類
    public ProxtClothFactory(ClothFactory factory){
        this.factory = factory;
    };

    @Override
    public void productCloth() {
        System.out.println("代理工廠做一些準備工作!!");
        factory.productCloth(); // 調用此對象的productCloth()
        System.out.println("代理工廠做一些收尾工作!!");
    }
}

// 被代理類 Real Subject
class NikeClothFactory implements ClothFactory{

    @Override
    public void productCloth() {
        System.out.println("Nike生產一批衣服");
    }
}

// Interface
interface ClothFactory{
    void productCloth();
}

```
---
### 2. Dynamic Proxy Pattern (動態代理模式)
動態代理的概念在於 編譯期間我們僅創建 多個 "被代理類" 與 1個 "用於製造代理類的類" ， 而code執行過程中，會根據你輸入的是什麼樣的 被代理類，來創建對應的代理類。

**動態代理流程**:
1. 創建多個 Interface 並將欲被執行的method 宣告其中
2. 創建多個 Real Subject 被代理類 並 implement Interface
3. 創建1個 ProxyFactory: 用來生產代理類的一個 class

```java
public class ProxyTest {
    public static void main(String[] args) throws InstantiationException, IllegalAccessException {
        // 1. 創建被代理類對象
        Superman superman = new Superman();

        // 2. 根據被代理類 創建 代理類對象
        Object proxyInstance = ProxyFactory.getProxyInstance(superman); // 可以看成 Object proxyInstance = new 代理類(含有interface)，

        //接著，我想調用代理類的中override interface的方法
        // 3. Object 強轉成 interface，才能調用
        Human proxyInterface = (Human) proxyInstance;

        String str = proxyInterface.getBelief();

        proxyInterface.eat("水果!"); // 代理類的interface method 是 寫成 "調用被代理類的method"
        System.out.println(str);

        System.out.println("*******************************************");

        // 以下體現 代理類產生器 的廣用性!!
        // 第2個被代理類，也是使用"同一個代理類產生器"!
        NikeClothFactory nikeClothFactory = new NikeClothFactory();
        Object clothInstance = ProxyFactory.getProxyInstance(nikeClothFactory);
        ClothFactory clothInterface = (ClothFactory) clothInstance;
        clothInterface.productCloth();
    }
}

// 創建 ProxyFactory: 用來生產代理類的 一個 class
class ProxyFactory{
    // 通過此方法，返回代理類的對象
    public static Object getProxyInstance(Object obj) throws InstantiationException, IllegalAccessException { // obj 為 被代理類的對象
        MyinvocationHandler handler = new MyinvocationHandler(); // 需要引入 invoke()
        handler.bind(obj);
        return Proxy.newProxyInstance(obj.getClass().getClassLoader(), obj.getClass().getInterfaces(), handler);
    }
}

class MyinvocationHandler implements InvocationHandler{
    private Object obj; //需要使用被代理類的對象進行賦值
    public void bind(Object obj){
        this.obj = obj;
    }

    // 當我們通過 代理類的對象 調用 方法A時，便會自動調用以下的方法: invoke()
    // 將 被代理類 要執行的方法A，聲明在 invoke() 中
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        // 代理類對象所調用method，而 我們實質是調用  被代理類對象(obj)的method
       Object returnValue = method.invoke(obj,args);

        util.method2();
       return returnValue;
    }
}


// Real Sunject 被代理類1
class Superman implements Human{

    @Override
    public String getBelief() {
        return "I AM STRONG!!";
    }

    @Override
    public void eat(String food) {
        System.out.println("喜歡吃" + food);
    }
}


// interface
interface Human{
    String getBelief();
    void eat(String food);
}

```
