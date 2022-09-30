## Java Date 

### 1. 常用 Date 的class
1. System.currentTimeMillis()
2. java.util.Date 與其子類: java.sql.Date
3. java.text.SimpleDateFormat
4. Calendar
5. java.time 

---

### 2. java.util.Date
1. System.currentTimeMillis(): 回報 從1970/01/01 至 現在 共經過多少毫秒。
2. java.util.Date
     * 2.1 constructors
        * Date():創建當前時間的對象
        * Date(long ): 根據指定毫秒數 (距離 1970/01/01)見出對應日期的對象。
    * 2.2 method
        * toString(): 顯示當前年月日時間(時分秒) 與時區
        * getTime(): 回報 從1970/01/01 至 現在 共經過多少毫秒。

3. java.sql.Date (java.util.Date 的子類): 對應數據庫中的日期變數類型
    * java.util.Date
        * java.sql.Date
    * 3.1 method
        * toString(): 僅回報 西元年-月-日

4. java.util.Date 如何轉換成 java.sql.Date ?
```java
 java.sql.Date date2 = new java.sql.Date(date1.getTime());
```

5. SimpleDateFormat: 對日期進行格式化並解析
     * 5.1 格式化: 日期 (java.util.Date格式) &rarr; 字符串
     * 5.2 解析: 字符串 (有格式要求) &rarr; 日期 (java.util.Date格式)
          *  yyyy: 年
          * MM: 月
          * dd: 日
          * hh: 小時
          * mm: 分
          * ss: 秒

```java
public class Test2 {
    @Test
    public void test() throws ParseException {
        // 使用默認的constructor
        SimpleDateFormat sdf = new SimpleDateFormat();
        Date date = new Date();
        System.out.println(date);
        String s2 = "6/30/22, 2:08 PM";

        // 格式化日期
        String date_str = sdf.format(date);
        System.out.println(date_str);

        // 解析日期
        Date date2 = sdf.parse(s2);
        System.out.println(date2);
    }
}

```

#### 1.1 練習: 將 字符串"2020-09-08" 轉換 java.sql.Date

```java
public class Test2 {
    @Test
    // 將 字符串"2020-09-08" 轉換 java.sql.Date
    public void test3() throws ParseException {
        String birth = "2020-09-08";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date_util = sdf.parse(birth);

        java.sql.Date date_sql = new java.sql.Date(date_util.getTime());
        System.out.println(date_sql.toString());
    }
}
```

#### 1.2 練習: 三天打魚 兩天曬網，從 1990-01-01開始，試問: xxxx 年 xx 月 xx 日，魚夫在做甚麼?
```java
public class Test2 {
     @Test
     public void test4() throws ParseException {
        String ask_str = "1990-01-06";
        String base_str = "1990-01-01";

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");


        // 概念: 以1990-01-01開始 當 第1天， 則 xxxx 年 xx 月 xx 日 是第幾天?
        // 方法1: 透過兩天差距幾毫秒 來計算該日期是第幾天

        Date date_base = sdf.parse(base_str);
        Date date_now = sdf.parse(ask_str);

        long THE_day = (date_now.getTime() - date_base.getTime()) / (1000 * 86400) + 1; // 差幾天 + 1 = 第幾天
        long doing = THE_day % 5;

        if (doing == 1L || doing == 2L || doing == 3L){
            System.out.println("第" + THE_day + "天，" +"漁夫正在打魚");
        }else {
            System.out.println("第" + THE_day + "天，" +"漁夫正在偷懶");
        }
    }
}
```


---

### 3. Calender
1. 創建其子類對象 GregorianCalendar
2. 調用其靜態方法得到對象，getInstance()
3. **get(int field)**: 放入Calendar 的屬性，取得該屬性值
4. **set(int field, int value)**: 針對特定filed強制改成value
5. **add(int field, int amount)**: 針對特定filed 更動 amount 天
6. **getTime()**: Calendar  &rarr; Date ；return  java.util.Date
7. **setTime()**: Date &rarr; Calendar； 將 Date的日期套用至Calendar上

注意: Calender獲取 月份時，1月是0; 2月是 1;...; 12月是 11
                  星期時，1 是星期日; 2 是星期一; ....; 7 是星期六

---

### 4. java.time
java.time 建立了3個class: LocalDate, LocalTime, LocalDateTime(較常用)
，其中方法包含:
1. **.now()**: 靜態方法，獲取當前日期時間
2. **.of()**: 靜態方法，獲取指定的日期時間,沒有偏移量
3. **.getXXxx()**: 非靜態方法，獲取相關日期時間等訊息
4. **.withXXxx()**: 非靜態方法，設定相關日期時間
5. **.plusXXxx()**: 非靜態方法，加減特定日期與時間 (寫負數就是減了)
6. **.minusXXxx()**: 非靜態方法，減特定日期與時間

---
```java
public class JDK8DateTest {

    /*
    * LocalDate, LocalTime, LocalDateTime(較常用) 三個class的使用
    * 三個class皆為靜態方法
    * */
    @Test
    public void test(){
        // .now(): 靜態方法，獲取當前日期時間
        LocalTime localTime = LocalTime.now();
        LocalDate localDate = LocalDate.now();
        LocalDateTime localDateTime = LocalDateTime.now();
        System.out.println(localDate);
        System.out.println(localTime);
        System.out.println(localDateTime);

        // .of(): 靜態方法，獲取指定的日期時間,沒有偏移量
        LocalDateTime localDateTime1 =  LocalDateTime.of(1995,12,25,12,25,41);
        System.out.println(localDateTime1);

        // .getXXxx(): 非靜態方法，獲取相關日期時間等訊息
        System.out.println(localDateTime1.getDayOfMonth());
        System.out.println(localDateTime1.getHour());

        // .withXXxx(): 非靜態方法，設定相關日期時間
        LocalDateTime localDateTime2 = localDateTime1.withDayOfMonth(17);
        System.out.println(localDateTime1); // 不會更動到原始的!
        System.out.println(localDateTime2);

        LocalDateTime localDateTime3 = localDateTime1.withHour(4);
        System.out.println(localDateTime3);

        // .plusXXxx(): 非靜態方法，加減特定日期與時間 (寫負數就是減了)
        // .minusXXxx(): 非靜態方法，減特定日期與時間
        LocalDateTime localDateTime4 = localDateTime1.plusMonths(-3);
        LocalDateTime localDateTime5 = localDateTime1.plusMonths(4);
        System.out.println(localDateTime4);
        System.out.println(localDateTime5);
    }
}

```
---

### 5. Instant class
包含的方法:
1. **.now()**: 獲取當前日期與時間 + 毫秒數 (本初子午線)
2. **OffsetDateTime**: 根據時區調整時間
3. **.toEpochMilli()**: 獲取自 1970年1月1日至現在共經過多少毫秒。
4. **.ofEpochMilli(毫秒)**: 通過給定的豪秒數找出對應的瞬時點，還是根據本初子午線給時間，因此仍要調整時區

```java
public class JDK8DateTest {
    @Test
    public void test1(){
        // 1. .now(): 獲取當前日期與時間 + 毫秒數
        Instant instant = Instant.now(); // 回報的是 本初子午線，因此需要考慮時區問題調整時間
        System.out.println(instant);

        // 2. OffsetDateTime: 根據時區調整時間
        OffsetDateTime offsetDateTime = instant.atOffset(ZoneOffset.ofHours(8));
        System.out.println(offsetDateTime); // 將時區補上

        // 3. .toEpochMilli(): 獲取自 1970年1月1日至現在共經過多少毫秒。
        long milli = instant.toEpochMilli();
        System.out.println(milli);

        //4. .ofEpochMilli(毫秒): 通過給定的豪秒數找出對應的瞬時點，還是根據本初子午線給時間，因此仍要調整時區
        Instant instant1 = Instant.ofEpochMilli(milli);
        System.out.println(instant1);
    }
}
```

---

### 6. DateTimeFormatter class 
用於格式化日期與時間
1. **預設格式**: 靜態final方法，ISO_LOCAL_DATE_TIME;ISO_LOCAL_DATE;ISO_LOCAL_TIME
2. **本地化相關格式**: 靜態方法，ofLocalizedDateTime(FormatStyle.LONG)，注意有對應的用法 https://stackoverflow.com/questions/59531046/java-time-datetimeexception-unable-to-extract-zoneid-from-temporal
3. **自定義相關格式 (較常用)**: 靜態方法，ofPattern(“yyyy MM dd hh:mm:ss”)

```java
public class JDK8DateTest {
    @Test
    public void test2(){
        LocalDateTime localDateTime = LocalDateTime.now();
        //1. 預設格式: ISO_LOCAL_DATE_TIME;ISO_LOCAL_DATE;ISO_LOCAL_TIME
        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
        System.out.println(localDateTime);
        // DateTimeFormatter 格式化: 日期 --> 字符串
        String str = dateTimeFormatter.format(localDateTime);
        System.out.println(str);
        // DateTimeFormatter 解析: 字符串 --> 日期
        TemporalAccessor parse = dateTimeFormatter.parse(str); //  TemporalAccessor 是interface
        System.out.println(parse);

        // 2. 本地化相關格式: ofLocalizedDateTime(FormatStyle.LONG)
        DateTimeFormatter dateTimeFormatter1 = DateTimeFormatter.ofLocalizedDateTime(FormatStyle.SHORT);
        // DateTimeFormatter 格式化: 日期 --> 字符串
        String format = dateTimeFormatter1.format(localDateTime);
        System.out.println(format);

        // DateTimeFormatter 解析: 字符串 --> 日期
        TemporalAccessor parse1 = dateTimeFormatter1.parse(format);
        System.out.println(parse1);


        // 3. 自定義相關格式 (較常用): ofPattern(“yyyy MM dd hh:mm:ss”)
        DateTimeFormatter dateTimeFormatter2 = DateTimeFormatter.ofPattern("yyyy MM dd hh:mm:ss");
        // 格式化
        String format1 = dateTimeFormatter2.format(localDateTime);
        System.out.println(format1);

        // 解析
        TemporalAccessor parse2 = dateTimeFormatter2.parse(format1);
        System.out.println(parse2);
    }
}
```
