//
//  LogCell.swift
//  Treads
//
//  Created by Denis Rakitin on 2019-04-24.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {
    
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(run: Run) {
        durationLbl.text = run.duration.formatTimeDurationToString()
        distanceLbl.text = "\(run.distance.metersToMiles(places: 2)) km"
        paceLbl.text = run.pace.formatTimeDurationToString()
        dateLbl.text = run.date.getDateString()
    }

}
