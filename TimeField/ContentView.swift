//
//  ContentView.swift
//  TimeField
//
//  Created by Jim Lambert on 4/1/25.
//

import SwiftUI

struct ContentView: View {
  @State private var hour = ""
  @State private var minute = ""
  
  
  var body: some View {
    HStack {
      
      // HOUR
      TextField("HH", text: $hour)
        .multilineTextAlignment(.trailing)
        .keyboardType(.numberPad)
        .autocorrectionDisabled()
        .fixedSize()
        .onReceive(hour.publisher.collect()) {
          // FILTER OUT NON-NUMERIC CHARACTERS
          let number = $0.filter { $0.isNumber }
          
          // LIMIT CHARACTER COUNT
          hour = String(number.prefix(2))
          
          // PREFIX WITH ZERO
          for num in 2...9 {
            if hour.hasPrefix("\(num)") {
              hour = "0\(num)"
            }
          }
          
          // REMOVE SINGLE ZERO (BACKSPACE ALL)
          if hour == "0" { hour.removeLast() }
          
          // REMOVE REJECTED SUFFIX
          for reject in 3...9 {
            if hour.hasSuffix("\(reject)") {
              hour.removeLast()
            }
          }
        }
      
      // MINUTES
      TextField("MM", text: $minute)
        .multilineTextAlignment(.leading)
        .keyboardType(.numberPad)
        .autocorrectionDisabled()
        .fixedSize()
        .onReceive(minute.publisher.collect()) {
          // FILTER OUT NON-NUMERIC CHARACTERS
          let number = $0.filter { $0.isNumber }
          
          
          // LIMIT CHARACTER COUNT
          minute = String(number.prefix(2))
          
          for rejected in 6...9 {
            if minute.hasPrefix("\(rejected)") {
              minute.removeAll()
            }
          }
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
