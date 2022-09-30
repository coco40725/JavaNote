## Java Generic
>  泛型 Generic: 用於限制集合裡面的變數類型，但不支援 primitive variable

### 1. 如何自定義 Generic 結構?
* 泛型類、泛型interface: 當你不確定某個屬性的類型時，可以使用
``` java
public class Demo<T> {
    public void show(T t){
        System.out.println(t);
    }
}

interface Inter<T>{
    void show(T t);
}
```

``` java
public class GenericTest {
    @Test
    public void test(){
        ArrayList<Integer> arrayList = new ArrayList<Integer>();
        arrayList.add(44);
        arrayList.add(62);
    }

    @Test
    public void test1(){
        // Map<String, Integer> map = new HashMap<String, Integer>();
        Map<String, Integer> map = new HashMap<>(); // 等價上面的寫法
        map.put("MEATBALL",95);
        map.put("DOG",20);
        map.put("CAT",63);

        // 泛型的嵌套
        // Entry 是 Map的內部interface
        Set<Map.Entry<String, Integer>> entry =  map.entrySet(); 
        Iterator<Map.Entry<String, Integer>> iterator = entry.iterator();

        while (iterator.hasNext()){
            Map.Entry<String, Integer> entry1 = iterator.next();
            System.out.println("key = " + entry1.getKey() + "------> " + "value = " + entry1.getValue());
        }
    }
}
```
* 泛型方法 : 在方法中出現了泛型結構，但是 此泛型結構與 類的泛型結構沒有任何關係
```java
public class Demo{
    public <T> void show(T t){
        System.out.println(t)
    }

     public <T> T print(T t){
        return t;
     }
}
```

---

### 2. 泛型在繼承方面的體現
* 即使 classA 與 classB 有子父類關係， List < classA > 與 List < classB >  仍不具有子父類關係，兩個是獨立的Class!
* 若 classA 與 classB 是子父類關係，或者是 實現關係，則 classA< E > 與 classB< E > 仍維持子父類或實現關係! 注意 泛型結構的類型要相同。
* 當子類在繼承帶泛型父類，且**父類已指明了泛型類型**，則不需要將子類轉換成泛型類子類的泛型
```java
public class SubOrder extends Order<Integer>{...}
SubOrder subOrder = new SubOrder();
```
* 當子類在繼承帶泛型父類，**父類未指明了泛型類型** ，則需要將子類轉換成泛型類
```java
public class SubOrder1<T> extends Order<T>{}
SubOrder1<String> subOrder1 = new SubOrder1<>();
```

---


### 3.泛型的通配符: ?
* 我們知道  List< classA > 與 List< classB > 之間不存在子父類關係，那麼兩者之間是否有共同的父類 (除了Object以外)?
答案是有的: ```List<?> listall  = null; ```
透過這層關係，我們可以展現出 多態的概念!

* 限制型通配符
   -  ? extend ClassA: 裡面的reference類型是 小於等於 ClassA 的 Class
   -  ? super ClassA : 裡面的reference類型是 大於等於 ClassA 的 Class
```java
public class GenericTest {
    @Test
    public void test3(){
        /*
        * 限制型通配符
        * 1. ? extend Person : 裡面的reference類型是 小於等於Person 的 Class
        * 2. ? super Person : 裡面的reference類型是 大於等於Person 的 Class
        *
        * */

        List<? extends Person> list1 = null;
        List<? super Person> list2 = null;
        List<Son> list3 = null;
        List<Person> list4 = new ArrayList<>();
        list4.add(new Person());
        list4.add(new Son());

        List<Object> list5 = null;

        list1 = list3;
        list1 = list4;
//      list1 = list5;
//
//      list2 = list3;
        list2 = list4;
        list2 = list5;

        // 瀏覽 List<? extends Person> ，使用最大的class給變數
        Person pp = list1.get(0);
        // Son ss = list1.get(0); 錯誤! 這樣會導致 Son ss = new Person()

        // 瀏覽 List<? super Person> ，使用最大的class給變數
        Object oo = list2.get(0);
        // Person od = list2.get(1); 錯誤! 這樣會導致 Person od = new Object()

        // 添加數據
        // list1.add(new Son()); 錯誤! 因為 <? extend Person> 可能會出現比Son還要小的class，如此會變成 smallSon ss = new Son();
        list2.add(new Person()); //通過 因為 ParentClass ff = new Person()
        list2.add(new Son()); // 通過 因為 ParentClass ff = new Son()

    }
}
```
