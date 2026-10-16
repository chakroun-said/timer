// Custom Flutter web bootstrap.
//
// Flutter's generated bootstrap registers a deprecated, no-op service worker
// (flutter_service_worker.js) whose only job is to unregister itself and
// force-navigate every open window. That reload would interrupt a workout that
// is being timed, so the loader is started without serviceWorkerSettings here
// and web/sw.js registers the real offline-first service worker instead.
//
// The two placeholders below are substituted by `flutter build web`; keep them.
{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load();
