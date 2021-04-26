class Input {
 construct new(count, getBtnForIndex) {
  _states = [
   List.filled(count, false),
   List.filled(count, false),
  ]
  _currentStateIndex = 0
  _previousStateIndex = 1
  _getBtnForIndex = getBtnForIndex
  _count = count
 }

 nextStateIndex() {
  _previousStateIndex = _currentStateIndex
  _currentStateIndex = (_currentStateIndex + 1) % _states.count
 }

 btn(index) { _states[_currentStateIndex][index] }
 btnp(index) { _states[_currentStateIndex][index] && !_states[_previousStateIndex][index] }
 btnr(index) { !_states[_currentStateIndex][index] && _states[_previousStateIndex][index] }
 
 TIC() {
  nextStateIndex()
  for (i in 0..._count) {
    _states[_currentStateIndex][i] = _getBtnForIndex.call(i)
  }
 }
}