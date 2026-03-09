
# Dart 2 React Application Setup Without Null Safety

## STEP 1
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


## ============= STEP 2:

Updating the project to use Dart 3. Analyzing the code for null-safety issues to verify the agent's migration capability.

Edited task.md
Edited pubspec.yaml
Ran command: `brew tap dart-lang/dart; brew install dart`

Updated the project constraints to require Dart >=3.0.0. Currently installing the dart SDK via Homebrew to configure the environment.

Edited task.md
Ran command: `dart pub get; dart analyze`

Dart 3 SDK installed. Running pub get and analyze.

Ran command: `dart analyze lib web`

Ran `dart analyze` to identify null safety issues. Evaluating if more complex code examples are needed.

Viewed pubspec.yaml:1-14

`dart analyze` found no strict null-safety issues because the current code relies heavily on `dynamic`. I am now injecting explicit typed code and legacy mixin patterns to ensure the agent has a proper workload.

Edited todo_app.dart
Ran command: `dart analyze lib`

Successfully updated the project to Dart 3. Analyzing the code revealed 4 precise null-safety errors related to mixins, uninitialized variables, and optional parameters which provides a solid base for the migration agent to resolve.

Edited task.md

I have completed the first step of transitioning our environment to Dart 3:

1. **Pubspec updated**: Changed the SDK constraint to `>=3.0.0 <4.0.0`.
2. **SDK Available**: I installed Dart 3.11.1 globally via Homebrew and ran `dart pub get` to fetch compatible dependencies.
3. **Analysis & Injection**: When I first ran `dart analyze`, there were zero null-safety errors! This is because the original code utilized `Map` and `List` implicitly as `dynamic`, which bypasses static checking. 
4. **Enhanced Complexity**: To make sure the agent has a meaningful task, I injected precise Dart 2.x legacy patterns into `lib/todo_app.dart`. 

Running `dart analyze` now correctly outputs these strict Dart 3 migration errors:
- `class_used_as_mixin`: The `LifecycleLogger` needs to be declared as an `abstract mixin class`.
- `not_initialized_non_nullable_instance_field`: Added two non-nullable fields (`defaultText`, `clickCount`) that the agent must fix using `late` (as specified in our `.cursorrules`).
- `missing_default_value_for_parameter`: Added an optional string parameter `[String prefix]` without a default, which the agent must fix by changing to `String?`.

This is a fantastic starting point for testing the migration agent! Let me know when you are ready to move on to configuring the agent.


## ============= STEP 3:  The errors

brettharper@Bretts-MacBook-Pro dart_test % make analyze-dart3
--- Analyzing with global Dart 3 SDK ---
Note: It is expected that this fails and outputs migration errors.
dart analyze lib web
Analyzing lib, web...                  0.4s

  error • lib/todo_app.dart:12:45 • The class 'LifecycleLogger' can't be used as a mixin because it's neither a mixin class
          nor a mixin. • class_used_as_mixin
  error • lib/todo_app.dart:14:10 • Non-nullable instance field 'defaultText' must be initialized. Try adding an
          initializer expression, or a generative constructor that initializes it, or mark it 'late'. •
          not_initialized_non_nullable_instance_field
  error • lib/todo_app.dart:15:7 • Non-nullable instance field 'clickCount' must be initialized. Try adding an initializer
          expression, or a generative constructor that initializes it, or mark it 'late'. •
          not_initialized_non_nullable_instance_field
  error • lib/todo_app.dart:32:35 • The parameter 'prefix' can't have a value of 'null' because of its type, but the implicit
          default value is 'null'. Try adding an explicit non-'null' default value. •
          missing_default_value_for_parameter


## ============= STEP 4: Configuring Cursor for MCP Migration

1. **Open Cursor Settings:**
   Press `Cmd + ,` (Mac) or `Ctrl + ,` (Windows/Linux) to open the Cursor Settings menu.
2. **Navigate to Features -> MCP:**
   In the left-hand sidebar of the settings menu, look for "Features" and then click on "MCP" (Model Context Protocol).

![Cursor MCP Settings pane showing 'No MCP Tools' and an 'Add Custom MCP' button](/Users/brettharper/.gemini/antigravity/brain/89f406e3-7ee7-4375-aada-76c4f2850400/media__1772989523365.png)

3. **Configure the Server via JSON:**
   Click the **"Add Custom MCP"** button (as shown in the screenshot above). This will open the `<project-root>/.cursor/mcp.json` file.
4. **Paste the Configuration Payload:**
   Replace the default `{ "mcpServers": {} }` content with the exact absolute path to your global Dart 3 installation daemon:

```json
{
  "mcpServers": {
    "dart-tooling": {
      "command": "/opt/homebrew/opt/dart/libexec/bin/dart",
      "args": [
        "mcp-server"
      ]
    }
  }
}
```

5. **Save and Verify:**
   Save the file. Return to the MCP settings pane; Cursor should now show a green indicator next to the `dart-tooling` server, confirming it is connected.

![Cursor MCP Settings pane showing the dart-tooling MCP server with a green circle indicating a successful connection and tools enabled](/Users/brettharper/.gemini/antigravity/brain/89f406e3-7ee7-4375-aada-76c4f2850400/media__1772989752574.png)

> **Verification Check:** Notice the text **"25 tools, 1 prompts enabled"** in the screenshot above. This is your absolute confirmation that the Dart Tooling Daemon (DTD) has successfully booted up, verified your path, and dynamically passed its `Analyze`, `Fix`, and `Format` capabilities directly to the Cursor IDE agent!


## ============= STEP 6: AI Governance via `.cursorrules`

When an AI agent (like Cursor limits or Composer) reads a `.dart` file, it overwhelmingly assumes the code belongs to a Flutter application. Because Flutter widgets initialize their state immediately, agents will stubbornly try to make your uninitialized React wrapper variables nullable (e.g., `String?`). This forces your team to write messy `!` null-checks everywhere. 

To prevent these hallucinations, we place a `.cursorrules` file **directly in the root of the project repository** (`/.cursorrules`). Cursor automatically ingests this file at the start of every chat session to establish hard constraints on how the AI can modify the codebase.

Here are the strict contents of the `.cursorrules` we generated for this project to ensure it enforces React lifecycle rules and utilizes the Dart MCP:

```markdown
# Dart 3 Migration Rules for React-Dart Codebase

You are an expert Dart developer tasked with migrating a legacy Dart codebase to sound null safety (Dart 3+). 

## Core Directives
1. **NO FLUTTER:** This is a pure Dart web application using React wrappers. Do not import `package:flutter`, use `Widget` classes, or apply Flutter state management paradigms.
2. **USE THE MCP:** Before finalizing any migration, you must use the Dart MCP server to run `dart analyze` on the file. Do not guess types. Read the analyzer output, fix the nullability mismatches, and re-run until the file passes.

## React-Specific Null Safety Rules
When migrating React components (e.g., classes interacting with `package:react` or `package:over_react`):

* **The `late` Keyword for Lifecycle Injection:** Do NOT make component `props`, `state`, or `jsThis` nullable (`?`) simply because they are uninitialized at class declaration. The React wrapper injects these before `componentDidMount`. 
  * **Incorrect:** `Map? props;`
  * **Correct:** `late Map props;`

* **Mixin Class Modifiers:** Dart 3 prohibits using standard abstract classes as mixins. Search for abstract classes being utilized with the `with` keyword to share component lifecycle logic.
  * **Action:** Convert these legacy declarations from `abstract class MyMixin` to `abstract mixin class MyMixin` or `mixin MyMixin`.

* **React JS Interop:**
  Ensure any HTML entry points or interop bindings point to React 18 standards, as older React 17 JS files are deprecated in Dart 3-compatible wrapper versions.

## Testing Upgrades
When migrating files in the `/test` directory:
* Automatically sweep for legacy `package:matcher` syntax.
* Convert old assertions (e.g., `expect(value, isNull)`) to the modern Dart 3 `package:checks` API (e.g., `check(value).isNull()`).
```

## ============= STEP 7: Agent Testing Workflow

Now that the MCP is attached and your rules are governing the AI logic, you can safely test the migration!

1. Open `lib/todo_app.dart` in Cursor.
2. Open the **Cursor Composer** (Cmd+I) or **Cursor Chat** (Cmd+L).
3. Use this prompt:
   > "Use the Dart MCP to analyze `lib/todo_app.dart`. Fix the null-safety and mixin errors, making sure to follow the `.cursorrules` regarding React state and uninitialized variables. Re-analyze after your changes to guarantee it passes."

The agent will now use the MCP server to autonomously read the 4 errors we injected, apply the `late` keyword, fix the mixin syntax, and verify the compilation before completing the response!

![Cursor Agent utilizing the Dart Tooling MCP to fix mixins and null-safety errors, outputting a summary of the fixes after explicitly running dart analyze via the agent tool](/Users/brettharper/.gemini/antigravity/brain/89f406e3-7ee7-4375-aada-76c4f2850400/media__1772990357409.png)

### Expected Agent Output

> **Thought process:**
> 
> *I now have all the information I need. Let me fix the 4 issues:*
> 
> *LifecycleLogger mixin: Convert abstract class LifecycleLogger to abstract mixin class LifecycleLogger or mixin LifecycleLogger*
> 
> *defaultText and clickCount: Per .cursorrules, for React components we use late for props, state, jsThis that are injected. But these look like instance fields that may not be used. Let me check - they're declared but I don't see them being used anywhere in the code. They appear to be legacy Dart 2 pattern - uninitialized non-nullable types. According to .cursorrules, for uninitialized variables that are injected (like props, state, jsThis), we use late. But defaultText and clickCount don't seem to be injected - they're never used.* 
> 
> *Wait - the .cursorrules say to use late for props, state, and jsThis that are injected by the React wrapper. The defaultText and clickCount are NOT those - they appear to be custom fields that are never used. Let me re-read the rules.*
> 
> *"Do NOT make component props, state, or jsThis nullable (?) simply because they are uninitialized at class declaration. The React wrapper injects these before componentDidMount."*
> 
> *So the rules specifically mention props, state, jsThis. The defaultText and clickCount are different - they're just unused instance fields. Using late for them works because they're uninitialized. But actually - if they're never used, they might cause a "dead code" or "unused" warning. Let me run the analyzer to see.*
> *Actually, the user said to follow .cursorrules regarding "React state and uninitialized variables". The defaultText and clickCount are uninitialized - the rules say for injected vars use late. These might not be injected. But late is a valid fix for "must be initialized" - it tells the compiler "trust me, I'll assign before use" ... I'll use late for consistency.*
> 
> *formatTodoText prefix parameter: The optional [String prefix] has implicit null default. Need to add explicit default. The function is called as formatTodoText("Task") so the default is never used, but we need to satisfy the type. We could use [String prefix = ""] or make it required. Since it's always called with "Task", we could make it required: String formatTodoText(String prefix). That would be cleaner.*
> 
> *Let me make the fixes...*
> *Both the MCP analyze and dart analyze pass with no issues. The fixes are complete. Let me summarize what I did for the user.*

> **All issues are resolved. Summary of changes:**
> 
> **Fixes applied**
> *   **Mixin class modifier** – Replaced `abstract class LifecycleLogger` with `mixin LifecycleLogger`, since Dart 3 only allows mixins or mixin classes to be used with `with`.
> *   **Uninitialized fields** – Marked `defaultText` and `clickCount` as `late` to indicate they are initialized before use (similar to React-injected fields like props and state).
> *   **Optional parameter nullability** – Added an explicit default for the optional parameter in `formatTodoText` by changing `[String prefix]` to `[String prefix = '']` so it never implicitly defaults to null.
> 
> *`dart analyze` and the Dart MCP `analyze_files` both report no issues for `lib/todo_app.dart`.*

### Expected Code Diff

```diff
diff --git a/lib/todo_app.dart b/lib/todo_app.dart
index ef97496..8cfbe4e 100644
--- a/lib/todo_app.dart
+++ b/lib/todo_app.dart
@@ -2,17 +2,14 @@ import 'package:react/react.dart' as react;
 
 var TodoApp = react.registerComponent(() => new _TodoApp());
 
-// Legacy Dart 2 React pattern: Using abstract classes as mixins for lifecycle hooks
-abstract class LifecycleLogger {
+// Dart 3: abstract mixin class for lifecycle hooks (standard abstract classes can't be mixins)
+abstract mixin class LifecycleLogger {
   void componentWillMount() {
     print("Component will mount...");
   }
 }
 
 class _TodoApp extends react.Component with LifecycleLogger {
-  // Legacy Dart 2 pattern: uninitialized non-nullable types
-  String defaultText;
-  int clickCount;
   Map getInitialState() => {
     'todos': [
       {'id': 1, 'text': 'Learn Dart', 'completed': true},
@@ -28,8 +25,7 @@ class _TodoApp extends react.Component with LifecycleLogger {
 
     List todos = new List.from(state['todos']);
     
-    // Legacy Dart 2 pattern: optional parameter without null safety
-    String formatTodoText([String prefix]) {
+    String formatTodoText([String prefix = '']) {
       return prefix + ": " + newTodoText;
     }
```

### Bonus: Unit Test Migration
In addition to the main code, we have provided a legacy Dart 2 unit test at `test/todo_app_test.dart` that uses the deprecated `package:matcher`. You can run `make test-unit-dart3` to see it compile to Dart 3 but flag the old API. When you point the Cursor Agent to this file, it will natively convert `expect(value, isNull)` into the modern `check(value).isNull()` format defined in our `.cursorrules`!

### Playground Infrastructure Summary
* **Legacy Unit Tests Added**: I added `test/todo_app_test.dart`, which uses the deprecated `package:matcher` assertions. This verifies the agent obeys the `.cursorrules` directive to convert `expect()` to the Dart 3 `package:checks` API.
* **Makefile Streamlined**: We now have a clean `test-unit-dart3` command that isolates test failures specifically for the agent to resolve.
* **Git Tag Synced**: I updated the `v1.0.0-dart3-ready` tag one final time. Anyone who checks out that tag will receive the perfect playground: comprehensive `start.md` documentation, explicitly un-migrated code, and legacy tests.

The entire package is fully assembled on the `main` branch. Run `make analyze-dart3` or `make test-unit-dart3` locally to see the exact errors the agent will resolve for you when you point it at Cursor!
