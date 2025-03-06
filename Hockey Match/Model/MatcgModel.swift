//
//  MatcgModel.swift
//  Hockey Match
//
//  Created by DF on 07/06/24.
//

import Foundation

struct MatchModel {
    var teamOne: TeamHockey?
    var teamTwo: TeamHockey?
    var date: Date = Date()
    var location: String = ""
    var reward: String = ""
    var playoffStage: String = ""
    
    func checkFilled() -> Bool {
        if teamOne != nil
            && teamTwo != nil
            && !location.isEmpty
            && !reward.isEmpty
            && !playoffStage.isEmpty
        {
            return false
        } else {
            return true
        }
    }
}
