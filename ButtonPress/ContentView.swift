//
//  ContentView.swift
//  ButtonPress
//
//  Created by Dillan Gajarawala on 10/21/20.
//

import SwiftUI
import CoreHaptics

var engine: CHHapticEngine!
var supportsHaptics: Bool = false
let hapticDict = [
    CHHapticPattern.Key.pattern: [
        [CHHapticPattern.Key.event: [CHHapticPattern.Key.eventType: CHHapticEvent.EventType.hapticTransient,
              CHHapticPattern.Key.time: 0.001,
              CHHapticPattern.Key.eventDuration: 1.0] // End of first event
        ] // End of first dictionary entry in the array
    ] // End of array
] // End of haptic dictionary

struct ContentView: View {
    var body: some View {
      VStack {
        Button(action: buttonPressed) {
          Text("Press Me!")
        }.frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .foregroundColor(.black)
        .background(Color.red)
        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
      }.onAppear(perform: createEngine)
    }
}

func buttonPressed() {
  if supportsHaptics {
    let pattern: CHHapticPattern!
    let player: CHHapticPatternPlayer
    // creates haptic pattern from global dictionary
    do {
      pattern = try CHHapticPattern(dictionary: hapticDict)
    } catch let error {
      fatalError("Pattern Creation Error: \(error)")
    }
    // creates haptic player for the pattern
    do {
      player = try engine.makePlayer(with: pattern)
    } catch let error {
      fatalError("Player Creation Error: \(error)")
    }
    // plays the actual pattern
    engine.start(completionHandler:nil)
    do {
      try player.start(atTime: 0)
    } catch let error {
      fatalError("Pattern Play Error: \(error)")
    }
    engine.stop(completionHandler: nil)
  } else {
    print("button was pressed!")
  }
}

func createEngine() {
  // Check if the device supports haptics.
  let hapticCapability = CHHapticEngine.capabilitiesForHardware()
  supportsHaptics = hapticCapability.supportsHaptics
  // Create and configure a haptic engine.
  if supportsHaptics {
    do {
        engine = try CHHapticEngine()
    } catch let error {
        fatalError("Engine Creation Error: \(error)")
    }
  } else {
    print("Doesn't support core haptics")
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
