//
//  Path.swift
//  Doing
//
//  Created by Jinhee on 10/4/24.
//

import Foundation

class PathModel: ObservableObject {
  @Published var paths: [PathType]
  
  init(paths: [PathType] = []) {
    self.paths = paths
  }
}
