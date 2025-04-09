//
//  TimeInput.swift
//  TimeField
//
//  Created by Jim Lambert on 4/9/25.
//

import SwiftUI
import Combine
import UIKit

struct TimeInput: View {
  
  @Binding var text: String
  let type: TimeInputModifier.TimeInputType
  let placeholder: String = "--"
  let keyboard: UIKeyboardType = .default
  let handle: (Result<[String.Element], Never>.Publisher.Output) -> Void
  
  var body: some View {
    if type == .hour {
      TextField("HH", text: $text)
        .modifier(TimeInputModifier(type: .hour, keyboard: .numberPad))
        .onReceive(text.publisher.collect(), perform: handle)
    } else if type == .minute {
      TextField("MM", text: $text)
        .modifier(TimeInputModifier(type: .minute, keyboard: .numberPad))
        .onReceive(text.publisher.collect(), perform: handle)
    } else {
      TextField("--", text: $text)
        .modifier(TimeInputModifier(type: .meridiem, keyboard: .default))
        .onReceive(text.publisher.collect(), perform: handle)
    }
  }
}

struct TimeInputModifier: ViewModifier {
  let type: TimeInputType
  let keyboard: UIKeyboardType
  
  func body(content: Content) -> some View {
    content
      .multilineTextAlignment(type.alignment())
      .autocorrectionDisabled()
      .fixedSize()
      .keyboardType(keyboard)
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
  }
}


