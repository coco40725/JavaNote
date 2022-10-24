## VS Code 中文亂碼
使用 Code Runner 執行 java 時，預設上使用 ``encoding x-windows-950``，導致
中文會出現亂碼，為避免此情況，我們可以修改 ``settings.json``。

### 1. 進入 Code Runner Setting
點選 Code-runner: Executor Map，並點選 Edit in settings.json

### 2. 修改``code-runner.executorMap``
```json
"code-runner.executorMap": {
"java": "cd $dir && javac -encoding utf-8 $fileName && java -Dfile.encoding=utf-8 $fileNameWithoutExt",
        "c": "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
 }
```


### reference
https://zhuanlan.zhihu.com/p/380930006
