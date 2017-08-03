//
//  FSM.swift
//  A Finite State Machine in Swift
//
//  Copyright © 2017 Thierry Passeron. All rights reserved.
//

import Foundation

public class FSM<StateType: Equatable, EventType: Equatable> {

  struct StateTransition: CustomStringConvertible {
    var event: EventType
    var state: StateType
    var target: () -> StateType?

    init(event: EventType, state: StateType, target: @escaping () -> StateType?) {
      self.event = event
      self.state = state
      self.target = target
    }

    var description: String { return "\(event)@\(state)" }
  }

  public class StateDefinition {
    var state: StateType
    var onEnter: (() -> Void)?
    var onLeave: (() -> Void)?
    var onCycle: (() -> Void)?

    init(_ state: StateType) {
      self.state = state
    }
  }

  public var name: String = ""
  public var debugMode: Bool = false // Shows some NSLog when set to true
  private var definitions: [StateDefinition] = []
  private var transitions: [StateTransition] = []

  private var stateDefinition: StateDefinition {
    didSet {
      previousState = oldValue.state
    }
  }
  public var state: StateType { return stateDefinition.state }
  public var lastEvent: EventType?
  public var previousState: StateType?

  public init(withDefinitions definitions: [StateDefinition]) {
    self.definitions = definitions
    self.stateDefinition = definitions.first!
  }

  public init(withStates states: [StateType]) {
    self.definitions = states.map({ StateDefinition($0) })
    self.stateDefinition = definitions.first!
  }

  public func transition(on event: EventType, from state: StateType, to target: @escaping @autoclosure () -> StateType?) {
    transitions.append(StateTransition(event: event, state: state, target: target))
  }

  public func transition(on event: EventType, from state: StateType, with target: @escaping () -> StateType?) {
    transitions.append(StateTransition(event: event, state: state, target: target))
  }

  public func definedState(_ state: StateType) -> StateDefinition? {
    return definitions.filter({ $0.state == state }).first
  }

  public func setState(_ state: StateType) {
    if debugMode { NSLog("FSM Set state \(state)") }
    let definition = definedState(state)!
    guard definition.state != self.state else {
      stateDefinition.onCycle?()
      return
    }

    stateDefinition.onLeave?()
    stateDefinition = definition
    stateDefinition.onEnter?()
  }

  public func event(_ event: EventType) {
    if debugMode { NSLog("FSM Event: \(event)") }
    lastEvent = event
    guard let aTransition = transitions.filter({ $0.event == event && $0.state == state }).first else {
      if debugMode { NSLog("No transition for \(event)@\(state) in \(self.transitions)") }
      return
    }

    guard let targetState = aTransition.target() else {
      if debugMode { NSLog("No target state!") }
      return
    }
    
    setState(targetState)
  }
}
