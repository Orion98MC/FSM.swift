# FSM.swift
A very lightweight and generic event driven Finite State Machine in Swift

## Usage

Instanciate an new machine and add transitions... 
Then later you may send events to the machine.

## API

The FSM class is a generic class that expects typed states and events. Both types need to be Equatable.

```swift
public class FSM<StateType: Equatable, EventType: Equatable> { ... }
```

Instanciate a new machine:

```swift
public convenience init(withStates states: [StateType])

  _or_

public init(withDefinitions definitions: [StateDefinition])
```

When you use the former form init(withStates:), the states are automatically mapped to StateDefinition-s. FSM uses StateDefinition to augment the state with callbacks (see below)

Define a transition:

```swift
public func transition(on event: EventType, from state: StateType, to target: @escaping @autoclosure () -> StateType?)

  _or_

public func transition(on event: EventType, from state: StateType, with target: @escaping () -> StateType?)
```

Set a state:

```swift
public func setState(_ state: StateType)
```

Send an event:

```swift
public func event(_ event: EventType)
```

### States Callbacks

States can trigger 3 kinds of callbacks:

* onCycle, when a state is cycled (re-entered from itself)
* onEnter, when a state in entered (from a different state)
* onLeave, when a state is leaved (to a different state)

You attach a callback to a state by using its StateDefinition as returned by:

```swift
public func definedState(_ state: StateType) -> StateDefinition?
```

Example:

```swift
machine.definedState(.off)?.onEnter = {
  // Do stuff on entering off state
}
```

State definitions is a simple wraper that augments the state with callbacks. Exemple:

```swift
let sd1 = FSM.StateDefinition(.off)
sd1.onEnter = { ... }
sd1.onCycle = { ... }
sd1.onLeave = { ... }
``` 

## Example

```swift

// Let's define our states and events
enum State { case on, off }
enum Event { case powerOn, powerOff }

// Create the machine
var machine = FSM<State, Event>(withStates: [.off, .on]) // The default starting state is the first state (here .off)

// Add transitions...
machine.transition(on: .powerOff, from: .on, to: .off)
machine.transition(on: .powerOn, from: .off, with: {
  // Initialize stuff
  return .on // Return the next state
})

// Optionaly add callbacks...
machine.definedState(.off)?.onEnter = {
  // Do stuff on entering off state
}

// Done!
machine.event(.powerOn)
```

## License terms

Copyright (c), 2017 Thierry Passeron

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.