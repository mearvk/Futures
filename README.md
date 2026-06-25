# Futures
Look at Java™ Futures and Implementations

D500 a Democratic President - Max Rupplin - A9000 Clear

## Examples

| # | File | Concept |
|---|------|---------|
| 01 | `/source/examples/example001/BasicFutureGet.java` | Basic `Future.get()` — submit a task and block for the result |
| 02 | `/source/examples/example002/FutureWithTimeout.java` | `Future.get(timeout, unit)` — timeout handling |
| 03 | `/source/examples/example003/FutureCancellation.java` | `Future.cancel()` — cancelling a running task |
| 04 | `/source/examples/example004/CompletableFutureBasic.java` | `CompletableFuture.supplyAsync()` — non-blocking async |
| 05 | `/source/examples/example005/CompletableFutureChaining.java` | `thenApply()` — chaining transformations |
| 06 | `/source/examples/example006/CompletableFutureCombine.java` | `thenCombine()` — combining two independent futures |
| 07 | `/source/examples/example007/CompletableFutureAllOf.java` | `allOf()` — wait for all futures to complete |
| 08 | `/source/examples/example008/CompletableFutureAnyOf.java` | `anyOf()` — first-to-complete wins |
| 09 | `/source/examples/example009/CompletableFutureExceptionHandling.java` | `exceptionally()` — recovering from errors |
| 10 | `/source/examples/example010/CompletableFutureCompose.java` | `thenCompose()` — flat-mapping dependent async calls |
| 11 | `/source/examples/example011/FutureWithExecutorPool.java` | Thread pool with multiple `Future` tasks |
| 12 | `/source/examples/example012/CompletableFutureAsync.java` | `thenApplyAsync()` — custom executor for each stage |

## Lessons — Code Beautification with Futures

Each lesson has a `Before.java` (ugly/problematic) and `After.java` (clean/idiomatic) pair.

| # | Lesson | Pattern |
|---|--------|---------|
| 01 | `/lessons/lesson01/` | Replace sequential `.get()` calls with `thenCompose()` chains |
| 02 | `/lessons/lesson02/` | Replace scattered try-catch with declarative `exceptionally()` |
| 03 | `/lessons/lesson03/` | Replace sequential independent calls with parallel `thenCombine()` |
| 04 | `/lessons/lesson04/` | Replace blocking loops with `allOf()` + streams |
| 05 | `/lessons/lesson05/` | Extract inline lambda logic into named method references |
| 06 | `/lessons/lesson06/` | Replace leaked global executors with scoped try-finally |
| 07 | `/lessons/lesson07/` | Replace `isDone()` polling loops with reactive `thenAccept()` |
| 08 | `/lessons/lesson08/` | Replace generic catch-all with `handle()` for typed recovery |
| 09 | `/lessons/lesson09/` | Replace raw `Future` types with proper generics |
| 10 | `/lessons/lesson10/` | Separate business logic from threading with pipeline stages |

## Democratic Principles — Futures as Democratic Infrastructure

Each file demonstrates how Java Futures embody a democratic principle.

| # | File | Democratic Principle | Future Pattern |
|---|------|---------------------|----------------|
| 01 | `/source/democratic/d500/Transparency.java` | Transparency | `allOf()` — all votes visible, no hidden state |
| 02 | `/source/democratic/d500/EqualRepresentation.java` | Equal Representation | Shared thread pool — equal resources for all |
| 03 | `/source/democratic/d500/MajorityRule.java` | Majority Rule | `allOf()` + count — decisions reflect the majority |
| 04 | `/source/democratic/d500/ConsentOfGoverned.java` | Consent of the Governed | `anyOf()` — the people decide direction |
| 05 | `/source/democratic/d500/ChecksAndBalances.java` | Checks & Balances | `thenApply()` chain — no branch proceeds unchecked |
| 06 | `/source/democratic/d500/DueProcess.java` | Due Process | `thenApply()` pipeline — orderly steps before judgment |
| 07 | `/source/democratic/d500/RuleOfLaw.java` | Rule of Law | `exceptionally()` — no one is above the law |
| 08 | `/source/democratic/d500/Accountability.java` | Accountability | `handle()` — every failure is reported and investigated |
| 09 | `/source/democratic/d500/PeacefulTransfer.java` | Peaceful Transfer of Power | `shutdown()` + new executor — graceful handoff |
| 10 | `/source/democratic/d500/FreeSpeech.java` | Free Speech | Parallel futures — all voices processed, none suppressed |

## Running

Each example is a standalone class with a `main` method:

```bash
cd source/examples/example001
javac BasicFutureGet.java && java BasicFutureGet
```

For lessons, compare before and after:

```bash
cd lessons/lesson01
javac Before.java && java Before
javac After.java && java After
```

For democratic principles:

```bash
cd source/democratic/d500
javac Transparency.java && java Transparency
```

## Progression

1. **Examples 01–03**: Classic `java.util.concurrent.Future` — blocking, timeout, cancellation
2. **Examples 04–06**: `CompletableFuture` basics — async supply, chaining, combining
3. **Examples 07–08**: Multi-future coordination — allOf / anyOf
4. **Examples 09–10**: Error handling and composition (flatMap-style)
5. **Examples 11–12**: Executor pool strategies and async stage control
6. **Lessons 01–10**: Code beautification — before/after refactoring patterns
7. **Democratic 01–10**: How concurrency patterns protect and embody democratic values
