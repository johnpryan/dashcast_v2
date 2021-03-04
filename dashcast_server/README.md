This server serves podcasts for dashcast_app. It fetches podcast information
once at startup. Since parsing XML is CPU-intensive, it's better to offload this
work to a server or isolate instead of parsing on the UI thread.

## Running

Run `bin/server.dart` to run:

```
dart bin/server.dart
```
