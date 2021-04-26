class EventEmitter {
 construct new() {
  _listeners = {}
 }

 addEventListener(evName, fn) {
  if (!(_listeners[evName] is List)) {
   _listeners[evName] = []
  }
  _listeners[evName].add(fn)
 }

 removeEventListeners(evName, fn) {
  if (!(_listeners[evName] is List)) {
   return
  }
  _listeners[evName].remove(fn)
 }

 removeAllListeners() {
  _listeners = {}
 }

 emitEvent(evName) {
  emitEvent(evName, null)
 }

 emitEvent(evName, evData) {
  if (!(_listeners[evName] is List)) {
   return
  }
  for (fn in _listeners[evName]) {
   fn.call(evName, evData)
  }
 }
}