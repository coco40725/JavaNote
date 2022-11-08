## InputStream and OutputStream

### 1. Stream的分類
* 根據操作數據單位: 字節流 (Byte Stream)、字符流 (Character Stream)
* 根據數據的流向: 輸出流 (Output Stream)、輸入流 (Input Stream)
* 根據流的角色: 節點流 (File Stream)、處理流 (Buffered Stream)

---

### 2. Stream的體系結構
```java
File file = new File("檔案路徑");
```
|  Abstract Class   |  File Stream  | Buffered Stream | 
| ----------------  | ------------- | --------------- |
| InputStream       | FileInputStream(File file): ``read(bype[] buffer)``  | BufferInputStream(File Stream): ``read(bype[] buffer)`` |
| OutputStream       |  FileOutputStream(File file): ``write(bype[] buffer, 0, len)``  | BufferOutputStream(File Stream): ``write(bype[] buffer, 0, len)`` |
| Reader       | FileReader(File file): ``read(char[] buffer)``  | BufferReader(File Stream): ``read(char[] buffer)`` / ``readLine(String str)`` |
| Writer       |  FileWriter(File file): ``write(char[] buffer, 0, len)``   | BufferWriter(File Stream): ``write(char[] buffer, 0, len)`` / ``write(String str)`` ; ``newLine() ``|


<img src="https://miro.medium.com/max/4800/1*XLE1o5lhl6xCTkhKVhKE2g.png" height = "60%" width = "70%">

---

### 3. 讀入資料須注意的點
1. read(): 返回讀入的第一個字符 (將char 轉成 int，例如 a = 97)，若達文件末尾則返回-1
2. 讀資料時有三個環節可能會報錯
     * 2.1 找到此文件並提供數據流 :  fr = new FileReader(file); 若找不到文件，則此步驟會報錯 FileNotFoundException
     * 2.2 讀資料: fr.read()
     * 2.3 關資料: fr.close()
 不論你讀取資料是否成功，我們都需要將資料關閉，因此會採用try/catch-finally， 但是! 若錯誤發生在 2.1 ，代表fr沒有建立，數據流沒有開啟，則不需要close，因此在close前我們須先判斷 數據流是否有建立成功!

---

### 4.  read(char[] cbuf) 的讀入過程
假設文件內容為: helloworld123
```java 
char[] cbuf = new char[5];
```
* 說明:
step 1: ``cbuf = [h,e,l,l,o]`` ，此時 ``fr.read(cbuf) = 5``
step 2: ``cbuf = [w,o,r,l,d]`` ，此時 ``fr.read(cbuf) = 5``
step 3: ``cbuf = [1,2,3,l,d]`` ，此時 ``fr.read(cbuf) = 3``

---

### 5. 檔案輸出
輸出檔案時，若檔案不存在，則會自動創建。
**new FileWriter(file, append: true)** : 檔案若存在，則不覆蓋，僅將新內容接著寫入原檔案。
**new FileWriter(file, append: false)** : 預設，檔案若存在直接覆蓋。
**write(String, offset, end)** : 寫出 String，範圍從 [offset, end)

---

### 6. 檔案輸入與輸出流程
1. 實例化 File
2. 建立 File Stream or Buffered Stream
3. 使用 read() / write() 進行資料內容的輸入與輸出
4. 關閉 Stream

#### 6.1 例子: 以 Byte Stream 來進行檔案複製
```java
public static void copyFile(String scrPath, String destPath, int Buffer){
        FileInputStream fis = null;
        FileOutputStream fos = null;

        try {
            // 1. 實例化 File
            File file = new File(scrPath);
            File file1 = new File(destPath);

            // 2. 建立數據流
            fis = new FileInputStream(file);
            fos = new FileOutputStream(file1);

            // 3. 輸入與輸出
            int len;
            byte[] bbuf = new byte[Buffer];
            while( (len = fis.read(bbuf)) != -1){
                fos.write(bbuf, 0, len);
            }
            System.out.println("\n 複製成功!");
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {
            // 4. 關閉數據流
            try {
                if (fis != null){
                    fis.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (fos != null){
                    fos.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
}
```

#### 6.2 例子: 以 Character Stream 來進行檔案複製
```java
public class Demo{
    // 結合 Reader and Writer，進行檔案複製
    @Test
    public void test4(){
        FileReader fr = null;
        FileWriter fw = null;
        try {
            // 1. File 實例化 (讀入) + File 實例化 (寫出)
            File file1 = new File("testWrite.txt");
            File file2 = new File("testWrite_copy.txt");


            // 2. 提供數據流: 讀入 與 輸出
            fr = new FileReader(file1);
            fw = new FileWriter(file2);

            // 3. 數據的讀入 與 寫出
            int len;
            String str;
            char[] cbuf = new char[5];

            while((len = fr.read(cbuf)) != -1){
                fw.write(cbuf,0,len);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {

            // 4. 關閉數據流
            try {
                if (fr != null){
                    fr.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }


            try {
                if (fw != null){
                    fw.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }

}

```

#### 6.3 使用Buffered Stream 來進行檔案複製
Buffered Stream 的作用: 提供流的輸出輸入的速率
* 提高讀寫速度的原因 : 內部提供了一個緩衝區，此緩衝取 size 為 8192，當8192被存滿，會自動掉 flush() 將裡面的內容輸出，以此清出緩衝區。

```java
public class Demo{
     public static void copyFileWithBuffer(String srcPath, String destPath){
        BufferedReader br = null;
        BufferedWriter bw = null;
        try {
            // 1. 實例化 File
            File srcFile = new File(srcPath);
            File destFile = new File(destPath);

            // 2. 建立數據流
            FileReader fr = new FileReader(srcFile);
            FileWriter fw = new FileWriter(destFile);

            // 3. 使用緩衝流
            br = new BufferedReader(fr);
            bw = new BufferedWriter(fw);


            // 4. 數據輸入輸出
            // 方法 1: 使用 char array
//            int len;
//            char[] bchar = new char[10];
//            while( (len = br.read(bchar)) != -1 ){
//                bw.write(bchar, 0 , len);
//            }

            // 方法 2: 使用 readLine ，一次讀一行並存成string，注意預設不含換行
            String str;
            while ( (str = br.readLine()) != null  ){
                // 換行方法1: 直接加 \n
                // bw.write(str + "\n");
                // 換行方法2: 加 newLine()
                bw.write(str);
                bw.newLine();
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {

            // 5. 數據流關閉: 先關 外層 在往內層關，而其實JAVA 在關閉外層流時，會自動一併把內層流關掉
            // 因此只要關外層流!

            try {
                if (br != null){
                    br.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }


            try {
                if (bw != null) {
                    bw.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

    }

}

```

#### 6.4 其他類型的 Buffered Stream
1. **Convert Stream**:
- InputStreamReader : 將輸入的Byte Stream 轉換成 Character Stream，類似解碼
- OutputStreamWriter : 將輸出的Character Stream 轉換成 Byte Stream，類似編碼
```java
public class InputStreamReaderTest {
    @Test
    public void test(){
        InputStreamReader isr = null; // character set預設是根據idea，至於應該填多少，取決於你的文件存檔格式
        try {
            FileInputStream fis = new FileInputStream("Target path");
            isr = new InputStreamReader(fis,"UTF-8");

            char[] bchar = new char[20];
            int len;
            while((len = isr.read(bchar)) != -1 ){
                String str = new String(bchar,0,len);
                System.out.println(str);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {

            try {
                if (isr != null){
                    isr.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }
}


```
2. **PrintStream / PrintWriter** : 將輸出在java上的文字(System.out.print())改輸出到指定檔案中。
```java
public class Demo{
    // PrintStream
    @Test
    public void test1(){

        PrintStream pr = null;
        try {
            FileOutputStream fis = new FileOutputStream("Target path");
            pr = new PrintStream(fis, true);
            if (pr != null){
                System.setOut(pr); // activate the PrintStream
            }

            for (int i = 0; i < 255;  i++){
                System.out.print( (char) i);
                if (i % 50 == 0){
                    System.out.println();
                }
            }
        } catch (FileNotFoundException e) {
            throw new RuntimeException(e);
        } finally {
            pr.close();
        }

    }
}

```
3. **DataInputStream / DataOutputStream** : 寫出與讀入記憶體的variable (例如你想保存特定變數的數值，以供未來使用)，注意! 用數據流所撰寫的文件，必須用數據流打開，且讀的時候必須按照 寫入 的順序讀!!

```java
public class Demo{
    // 寫出數據: DataOutputStream
    @Test
    public void test2(){
        DataOutputStream dos = null;
        try {
            FileOutputStream fos  = new FileOutputStream("Target path");
            dos = new DataOutputStream(fos);

            dos.writeUTF("aaabbbccc");
            dos.flush();
            dos.writeInt(45);
            dos.flush();
            dos.writeBoolean(true);
            dos.flush();
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                dos.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

    }

}
```

```java
public class Demo{
   // 讀入數據: DataInputStream
    @Test
    public void test3(){
        DataInputStream dis = null;
        try {
            FileInputStream fis = new FileInputStream("Target path");
            dis = new DataInputStream(fis);

            // 注意! 必須按照 "寫入" 的順序讀
            String name =  dis.readUTF();
            int age = dis.readInt();
            boolean exist = dis.readBoolean();

            System.out.println("name :" + name + " age : " + age + " exist : " + exist);
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                dis.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }


    }

}
```


---

### 7. 結論
1. 檔案類型為 .txt, .java, .c, .cpp 純文字檔案: 使用 Character Stream: Reader/Writer
2. 檔案類型為 非純文字檔 (.jpg, .png, .mp3, .mp4, .avi, .doc, .csv, .ppt): 使用Byte Stream: InputStream/ OutputStream

3. 用錯的話 print 會出現亂碼! 
例如:
``文件: helloworld台灣桃園醫院``
如果這個文件用 InputStream來讀的話會出現亂碼，因為中文字的存法是 "**一個中文字 用 2 (BIg5) 或 3 (UTF8) 個byte 來存**"，這樣會導致讀取被截斷:
ld台 = [5,2,12,23,56]
一次讀1個byte 	&rarr; [5], [2], [12], [23], [56] 如此 "台"這個字會變亂碼

但是! 如果你只是要做複製貼上，那麼純文字檔與非純文字檔 皆可用 InputStream/ OutputStream 進行操作

---

### 8. 其他
Java 9 的新特性: 把欲關閉的流 其對象放進try, 但放進去後此對象會變成"常數"，即不可修改；若有多個流要關閉: try(reader; reader1)

```java
public static void main(String[] args) {
        InputStreamReader reader = new InputStreamReader(System.in);
        try (reader) {

            char[] cbuff = new char[20];
            int len;
            if ((len = reader.read(cbuff)) != -1) {
                String str = new String(cbuff, 0, len);
                System.out.println(str);
            }

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
```
