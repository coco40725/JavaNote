## Java 網路編程
### 1.網路編程主要的兩個問題
1. 如何準確地定位網路上一台或多台主機; 如何定義主機上的特定應用程式
2. 找到主機後如何高效地進行數據傳輸

---

### 2. 網路編程的兩個要素
1. 對應問題一: IP 與 端口號
2. 對應問題二: 網路通信協議: TCP/IP 參考模型 (應用層、傳輸層、網路層、物理+數據鏈路層)；每一詞都有具體的協議

---

### 3. 通信要素一: IP 與 Port
1. IP : 唯一的標示 internet 上的計算機 (通信實體)
2. **在 Java中使用 InetAddress 類來代表IP**
3. IP分類: IPv4 與 IPv6 ; 公用網路/私有網路
4. 域名: https://tw.yahoo.com/
5. 本機IP: 127.0.0.1 對應著 localhost (類似域名)
6. 如何實例化InetAddress ?
     - InetAddress constructor為 private ，無法直接創立對象
     - static method: **InetAddress.getByName(String str)**: str可以是 IP 或 域名
     - static method: **InetAddress.getLocalHost()**: 直接抓本機IP
     - **getHostName()**: 獲取該對象的域名
     - **getHostAddress()**: 獲取該對象的IP

7. 端口號(Port) : 正在電腦上運行的進程，不同的進程會對應不同的port，規定是一個16位元的整數 0~65535；
8. 端口分類: 公認端口(0~1023，給服務器通信使用) / 註冊端口 (1024~49151) / 動態or私有端口 (49152 ~ 65535)
9. 端口號 與 IP 組合 會得到 Socket

```java
public class InetAddressTest {
    public static void main(String[] args) {
        InetAddress inet1 = null;
        InetAddress inet2 = null;
        InetAddress inet3 = null;
        InetAddress inet4 = null;


        try {
            inet1 = InetAddress.getByName("192.168.10.14");
            System.out.println(inet1);

            inet2 = InetAddress.getByName("tw.yahoo.com"); // 域名 --> DNS解析IP --> 回傳IP
            System.out.println(inet2);

            inet3 = InetAddress.getByName("127.0.0.1");
            System.out.println(inet3);

            inet4 = InetAddress.getLocalHost();
            System.out.println(inet4);

            System.out.println(inet2.getHostName());
            System.out.println(inet2.getHostAddress());


        } catch (UnknownHostException e) {
            throw new RuntimeException(e);
        }
    }
}
```

---

### 4. 實現TCP的網路編程
速度慢， Client與Server需要經過三向交握，確保數據有傳過去。

* Client 端建立流程:
1. 填入欲 連接的伺服器 IP 或 域名
2. 填入欲 連接的 伺服器其InetAddress 與 其port number
3. 使用socket建立通道
4. 想做的事情....
5. 關閉通道與 socket

* Server 端建立流程:
1. 指明欲開放連接的port 
2. 接收來自客戶端的Socket
3. 接受後，建立輸入通道
4. 將數據挖出來
5. 關閉通道

#### 4.1 例子1: 客戶端發送訊息給伺服器，伺服器將訊息顯示出來
```java
public class TCPTest {
    // 客戶端
    @Test
    public void client(){
        Socket socket = null;
        OutputStream os = null;

        try {
            // 1. 填入欲 連接的伺服器 IP 或 域名
            InetAddress inet = InetAddress.getByName("127.0.0.1");

            // 2. 填入欲 連接的 伺服器其InetAddress 與 其port number
            socket = new Socket(inet,8899);

            // 3. 使用socket建立通道
            os = socket.getOutputStream();

            // 4. 輸出訊息
            os.write("客戶端發送了訊息!".getBytes(StandardCharsets.UTF_8));
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                // 5. 關閉通道與 socket
                if (socket != null){
                    socket.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }


            try {
                if (os != null){
                    os.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }


    }

    // 伺服器
    @Test
    public void sever(){
        ServerSocket serverSocket = null;
        Socket socketFromClient = null;
        InputStream inputStream = null;
        ByteArrayOutputStream baos = null;

        try {
            // 1. 指明欲開放連接的port
            serverSocket = new ServerSocket(8899);

            // 2. 接收來自客戶端的Socket
            socketFromClient = serverSocket.accept();

            // 3. 接受後，建立輸入通道
            inputStream = socketFromClient.getInputStream();

            // 4. 將數據挖出來
            // 不建議以下的寫法，當有中文時容易有亂碼 (中文一個字 要用3 bytes 去表示，會有中文字被批兩半的問題)
//             byte[] bbyte = new byte[20];
//             int len;
//             while((len = inputStream.read(bbyte)) != -1){
//               System.out.println(new String(bbyte,0, len));
//              }

            // 使用 ByteArrayOutputStream，他會先把數據讀入的數據存在 Array中，全讀完後再拼接起來。
            byte[] bbyte = new byte[4];
            int len ;
            baos = new ByteArrayOutputStream();
            while((len = inputStream.read(bbyte)) != -1){
                baos.write(bbyte,0,len);
            }

            System.out.println(baos.toString());
            System.out.println("來自: " + socketFromClient.getInetAddress().getHostAddress());
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {

            // 5. 關閉通道
            try {
                if (baos != null){
                    baos.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (inputStream != null){
                    inputStream.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (socketFromClient != null){
                    socketFromClient.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (serverSocket != null){
                    serverSocket.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }
}

```



#### 4.2 例子2: 客戶端發送文件給伺服器，伺服器將文件存在本地
```java
public class TCPTest2 {

    // 客戶端
    @Test
    public void client(){
        Socket socket = null;
        OutputStream os = null;
        FileInputStream fis = null;
        try {
            InetAddress inetAddress = InetAddress.getByName("127.0.0.1");
            socket = new Socket(inetAddress,8787);
            os = socket.getOutputStream();

            fis = new FileInputStream("D:\\Java_lession\\1_basic\\code\\JavaSenior\\day27\\src\\Test2\\client.png");
            byte[] bbyte = new byte[1024];
            int len;

            while((len = fis.read(bbyte)) != -1){
                os.write(bbyte,0,len);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {

            try {
                if (fis != null){
                    fis.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (os != null){
                    os.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (socket != null){
                    socket.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

        }


    }

    // 伺服器端
    @Test
    public void server(){
        ServerSocket serverSocket = null;
        Socket socketFromClient = null;
        InputStream is = null;
        FileOutputStream fos = null;
        try {
            serverSocket = new ServerSocket(8787);
            socketFromClient = serverSocket.accept();
            is = socketFromClient.getInputStream();

            fos = new FileOutputStream("Target path");

            byte[] bbyte = new byte[1024];
            int len;
            while((len = is.read(bbyte)) != -1){
                fos.write(bbyte,0,len);
            }

            System.out.println( "來自 " + socketFromClient.getInetAddress().getHostAddress() + "接收成功!");
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {

            try {
                if (fos != null){
                    fos.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (is != null){
                    is.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (socketFromClient != null){
                    socketFromClient.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (serverSocket != null){
                    serverSocket.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }


    }

}

```

#### 4.3 例子3: 客戶端發送文件給伺服器，伺服器將文件存在本地，並返回"成功接收" 給客戶端，最後關閉所有連接
* **為何這裡的客戶端需要使用 socket.shutdownOutput(); 來強制關閉，而例子2 卻不用呢?**
因為，例子2 的客戶端是執行完 while(傳照片) 後，便直接關閉通道了，這個時候 伺服器有接收到訊息 "通道關閉，數據已傳完。"，此時伺服器 while(收照片) 才會跳脫迴圈往下執行。 但是 例子3 不同的點在於客戶端是執行完 while(傳照片) 後便卡在那裡等伺服器傳訊息，而伺服器那頭遲遲沒收到 "數據已傳完" 這個訊息， 導致伺服器 while(收照片) 卡住。因此我們需要讓客戶端強制關閉通道，以通知伺服器訊息已傳完。

* 會有這樣的原因是因為 read() 方法屬於阻塞式方法。

```java
public class TCPTest3 {
    @Test
    public void client(){
        Socket socket = null;
        OutputStream os = null;
        FileInputStream fis = null;
        ByteArrayOutputStream baos = null;
        InputStream inputStream = null;

        try {
            InetAddress inetAddress = InetAddress.getByName("127.0.0.1");
            socket = new Socket(inetAddress,8787);
            os = socket.getOutputStream();

            fis = new FileInputStream("D:\\Java_lession\\1_basic\\code\\JavaSenior\\day27\\src\\Test2\\client.png");
            byte[] bbyte = new byte[1024];
            int len;

            while((len = fis.read(bbyte)) != -1){
                os.write(bbyte,0,len);
            }
            socket.shutdownOutput();

            // 接收來自伺服器的訊息，並顯示出來
            inputStream = socket.getInputStream();
            baos = new ByteArrayOutputStream();
            bbyte = new byte[1024];
            while((len = inputStream.read(bbyte)) != -1){
                baos.write(bbyte,0,len);
            }
            System.out.println("伺服器回報: "+ baos.toString());

        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {

            try {
                if (fis != null){
                    fis.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (os != null){
                    os.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (socket != null){
                    socket.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (baos != null){
                    baos.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

        }


    }


    @Test
    public void server(){
        ServerSocket serverSocket = null;
        Socket socketFromClient = null;
        InputStream is = null;
        FileOutputStream fos = null;

        try {
            serverSocket = new ServerSocket(8787);
            socketFromClient = serverSocket.accept();
            is = socketFromClient.getInputStream();

            fos = new FileOutputStream("Target Path");

            byte[] bbyte = new byte[1024];
            int len;
            while((len = is.read(bbyte)) != -1){
                fos.write(bbyte,0,len);
            }

            // 傳訊息給客戶端
            OutputStream outputStream = socketFromClient.getOutputStream();
            outputStream.write( "已經收到文件了!".getBytes(StandardCharsets.UTF_8));

        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {

            try {
                if (fos != null){
                    fos.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (is != null){
                    is.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (socketFromClient != null){
                    socketFromClient.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (serverSocket != null){
                    serverSocket.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }
}

```

---

### 5. 實現 UDP 的網路編程
速度快，不考慮接收者是否有收到，因此有可能會有部分數據丟失，適合用於即時傳輸。

* Client 端建立流程:
1. 建立Socket，並將欲傳輸的內容與 IP 封裝到 DatagramPacket
2. 通過Socket 將數據傳出去
3. 關閉socket


* Server 端建立流程:
1. 建立 Socket 並指定port
2. 建立空的datagramPacket
3. 使用 datagramSocket 接收
4. 將數據挖出來
5. 關閉通道

```java
public class UDPTest {

    // 發送端
    @Test
    public void send(){

        DatagramSocket datagramSocket = null;
        try {
            String str = "這是垃圾訊息!";
            byte[] bytes = str.getBytes(StandardCharsets.UTF_8);

            // 1. 建立Socket，並將欲傳輸的內容與 IP 封裝到 DatagramPacket
            datagramSocket = new DatagramSocket();
            InetAddress inet =  InetAddress.getByName("127.0.0.1");
            DatagramPacket datagramPacket = new DatagramPacket(bytes,0,bytes.length,inet,9090);

            // 2. 通過Socket 將數據傳出去
            datagramSocket.send(datagramPacket);
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {

            // 3. 關閉socket
            try {
                if (datagramSocket != null){
                    datagramSocket.close();
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }

    }

    // 接收端
    @Test
    public void receive(){
        DatagramSocket datagramSocket = null;
        try {
            // 1. 建立 Socket 並指定port
            datagramSocket = new DatagramSocket(9090);

            // 2. 建立空的datagramPacket
            byte[] bbyte = new byte[100];
            DatagramPacket datagramPacket = new DatagramPacket(bbyte,0,bbyte.length);

            // 3. 使用 datagramSocket 接收
            datagramSocket.receive(datagramPacket);

            // 4. 將數據print出來
            System.out.println(new String(datagramPacket.getData(), 0,datagramPacket.getLength()));
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                // 5. 關閉通道
                if (datagramSocket != null){
                    datagramSocket.close();
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }

    }
}

```
### 6.實現 URL 網路編程
1.  URL:統一資源定位符，對映著網路上某一段的資源地址
2. 格式:
http://localhost:8080/examples/hello.txt?username=Tom&password=123
  a. 協議: HTTP、HTTPS
  b. 主機名 或 IP
  c. port
  d. 資源位址
  e. 參數列表: ?username=Tom&password=123
     參數列表的格式: ?參數名=參數值&參數名=參數值&....

```java
public class URLTest {
    public static void main(String[] args) throws MalformedURLException {
        URL url = new URL("http://localhost:8080/examples/hello.txt?username=Tom&password=123");

        // getProtocol(): 獲取協議
        System.out.println(url.getProtocol());

        // getHost(): 獲取主機名
        System.out.println(url.getHost());

        // getPort: 獲取port number
        System.out.println(url.getPort());

        // getPath: 獲取文件路徑
        System.out.println(url.getPath());

        // getFile: 獲取文件名
        System.out.println(url.getFile());

        // getQuery: 獲取參數列表
        System.out.println(url.getQuery());
    }
}

```

#### 6.1 從url 下載文件
建立流程
1. 建立url
2. 建立連接
3. 建立輸入流
4. 建立輸出流
5. 將數據下載下來
6. 數據流關閉

```java
public class URLTest2 {
    public static void main(String[] args) {
        HttpURLConnection urlConnection = null;
        InputStream inputStream = null;
        FileOutputStream fos = null;
        try {
            // 1. 建立url
            URL url = new URL("http://localhost:8080/examples/hamster.png");

            // 2. 建立連接
            urlConnection = (HttpURLConnection) url.openConnection();
            urlConnection.connect();

            // 3. 建立輸入流
            inputStream = urlConnection.getInputStream();

            // 4. 建立輸出流
            fos = new FileOutputStream("D:\\Java_lession\\1_basic\\code\\JavaSenior\\day27\\src\\Test4\\url.png");

            // 5. 將數據下載下來
            byte[] bbyte = new byte[1024];
            int len;
            while((len = inputStream.read(bbyte)) != -1){
                fos.write(bbyte,0,len);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {
            // 6. 數據流關閉
            try {
                if (fos != null){
                    fos.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (inputStream != null){
                    inputStream.close();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            try {
                if (urlConnection != null){
                    urlConnection.disconnect();
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
        
    }
}


```
