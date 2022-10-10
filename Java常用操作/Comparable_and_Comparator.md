## Comparable vs Comparator

開發中，我們需要對 對象進行排序，換言之，我們要表較對象的大小。使用interface: Comparable 或 Comparator。

1. Comparable 使用: 自然排序
    - String，與包裝類皆有實現 comparable，並override的CompareTo 方法，默認從小排到大
    - 自定義類要排序的話，可以透過實現comparable，並override的CompareTo 方法 ，規則如下:
       如果當前對象 this 大於 形參對象 obj 則返回正整數，
       如果當前對象 this 小於 形參對象 obj 則返回負整數，
       如果當前對象 this 等於 形參對象 obj 則返回零。

2. Comparator : 自製排序
    - 使用時機: 
            a. 當有些類沒有實現 comparable 但又不方便去改code，則可以使用Comparator
            b.  那個類有實現 comparable，但是 排序方式不合當前操作，想要更改，則可以使用Comparator
    - 使用方法: override compare(Object o1, Object o2) 這個方法，規則則是:
            a. 返回正整數，代表 o1 > o2；
            b. 返回0，代表相等；
            c. 返回負整數，代表 o1 < o2
---

3. Comparable and Comparator 差異:
    *  Comparable 是一旦在類中定義好，後續只要是這個類都可以直接調用
    *  Comparator 屬於臨時性的，只適用於當下，後續想再用這個排序方法，需要再寫一次。


```java
 public class CompareTest {

    // Comparable 使用舉例: 自然排序
    // String (String，與包裝類皆有實現 comparable，並override的CompareTo 方法，默認從小排到大)
    // 如何自行override CompareTo method，其規則如下:
    // 如果當前對象 this 大於 形參對象 obj 則返回正整數，
    // 如果當前對象 this 小於 形參對象 obj 則返回負整數，
    // 如果當前對象 this 等於 形參對象 obj 則返回零

    /*
    * 自定義類要排序的話，可以透過實現comparable，並override的CompareTo 方法 (按照上面的規則撰寫)
    *
    * */
    @Test
    public void test(){
        String[] arr = new String[]{"AA","CC","MM","ZZ","GG","JJ","BB"};
        Arrays.sort(arr); // 會去調用comparable 與 CompareTo
        System.out.println(Arrays.toString(arr));

    }

    @Test
    public void test1(){
       Gooods[] arr = new Gooods[4];
       arr[0] = new Gooods("AUSU", 250.5);
       arr[1] = new Gooods("Acer", 100.36);
       arr[2] = new Gooods("技嘉", 100.36);
       arr[3] = new Gooods("微星",450.32);

       //Arrays.sort(arr); // error! Gooods cannot be cast to class java.lang.Comparable
        Arrays.sort(arr);
        System.out.println(Arrays.toString(arr));
    }

    @Test
    public void test2(){
        String[] arr = new String[]{"AA","CC","MM","ZZ","GG","JJ","BB"};

        // 改成從大到小進行排序
        Arrays.sort(arr, new Comparator<String>() {
            @Override
            public int compare(String o1, String o2) {
                return -o1.compareTo(o2);
            }
        });
        System.out.println(Arrays.toString(arr));
    }

    @Test
    public void test3(){
        Gooods[] arr = new Gooods[4];
        arr[0] = new Gooods("AUSU", 250.5);
        arr[1] = new Gooods("Acer", 120.36);
        arr[2] = new Gooods("Acer", 150.36);
        arr[3] = new Gooods("微星",450.32);

        // 改成按照名稱從低排到高，再把價格從高排到低
        Arrays.sort(arr, new Comparator<Gooods>() {
            @Override
            public int compare(Gooods o1, Gooods o2) {
                if (o1.getName().equals(o2.getName())){
                    return -Double.compare(o1.getPrice(), o2.getPrice());
                }else {
                    return o1.getName().compareTo(o2.getName());
                }

            }
        });

        System.out.println(Arrays.toString(arr));
    }
}


```


---


```java

public class Gooods implements Comparable{
    private String name;
    private double price;

    public Gooods() {
    }

    public Gooods(String name, double price) {
        this.name = name;
        this.price = price;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "Gooods{" +
                "name='" + name + '\'' +
                ", price=" + price +
                '}';
    }

    // 自行定義Gooods的排序方式: 根據價格從低到高排序，再按照產品名稱排序
    @Override
    public int compareTo(Object o) {
        if (o instanceof Gooods){
            Gooods goods = (Gooods) o;
            if (this.price > goods.price){
                return 1;
            }else if (this.price < goods.price){
                return -1;
            }else {
                return this.name.compareTo(goods.name);
            }
           // 或 return Double.compare(this.price,goods.price);
        }
        throw new RuntimeException("Invaild data type!");

    }
}


```
