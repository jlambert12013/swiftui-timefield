//
//  ContentView.swift
//  TimeField
//
//  Created by Jim Lambert on 4/1/25.
//

import SwiftUI

struct TimeFieldView: View {
  @State private var hour = ""
  @State private var mintue = ""
  @State private var meridiem = ""
  @FocusState private var focus: FocusField?
  
  let label: String?
  
  enum FocusField {
    case hour, minute, meridiem
  }
  
  var body: some View {
    HStack(spacing: 4) {
      // MARK: LABEL
      Text("\(label ?? "")").padding(.trailing)
      
      // MARK: HOUR FIELD
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
      
      // MARK: DIVIDER
      Text(":").opacity(0.4)
      
      // MARK: MINUTES
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
          
          if mintue.count == 2 {
            focus = .meridiem
          }
          
        }.padding(.trailing, 2)
      
      
      // MARK: MERIDIEM
      TextField("--", text: $meridiem)
        .multilineTextAlignment(.leading)
        .keyboardType(.default)
        .autocorrectionDisabled()
        .fixedSize()
        .focused($focus, equals: .meridiem)
        .onReceive(meridiem.publisher.collect()) {
          
          // LIMIT TO LETTER
          let letter = $0.filter { $0.isLetter }
          
          // LIMIT CHARACTER COUNT
          meridiem = String(letter.prefix(2))
          meridiem  = meridiem.uppercased()
          meridiem = meridiem.filter {_ in
            meridiem.contains(where: { "AP".contains($0) })
          }
          
          if meridiem.count == 1 {
            meridiem = meridiem + "M"
          }
          
         
        }
    }.fixedSize()
  }
}

struct TimeFieldView_Previews: PreviewProvider {
  static var previews: some View {
    TimeFieldView(label: "Enter Time")
  }
}


enum Meridiem: String {
  case am = "AM"
  case pm = "PM"
}
