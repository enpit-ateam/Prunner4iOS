# Prunner - Planing for Runner
![icon](Docs/icon.png)

Prunnerとは、その日の気分で無理なく走りたいランナーに向けたiOS用ランニングサポートアプリケーションです。

ランニングコースの作成・編集に特化しておりコースの提案・記録を行うことができます。

# Example
![exmaple](Docs/example.gif)

# Instlation
```bash
$ git clone <repository pass>
$ pod install
$ vim Prunner4iOS/GoogleMaps.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>APIKey</key>
    <string> <your api key> </string>
</dict>
</plist>
```

# External Libraries
- GoogleMapsAPI
