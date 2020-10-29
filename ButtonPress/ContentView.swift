//
//  ContentView.swift
//  ButtonPress
//
//  Created by Dillan Gajarawala on 10/21/20.
//

import SwiftUI
import CoreHaptics

//var engine: CHHapticEngine!
//var supportsHaptics: Bool = false

struct ContentView: View {
  @State private var hapticManager: HapticManager?
  @State private var sendHaptics: Bool = false
  private var queue = DispatchQueue(label: "testqueue", attributes: .concurrent)
    var body: some View {
      VStack {
        Spacer()
        Button(action: startPressed) {
          Text("Start Haptics!")
        }.frame(width: 300, height: 300, alignment: .center)
        .foregroundColor(.black)
        .background(Color.green)
        .clipShape(Circle())
        Spacer()
        Button(action: stopPressed) {
          Text("Stop Haptics!")
        }.frame(width: 300, height: 300, alignment: .center)
        .foregroundColor(.black)
        .background(Color.red)
        .clipShape(Circle())
        Spacer()
      }.onAppear(perform: createHapticManager)
    }
  
  func startPressed() {
    sendHaptics = true
    while sendHaptics == true {
      queue.async {
        hapticManager?.playPattern()
      }
    }
  }
  
  func stopPressed() {
    queue.async {
      sendHaptics = false
    }
  }
  
  func createHapticManager() {
    hapticManager = HapticManager()
  }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
