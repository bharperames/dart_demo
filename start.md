# Dart 2 React Application Setup Without Null Safety

I have successfully created a boilerplate simple React application written in Dart that deliberately opts out of sound null safety. This app will serve as an excellent starting point for porting an older Dart 2.x app to Dart 3's strict null safety standard.

## Changes Made
- Downloaded **Dart 2.19.6 SDK for macOS ARM64** locally into the `tools/dart-sdk` directory. Using a local SDK prevents any interference with your globally installed Dart or Flutter SDKs on your system.
- Initialized `pubspec.yaml` with the `react` and `build_runner` dependencies. The SDK constraint is set to `>=2.11.0 <3.0.0` to force the package to be opted out of null safety while still allowing the 2.19.6 compiler to execute it.
- Wrote `web/main.dart` and `web/index.html` to instantiate the React application. Included `packages/react/js/react.dev.js` in `index.html` as required by the dart `react` package to provide the correct dart interoperability context.
- Wrote `lib/todo_app.dart` featuring a simple Todo list structure where `Todo` items can be added, toggled, and deleted. It has deliberately untyped variable declarations (`List todos`) and dynamic map property access (`todo['completed']`) to maximize the potential impact of modern Dart sound type checking and data classes. Fixed missing `key` properties across React component children.
- Successfully built the application using the local Dart 2.19 build tools. The output statically served files are located in the `build/` directory.

## Validation Results
The project gracefully compiles with the `tools/dart-sdk/bin/dart run build_runner build -o web:build` command without encountering any strict type checking errors.

You can preview the result statically by opening `build/index.html` in a web browser, or by running `python3 -m http.server -d build` locally.
