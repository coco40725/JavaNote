## 使用 module-info.java 來跨module調用方法 (Java 9 的特性)

### 1. module-info.java 寫法
```
module [module的名稱]{

 exports [欲對外暴露的package];
 
 requires [欲依賴的module];
 
}
```

### 2. 範例

* module A 含有 pcakage Book

* module B

假設想要在module B 調用 module A 中的package Book，則

- 於 module A 創建 module-info.java 
```
module A{
 exports Book;
}
```
- 於 module B  創建 module-info.java 
```
module B{
 requires A;
}
```

---
#### Reference

https://blog.csdn.net/qq_43472877/article/details/104171769
