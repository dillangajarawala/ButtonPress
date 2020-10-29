//
//  Haptics.swift
//  ButtonPress
//
//  Created by Dillan Gajarawala on 10/28/20.
//

import Foundation

import CoreHaptics

class HapticManager {
  let hapticEngine: CHHapticEngine

  init?() {
    let hapticCapability = CHHapticEngine.capabilitiesForHardware()
    guard hapticCapability.supportsHaptics else {
      return nil
    }

    do {
      hapticEngine = try CHHapticEngine()
      hapticEngine.isAutoShutdownEnabled = true
    } catch let error {
      print("Haptic engine Creation Error: \(error)")
      return nil
    }
  }
  
  func playPattern() {
    do {
      let pattern = try basicPattern()
      try hapticEngine.start()
      let player = try hapticEngine.makePlayer(with: pattern)
      try player.start(atTime: CHHapticTimeImmediate)
      hapticEngine.notifyWhenPlayersFinished { _ in
        return .stopEngine
      }
    } catch {
      print("Failed to play pattern: \(error)")
    }
  }
}

extension HapticManager {
  private func basicPattern() throws -> CHHapticPattern {

        let pattern = CHHapticEvent(
          eventType: .hapticTransient,
          parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 3.0),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 3.0)
          ],
          relativeTime: 1)

        return try CHHapticPattern(events: [pattern], parameters: [])
  }
}
