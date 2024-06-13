//
//  MusicTableCell.swift
//  AR_Pro
//
//  Created by zjucvglab509 on 2024/6/13.
//

import Foundation
import UIKit

class MusicTableCell: UITableViewCell {
    
    var dbManager = DBManager()
    
    var song: Song! {
        didSet {
            NameLabel.text = song.name
            let record = dbManager.selectRecords(songId: song.id)
            if record.count == 0 {
                RecordLabel.text = "--"
            } else {
                RecordLabel.text = "Highest Score：" + String(record[0].score) + "   Date: " + record[0].date!.formatted()
            }
            let stars = [star_1, star_2, star_3, star_4]
            for i in 0..<4 {
                if i < song.difficulty {
                    stars[i]!.image = UIImage(systemName: "star.fill")
                } else {
                    stars[i]?.image = UIImage(systemName: "star")
                }
            }
        }
    }
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var RecordLabel: UILabel!
    @IBOutlet weak var DifficultyStack: UIStackView!
    
    @IBOutlet weak var star_4: UIImageView!
    @IBOutlet weak var star_3: UIImageView!
    @IBOutlet weak var star_2: UIImageView!
    @IBOutlet weak var star_1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
