//
//  ContentView.swift
//  TimeField
//
//  Created by Jim Lambert on 4/1/25.
//

import SwiftUI

struct ContentView: View {
  @State private var hour = ""
  @State private var mintue = ""
  @FocusState private var focus: FocusField?
  
  enum FocusField {
    case hour, minute
  }
  
  var body: some View {
    HStack(spacing: 4) {
      
      // HOUR
      TextField("HH", text: $hour)
        .multilineTextAlignment(.trailing)
        .keyboardType(.numberPad)
        .autocorrectionDisabled()
        .fixedSize()
        .focused($focus, equals: .hour)
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
          
          if hour.hasPrefix("1") {
            // REMOVE REJECTED SUFFIX
            for reject in 3...9 {
              if hour.hasSuffix("\(reject)") {
                hour.removeLast()
              }
            }
          }
          
          if hour.count == 2 {
            focus = .minute
            
          }
        }
      
      Text(":").opacity(0.4)
      
      // MINUTES
      TextField("MM", text: $mintue)
        .multilineTextAlignment(.leading)
        .keyboardType(.numberPad)
        .autocorrectionDisabled()
        .fixedSize()
        .focused($focus, equals: .minute)
        .onReceive(mintue.publisher.collect()) {
          // FILTER OUT NON-NUMERIC CHARACTERS
          let number = $0.filter { $0.isNumber }
          
          // LIMIT CHARACTER COUNT
          mintue = String(number.prefix(2))
          
          // REMOVE REJECTED PREFIX
          for reject in 6...9 {
            if mintue.hasPrefix("\(reject)") {
              mintue.removeAll()
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
