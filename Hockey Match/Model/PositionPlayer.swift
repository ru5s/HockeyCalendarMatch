//
//  PositionPlayer.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import Foundation

enum PositionPlayer: Int64 {
    case forward
    case center
    case winger
    case defenseman
    case goaltender
    case spare
    
    func stringDescription() -> String {
        switch self {
        case .forward:
            return "Forward"
        case .center:
            return "Center"
        case .winger:
            return "Winger"
        case .defenseman:
            return "Defenseman"
        case .goaltender:
            return "Goaltender"
        case .spare:
            return "Spare"
        }
    }
}
