//
//  Haptics.swift
//  ButtonPress
//
//  Created by Dillan Gajarawala on 10/28/20.
//

import Foundation

import CoreHaptics

class HapticManager {
  // 1
  let hapticEngine: CHHapticEngine

  // 2
  init?() {
    // 3
    let hapticCapability = CHHapticEngine.capabilitiesForHardware()
    guard hapticCapability.supportsHaptics else {
      return nil
    }

    // 4
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
      // 1
      let pattern = try basicPattern()
      // 2
      try hapticEngine.start()
      // 3
      let player = try hapticEngine.makePlayer(with: pattern)
      // 4
      try player.start(atTime: CHHapticTimeImmediate)
      // 5
      hapticEngine.notifyWhenPlayersFinished { _ in
        return .stopEngine
      }
    } catch {
      print("Failed to play slice: \(error)")
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
          relativeTime: 0.01)

        return try CHHapticPattern(events: [pattern], parameters: [])
  }
}
