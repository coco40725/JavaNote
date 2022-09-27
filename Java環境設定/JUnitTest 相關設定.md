## JUnitTest 相關設定

### 1. 如何在IDEA中，其JUnit測試下使用 Scanner

在IDEA中使用JUnit時，發現無法使用Scanner。

解決方法:
- 64位元 IDEA

IDEA安裝目錄下的 bin/idea64.exe.vmoptionss 最後一段添加 -Deditable.java.test.console=true

- 32位元 IDEA

IDEA安裝目錄下的 bin/idea.exe.vmoptions 最後一段添加 -Deditable.java.test.console=true



