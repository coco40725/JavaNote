## error: illegal character: '\ufeff' in java

- the cause:  UTF-8 BOM (Byte Order Marker) at the start of the file. That should not be there, just remove it.
- solution: select all file in the project (crtl + a), then choose "File" -> "File properties" -> "Remove BOM"

<img src="https://github.com/coco40725/JavaNote/blob/main/Java%E7%92%B0%E5%A2%83%E8%A8%AD%E5%AE%9A/img/removeBOM.png?raw=true" width="60%">
