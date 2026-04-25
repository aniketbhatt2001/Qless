# OrderTimerBar Web Fix

## Problem

`OrderTimerBar` widget worked on localhost but broke when deployed to Firebase Hosting.

## Root Cause

Flutter Web has two renderers:

| Renderer | Default for | Supports BackdropFilter |
|---|---|---|
| **HTML** | Hosted / production builds | No |
| **CanvasKit** | `flutter run` (local dev) | Yes |

The widget uses APIs that require CanvasKit:

- `lib/views/order/widgets/order_timer.dart:129` — `ImageFilter.blur` inside `BackdropFilter`
- `lib/views/order/widgets/order_timer.dart:261` — `FontFeature.tabularFigures()`

So it worked locally (CanvasKit) but silently failed when hosted (HTML renderer).

## Fix

Created `web/flutter_bootstrap.js` — a custom Flutter bootstrap file that explicitly forces the **CanvasKit renderer** for all environments (mobile web, desktop web, hosted).

```js
{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
  onEntrypointLoaded: async function(engineInitializer) {
    let appRunner = await engineInitializer.initializeEngine({
      renderer: "canvaskit",
    });
    await appRunner.runApp();
  }
});
```

## Why This Approach

- No changes to widget code
- No build flags to remember
- Renderer is baked into the web app — every deploy uses CanvasKit consistently

## Files Changed

| File | Change |
|---|---|
| `web/flutter_bootstrap.js` | Created — forces CanvasKit renderer |
| `lib/views/order/widgets/order_timer.dart` | No changes |
