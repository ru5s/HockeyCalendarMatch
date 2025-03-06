//
//  PlayerModel.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import Foundation
import UIKit

struct PlayerModel {
    var image: UIImage?
    var name: String = ""
    var yearsOld: String = ""
    var number: String = ""
    var position: PositionPlayer?
    
    func checkFilled() -> Bool {
        if image != nil
            && !name.isEmpty
            && !yearsOld.isEmpty
            && !number.isEmpty
            && position != nil
        {
            return false
        } else {
            return true
        }
    }
    
    mutating func getData(data: PlayersHockey?) {
        if let imageData = data?.photoPlayer {
            image = UIImage(data: imageData) ?? UIImage()
        }
        name = data?.namePlayer ?? ""
        yearsOld = data?.yearsOldPlayer ?? ""
        number = data?.teamNumberPlayer ?? ""
        if let positionData = data?.positionPlayer {
            position = PositionPlayer(rawValue: positionData)
        }
    }
}
