//
//  TeamModel.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import Foundation
import UIKit

struct TeamModel {
    var image: UIImage?
    var teamName: String = ""
    var totalMatches: String = ""
    var win: String = ""
    var lose: String = ""
    
    func checkFilled() -> Bool {
        if image != nil
            && !teamName.isEmpty
            && !totalMatches.isEmpty
            && !win.isEmpty
            && !lose.isEmpty
        {
            return false
        } else {
            return true
        }
    }
    
    mutating func getData(data: TeamHockey?) {
        if let imageData = data?.logoTeam {
            image = UIImage(data: imageData) ?? UIImage()
        }
        teamName = data?.nameTeam ?? ""
        totalMatches = data?.totalMatchesTeam ?? ""
        win = data?.winTeam ?? ""
        lose = data?.loseTeam ?? ""
    }
}
