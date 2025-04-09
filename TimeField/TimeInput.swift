//
//  TimeInput.swift
//  TimeField
//
//  Created by Jim Lambert on 4/9/25.
//

import SwiftUI

struct TimeInput: View {
  var text: Binding<String>
  let type: TimeInputModifier.TimeInputType
  
  var body: some View {
    if type == .hour {
      TextField("HH", text: text)
        .modifier(TimeInputModifier(text: text, type: .hour, handle: {
          handleHour("\($0)")
        }))
    } else if type == .minute {
      TextField("MM", text: text)
        .modifier(TimeInputModifier(text: text, type: .minute, handle: {
          handleMinute("\($0)")
        }))
    } else {
      TextField("--", text: text)
        .modifier(TimeInputModifier(text: text, type: .meridiem, handle: {
          handleMeridiem("\($0)")
        }))
    }
  }
}

struct TimeInputModifier: ViewModifier {
  var text: Binding<String>
  let type: TimeInputType
  let keyboard: UIKeyboardType = .numberPad
  let handle: (Result<[String.Element], Never>.Publisher.Output) -> Void
  
  func body(content: Content) -> some View {
    content
      .padding(2)
      .multilineTextAlignment(type.alignment())
      .autocorrectionDisabled()
      .fixedSize()
      .keyboardType(type.keyboardType())
      .onReceive(text.wrappedValue.publisher.collect(), perform: handle)
  }
  
  enum TimeInputType {
    case hour, minute, meridiem
    func alignment() -> TextAlignment {
      switch self {
        case .hour:
          return .trailing
        case .minute:
          return .leading
        case .meridiem:
          return .leading
      }
    }
    
    func keyboardType() -> UIKeyboardType {
      switch self {
        case .hour, .minute:
          return .numberPad
        case .meridiem:
          return .default
      }
    }
  }
}

extension TimeInput {
  func handleHour(_ input: String) {
    // FILTER OUT NON-NUMERIC CHARACTERS
    let number = input.filter { $0.isNumber }
    
    // LIMIT CHARACTER COUNT
    text.wrappedValue  = String(number.prefix(2))
    
    // PREFIX WITH ZERO
    for num in 2...9 {
      if text.wrappedValue.hasPrefix("\(num)") {
        text.wrappedValue = "0\(num)"
      }
    }
    
    // REMOVE SINGLE ZERO (BACKSPACE ALL)
    if  text.wrappedValue == "0" {  text.wrappedValue.removeLast() }
    
    // HANDLE 10, 11, 12 O'CLOCK
    if  text.wrappedValue .hasPrefix("1") {
      // REMOVE REJECTED SUFFIX
      for reject in 3...9 {
        if  text.wrappedValue .hasSuffix("\(reject)") {
          text.wrappedValue .removeLast()
        }
      }
    }
    
    //    if hour.count == 2 {
    //      focus = .minute
    //    }
  }
  
  func handleMinute(_ input: String) {
    // FILTER OUT NON-NUMERIC CHARACTERS
    let number = input.filter { $0.isNumber }
    
    // LIMIT CHARACTER COUNT
    text.wrappedValue  = String(number.prefix(2))
    
    // REMOVE REJECTED PREFIX
    for reject in 6...9 {
      if  text.wrappedValue.hasPrefix("\(reject)") {
        text.wrappedValue .removeAll()
      }
    }
    
    // FOCUS
    //    if mintue.count == 2 {
    //      focus = .meridiem
    //    }
  }
  
  func handleMeridiem(_ input: String) {
    let letter = input.filter { $0.isLetter }
    text.wrappedValue = String(letter.prefix(2))
    text.wrappedValue =  text.wrappedValue.uppercased()
    text.wrappedValue =  text.wrappedValue.filter { _ in
      text.wrappedValue.contains(where: { "AP".contains($0) })
    }
    
    if  text.wrappedValue.count == 1 {
      text.wrappedValue  =  text.wrappedValue  + "M"
    }
    
  }
  
}
