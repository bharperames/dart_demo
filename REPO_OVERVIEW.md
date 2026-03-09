# Dart React Migration Playground: Repository Analysis

This document provides a comprehensive breakdown of the final state of the repository, the purpose of each file, and a synopsis of the onboarding experience for a new developer.

---

## 🧭 Newcomer Synopsis: The Out-of-the-Box Experience

When a developer arrives at this repository, their immediate experience is designed to be highly focused and educational:

1. **The Goal is Immediate:** They read `README.md` and immediately learn this is NOT a standard template to build from. Instead, it is a **broken legacy application** specifically built as an "AI Migration Playground." 
2. **The Tools are Clear:** They are instructed on exactly how to use Cursor's MCP (Model Context Protocol) to connect the IDE directly to the Dart Tooling Daemon. Wait times for fetching tooling or finding configurations are zero; screenshots guide them exactly to the settings page.
3. **The Proof is in the Terminal:** Rather than taking the migration on faith, they are given `make` commands (`make analyze-dart3` and `make test-unit-dart3`) to first see the legacy code crash against modern Dart 3 standards in their terminal.
4. **The Agent is Governed:** When they open `.cursorrules`, they realize why the AI agent behaves so intelligently: it is being strictly governed to avoid flutter hallucinations and forced to use the MCP for real-world compilation checks. 

**Conclusion:** The developer walks away understanding not just *how* to migrate an app, but how to set up rigid guardrails (`.cursorrules`) and empower their AI (`MCP`) to securely refactor massive legacy codebases without breaking dependencies.

---

## 📂 Codebase File manifest

### Documentation & Governance
- **`README.md`**: The entry point. Explains the purpose of the playground, how to run the built-in terminals tests to see the migration errors, and provides step-by-step instructions (with screenshots) for linking Cursor to the Dart MCP.
- **`LICENSE.md`**: The standard MIT license governing the repository.
- **`.cursorrules`**: The most critical file for the AI. It acts as the "brain constraints" for Cursor, telling the AI: "This is not Flutter, use `late` for React lifecycle variables, and you MUST execute `dart analyze` via the MCP to verify your work."

### Configuration
- **`Makefile`**: Simplifies the developer command-line experience. It abstracts away complex `dart pub global run` commands behind easy, standardized targets like `make run-dart3`, `make analyze-dart3`, and `make test-unit-dart3` so newcomers don't wrestle with Dart toolchains.
- **`pubspec.yaml`**: The Dart package manager definition. It manages dependencies like `react`, `build_runner`, and `test`. It is configured with constraints that bridge the gap between allowing the legacy code to exist while fetching modern Dart 3 tooling to analyze it.

### The Legacy Application (Features to Migrate)
- **`lib/todo_app.dart`**: The core component containing the intentional, manufactured bugs. It is a React UI component written in Dart 2 that features:
  - An invalid "abstract class" utilized as a mixin.
  - Uninitialized React state variables missing `late` modifiers.
  - Optional parameters without explicit null checking.
- **`web/main.dart`**: The bootstrap script. It initializes the React lifecycle and attaches `TodoApp` to the DOM.
- **`web/index.html`**: The static HTML shell that loads the compiled Dart application alongside the required React Javascript bundles.
- **`web/styles.css`**: Simple styling for the Todo App UI.

### The Testing Infrastructure
- **`test/todo_app_test.dart`**: A legacy unit test file using the deprecated `package:matcher` assertion library. It exists purely to trigger the `.cursorrules` directive, challenging the AI agent to confidently rewrite the `expect()` assertions to the modern `checks` API.
