//
//  MemoViewModel.swift
//  Doing
//
//  Created by Jinhee on 10/11/24.
//

import Foundation

class MemoViewModel: ObservableObject {
  @Published var memo: Memo
  
  init(memo: Memo) {
    self.memo = memo
  }
}
