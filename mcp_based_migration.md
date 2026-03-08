# Migrating to Dart 3 with AI Agents and Dart MCP

## 1. Verification of the Tools
**The Death of `dart migrate`**: It is a verified fact that the official `dart migrate` tool was permanently removed in Dart 3.0. The Dart language team officially concluded that because Dart 3 cannot parse non-null-safe code, keeping the tool would require shipping a massive, redundant chunk of the pre-3.0 compiler in every modern Dart release.

**The Official Dart MCP Server**: Google officially released the Dart and Flutter MCP Server. It requires Dart SDK version 3.9 (or later). It acts as a bridge between the Dart Tooling Daemon (DTD) and agentic IDEs like Cursor, Windsurf, or Claude Code.

## 2. Documented Case Studies & Official Posts
Using AI agents for Dart 3 migration is actively being documented by both Google and the community. Here are the specific posts you can reference:

- **Official Google Release**: "Supercharge Your Dart & Flutter Development Experience with the Dart MCP Server" (Flutter Blog). This details how the `dart mcp-server` command grants agents access to the `dart analyze` and `dart compile` tools to iteratively fix code.
- **Community Case Study**: "Modernizing Flutter Error Handling: Migrating to Dart 3 Pattern Matching" by Carlos Daniel. This details a team abandoning manual refactoring and instead building a specialized Dart code agent to systematically migrate legacy Dart files to modern Dart 3 paradigms, verifying compilation step-by-step.

## 3. Synthesis for Your Team: Migrating to Dart 3
### The "Legacy" Way (dart migrate)
This is the traditional, AST-based path. It forces syntax compliance but does not understand modern Dart semantics.
- **Required SDK**: Locked strictly to Dart 2.19 (the final 2.x release).
- **The Workflow**:
  1. Downgrade your local SDK to 2.19.
  2. Run `dart pub outdated --mode=null-safety` to update dependencies.
  3. Run the interactive dart migrate web UI and approve the automated suggestions.
  4. Upgrade to Dart 3.0+ and manually fix the remaining errors.
- **The Gotcha**: When the 2.19 analyzer gets confused by complex data flow, it defaults to forcefully appending the `!` (bang/null assertion) operator to silence the compiler. This will pass the build step but introduces fatal runtime crashes if that value actually turns out to be null.

### The "New" Way (AI Agents + Dart MCP)
This approach leverages LLMs to semantically refactor the code to achieve crash-free, sound null safety entirely within a modern environment.
- **Required SDK**: Dart 3.9 (or later).
- **The Workflow**:
  1. Install an agentic IDE (Cursor, Windsurf) or use a CLI agent (Claude Code).
  2. Configure the IDE's `mcp.json` to run the `dart mcp-server` command.
  3. Instruct the agent to systematically sweep the legacy files. The agent uses the MCP to run `dart analyze`, reads the explicit null-safety errors, rewrites the logic (often utilizing Dart 3 pattern matching), and re-tests the file until it passes.
- **The Gotcha**: You cannot use "zero-shot" prompting (e.g., just asking ChatGPT to convert a file). If the agent is not hooked into the Dart MCP to run the compiler against its own work, it will confidently hallucinate invalid types.

## 4. React-Specific Guardrails for the Agents
Because your codebase utilizes React wrappers rather than Flutter, generic AI prompts will cause headaches. Agents are heavily trained on Flutter and will try to apply Flutter paradigms.
Establish these strict rules in your repository's `.cursorrules` or `AGENTS.md` file:
- **The `late` Keyword Override**: AI agents default to making uninitialized variables nullable (`?`). In React-Dart, props and state are injected by the React wrapper after instantiation but before `componentDidMount`. Instruct the agent: "Always use the `late` keyword for React props and state rather than making them nullable, to prevent polluting the component with unnecessary null checks."
- **Mixin Class Modifiers**: Dart 3 strictly prohibits using standard abstract classes as mixins (a common pattern for sharing React lifecycle logic in older Dart). Instruct the agent: "Convert all abstract classes used with the `with` keyword to `mixin` or `abstract mixin class`."
