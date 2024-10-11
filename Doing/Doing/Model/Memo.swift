//
//  Memo.swift
//  Doing
//
//  Created by Jinhee on 10/11/24.
//

import Foundation

struct Memo: Hashable {
  var title: String
  var content: String
  var date: Date
  var id = UUID()
  
  var convertedDate: String {
    String("\(date.formattedDay) - \(date.formattedTime)")
  }
}
