//
//  ContentView.swift
//  TimeField
//
//  Created by Jim Lambert on 4/1/25.
//

import SwiftUI


struct TimeFieldView: View {
  @State var userInput: String = ""
  @State private var hour = ""
  @State private var mintue = ""
  @State private var meridiem = ""
  @FocusState private var focus: FocusField?
  
  let label: String?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text("\(label ?? "")")
        .padding(.trailing)
        .font(.subheadline)
      HStack {
        // MARK: HOUR FIELD
        TimeInput(text: $hour) { value in
          handleHour("\(value)")
        }
        
        //
        //        TextField("HH", text: $hour)
        //          .padding(.horizontal, 2)
        //          .multilineTextAlignment(.trailing)
        //          .keyboardType(.numberPad)
        //          .autocorrectionDisabled()
        //          .fixedSize()
        
        // MARK: DIVIDER
        Text(":").opacity(0.4)
        
        // MARK: MINUTES
        TextField("MM", text: $mintue)
          .padding(.horizontal, 2)
          .multilineTextAlignment(.leading)
          .keyboardType(.numberPad)
          .autocorrectionDisabled()
          .fixedSize()
          .focused($focus, equals: .minute)
          .onReceive(mintue.publisher.collect()) {
            handleMinute("\($0)")
          }.padding(.trailing, 2)
        
        // MARK: MERIDIEM
        TextField("--", text: $meridiem)
          .padding(.horizontal, 2)
          .multilineTextAlignment(.leading)
          .keyboardType(.default)
          .autocorrectionDisabled()
          .fixedSize()
          .focused($focus, equals: .meridiem)
          .onReceive(meridiem.publisher.collect()) {
            handleMeridiem("\($0)")
          }
      }
      .padding(.vertical, 6)
      .padding(.horizontal, 10)
      .font(.headline)
      .opacity(0.8)
      //      .background(Color(red: 39/255, green: 39/255, blue: 42/255))
      //      .foregroundStyle(Color(red: 229/255, green: 231/255, blue: 235/255))
      .cornerRadius(6)
      .fixedSize()
    }
  }
}

extension TimeFieldView {
  enum FocusField {
    case hour, minute, meridiem
  }
}



extension TimeFieldView {
  
  // HOUR
  func handleHour(_ input: String) {
    // FILTER OUT NON-NUMERIC CHARACTERS
    let number = input.filter { $0.isNumber }
    
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
    
    // HANDLE 10, 11, 12 O'CLOCK
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
  
  // HANDLE MINUTE
  func handleMinute(_ input: String) {
    
    // FILTER OUT NON-NUMERIC CHARACTERS
    let number = input.filter { $0.isNumber }
    
    // LIMIT CHARACTER COUNT
    mintue = String(number.prefix(2))
    
    // REMOVE REJECTED PREFIX
    for reject in 6...9 {
      if mintue.hasPrefix("\(reject)") {
        mintue.removeAll()
      }
    }
    
    // FOCUS
    if mintue.count == 2 {
      focus = .meridiem
    }
  }
  
  // HANDLE MERIDIEM
  func handleMeridiem(_ input: String) {
    let letter = input.filter { $0.isLetter }
    
    meridiem = String(letter.prefix(2))
    meridiem = meridiem.uppercased()
    meridiem = meridiem.filter { _ in
      meridiem.contains(where: { "AP".contains($0) })
    }
    
    if meridiem.count == 1 {
      meridiem = meridiem + "M"
    }
    
  }
  
}


// PREVIEW
struct TimeFieldView_Previews: PreviewProvider {
  static var previews: some View {
    TimeFieldView(label: "Departure")
  }
}

