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
  
  var body: some View {
    
    
    VStack(alignment: .leading, spacing: 2) {
      // LABEL
      Text("\(label ?? "")").padding(.trailing)
        .font(.subheadline)
      
      // INPUT FIELD
      HStack {
        // MARK: HOUR FIELD
        TextField("HH", text: $hour)
          .padding(.horizontal, 2)
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
            
            // FOCUS
            if mintue.count == 2 {
              focus = .meridiem
            }
            
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
            
            // LIMIT TO LETTER
            let letter = $0.filter { $0.isLetter }
            
            // LIMIT CHARACTER COUNT
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


// PREVIEW
struct TimeFieldView_Previews: PreviewProvider {
  static var previews: some View {
    TimeFieldView(label: "Enter Time")
  }
}


//rgb(229, 231, 235);
