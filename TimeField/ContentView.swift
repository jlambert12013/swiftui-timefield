//
//  ContentView.swift
//  TimeField
//
//  Created by Jim Lambert on 4/1/25.
//

import SwiftUI

struct ContentView: View {
  @State private var hour = ""
  
  var body: some View {
    TextField("HH", text: $hour)
      .multilineTextAlignment(.trailing)
      .autocorrectionDisabled()
      .fixedSize()
      .onReceive(hour.publisher.collect()) {
        // FILTER OUT NON-NUMERIC CHARACTERS
        
        
        
        
        // LIMIT CHARACTER COUNT
        hour = String($0.prefix(2))
          
        // PREFIX WITH ZERO
        for num in 2...9 {
          if hour.hasPrefix("\(num)") {
            hour = "0\(num)"
          }
        }
        
        // REMOVE SINGLE ZERO (BACKSPACE ALL)
        if hour == "0" {
          hour.removeLast()
        }
        
        // REMOVE REJECTED SUFFIX
        if hour.hasPrefix("1") {
          for reject in 3...9 {
            if hour.hasSuffix("\(reject)") {
              hour.removeLast()
            }
          }
        }
        
        
      }
      .onSubmit {
        
        // SUBMIT ONE O'CLOCK
        if hour == "1" {
          hour = "01"
        }
      }
  }
}






struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


