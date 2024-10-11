//
//  PathType.swift
//  Doing
//
//  Created by Jinhee on 10/4/24.
//

enum PathType: Hashable {
    case maintabView
    case todoView
    case memoView(isCreatMode: Bool, memo: Memo?)
}
