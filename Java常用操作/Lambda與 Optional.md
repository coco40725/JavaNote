## Java Lambda 與 Optional

### 1. Lambda:
* Lambda的本質: 作為函數式接口的對象
* 適用在 Interface 且只有"**一個方法要override**"，利用Lambda可以達到更為簡潔的寫法
* 格式:
```java
Interface name = (參數名稱) -> {方法體}
/*
-> 稱為 lambda 操作子
(參數名稱) 稱為 lambda形參列表
方法體 稱為 lambda方法體
*/
```
* 如果此接口中，只聲明一個 abstract method，則稱此接口為 **函數式接口**，函數是接口都會有註解 @FunctionalInterface

* Lambda使用的6種情況

#### 1.1 情況1: 無形參，無返回值
```java
public class LambdaTest {
    @Test
    public void test(){
        Runnable runnable = () -> {
            System.out.println("cool!");
        };
    }
}
```

#### 1.2 情況2: 有形參 (指名參數type)，無返回值
```java
public class LambdaTest {
    @Test
    public void test1(){
        Consumer<String> con = (String s) -> {
            System.out.println(s);
        };
        con.accept("GG!");
    }
}
```

#### 1.3 情況3: 有形參 (無需指名參數type，可以自動推斷出來)，無返回值
```java
public class LambdaTest {
   @Test
    public void test2(){
        Consumer<String> con = (s) -> { // 泛型已經暗示一定要input String
            System.out.println(s);
        };
        con.accept("GG!");
    }
}
```

#### 1.4 情況4: 若只需要一個形參，()可以直接省略
```java
public class LambdaTest {
   @Test
    public void test3(){
        Consumer<String> con = s -> {
            System.out.println(s);
        };
        con.accept("GG!");
    }
}
```

#### 1.5 情況5: 兩個以上的形參，多條執行語句，並且可以有返回值
```java
public class LambdaTest {
   @Test
    public void test4(){
        Comparator<Integer> comparator = (o1, o2) -> {
            System.out.println("compare!");
            return Integer.compare(o1,o2);
        };
        comparator.compare(12,33);
    }
}
```

#### 1.6 情況6: 當 Lambda方法體只有一條，return 與 {} 可以省略 (但要一起省略!!)
```java
public class LambdaTest {
   @Test
 public void test5(){
        Comparator<Integer> comparator = (o1, o2) -> Integer.compare(o1,o2);
        comparator.compare(12,33);

    }
}
```
---

### 2. Java 四大函數式接口
函數式接口:
1. Consumer<T> :  void accept(T t)
2. Supplier<T> :  T get()
3. Function<T,R> :  R applt(T t)
4. Predicate<T> : boolean test(T t)

#### 2.1 Consumer< T > 例子
```java
public class LambdaTest1 {
    @Test
    public void test1(){
        happlyTime(500, new Consumer<Double>() {
            @Override
            public void accept(Double aDouble) {
                System.out.println("買東西，價格: " + aDouble);

            }
        });

        System.out.println("****************************");
        happlyTime(400, (money) -> {
            System.out.println("買東西，價格: " + money);
            System.out.println("使用lambda方法!");
        });

        System.out.println("****************************");
        happlyTime(30, money ->  System.out.println("買東西，價格: " + money));
    }


    public void happlyTime(double money, Consumer<Double> con){
        con.accept(money);
    }

}

```


#### 2.2 Predicate< T > 例子
```java

public class LambdaTest1 {
    @Test
    public void test2(){
        List<String> filterList = new ArrayList<>();
        List<String> filterList1 = new ArrayList<>();
        List<String> list = new ArrayList<>();
        list.add("台北");
        list.add("台南");
        list.add("台東");
        list.add("花蓮");
        list.add("綠島");

        filterList =  filterString(list, new Predicate<String>() {
            @Override
            public boolean test(String s) {
                if (s.contains("台")) return true;
                return false;
            }
        });
        System.out.println(filterList);
        System.out.println("***************************************");
        filterList1 = filterString(list, s -> s.contains("台"));
        System.out.println(filterList1);
    }

    public  ArrayList<String> filterString(List<String> list, Predicate<String> pre){
        ArrayList<String> filter = new ArrayList<>();
        for (String s : list){
            if (pre.test(s)) filter.add(s); // 根據規則(test)來判定 式符合還是不符合，而具體的規定要override
        }
        return filter;
    }
}

```

---

### 3. Optional
Optional 相當於是一個容器，且可以避免null pointer的問題
* **Optional.of(T t)** : 創建Optional， t 不可以為null
* **Optional.empty()** : 創建空的Optional
* **Optional.ofNullable(T t)** : t 可以為null
* **Optional.orElse(T t)** : 若Optional裡面的元素為空，則回傳t

```java
public class OptionalTest1 {
    @Test
    public void test(){
        Girl girl = new Girl();
        girl = null;
        Optional<Girl> option = Optional.ofNullable(girl);
        option.orElse(new Girl("林小美"));
        System.out.println(option);

    }

    public String getGirlName(Boy boy){
       return boy.getGirl().getName();
    }


    // 很容易出現null pointer
    @Test
    public void test1(){
        Boy boy = new Boy();
        String girlName = getGirlName(boy);
        System.out.println(boy);

    }

    // 將方法處理成可以回應null的情況

    public String improveGetGirlName(Boy boy){
        if (boy != null && boy.getGirl() != null){
            return boy.getGirl().getName();
        }
        return null;
    }

    @Test
    public void test2(){
        Boy boy = new Boy();
        String girlName = improveGetGirlName(boy);
        System.out.println(girlName);
    }


    // 引入 Optional 可以更有效率的處理null pointer
    public String optionalGetGirlName(Boy boy){
        Optional<Boy> boyOptional = Optional.ofNullable(boy);

        // 若 Boy 是 null ， 則自行創建boy 與 girl
        Boy boy1 = boyOptional.orElse(new Boy(new Girl("王雪紅")));


        Girl girl = boy1.getGirl();

        // 若 Boy 不是 null，而Girl 是 null，則自行創建 girl
        Optional<Girl> girlOptional = Optional.ofNullable(girl);
        Girl girl1 = girlOptional.orElse(new Girl("黃曉"));

        return girl1.getName();

    }

    @Test
    public void test3(){
        Boy boy = new Boy();
        boy = null;
        boy = new Boy(new Girl("大家好!"));
        String girlName = optionalGetGirlName(boy);
        System.out.println(girlName);

    }
}

```
