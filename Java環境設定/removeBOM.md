## error: illegal character: '\ufeff' in java

- the cause:  UTF-8 BOM (Byte Order Marker) at the start of the file. That should not be there, just remove it.
- solution: select all file in the project (crtl + a), then choose "File" -> "File properties" -> "Remove BOM"
