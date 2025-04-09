//
//  ContentView.swift
//  TimeField
//
//  Created by Jim Lambert on 4/1/25.
//

import SwiftUI


struct TimeInputView: View {
  @State private var hour = ""
  @State private var mintue = ""
  @State private var meridiem = ""
  //  @FocusState private var focus: FocusField?
  
  let label: String?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text("\(label ?? "")")
        .padding(.trailing)
        .font(.subheadline)
      HStack {
        TimeInput(text: $hour, type: .hour)
        Text(":").opacity(0.5)
        TimeInput(text: $mintue, type: .minute)
        TimeInput(text: $meridiem, type: .meridiem)
      }
      .background(Color(red: 39/255, green: 39/255, blue: 42/255))
      .foregroundStyle(Color(red: 229/255, green: 231/255, blue: 235/255))
      //      .fixedSize()
      //      .padding(.vertical, 6)
      //      .padding(.horizontal, 10)
      //      .font(.headline)
      //      .opacity(0.8)
      //      .cornerRadius(6)
    }
  }
}

//extension TimeFieldView {
//  enum FocusField {
//    case hour, minute, meridiem
//  }
//}

struct TimeInputVieww_Previews: PreviewProvider {
  static var previews: some View {
    TimeInputView(label: "Departure")
  }
}

