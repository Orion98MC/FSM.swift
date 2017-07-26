# FSM.swift
A very lightweight Finite State Machine in Swift

## Usage

Instanciate an new machine and add transitions... 
Then later you may send events to the machine.

## API

Instanciate a new machine:

```swift
public convenience init(withStates states: [StateType])
```

Define a transition:

```swift
public func transition(on event: EventType, from state: StateType, to target: @escaping @autoclosure () -> StateType?)
```

Send an event:

```swift
public func event(_ event: EventType)
```

## Example

```swift

enum State {
  case on, off
}

enum Event {
  case powerOn, powerOff
}

var machine = FSM<State, Event>(withStates: [.off, .on]) // The default starting state is the first state (here .off)

machine.transition(on: .powerOff, from: .on, to: .off)
machine.transition(on: .powerOn, from: .off, with: {
  // Initialize stuff
  return .on // Return the next state
})

machine.definedState(.off)?.onEnter = {
  // Do stuff on entering off state
}

machine.event(.powerOn)
```

## License terms

Copyright (c), 2017 Thierry Passeron

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.