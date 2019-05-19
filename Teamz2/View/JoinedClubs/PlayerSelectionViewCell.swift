//
//  PlayerSelectionViewCellTableViewCell.swift
//  Teamz2
//
//  Created by Asad Masroor on 11/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit

protocol playerSelectionDelegate: AnyObject {
    func confirmButtonPressed(cell: PlayerSelectionViewCell)
    func declineButtonPressed(cell: PlayerSelectionViewCell)
    func decideButtonPressed(cell: PlayerSelectionViewCell)
    
}

class PlayerSelectionViewCell: UITableViewCell {
    
weak var delegate: playerSelectionDelegate?
    
    @IBOutlet weak var decideButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatTime(date: Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func formatDate(date: Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        delegate?.confirmButtonPressed(cell: self)
    }
    
    
    @IBAction func declineButtonPressed(_ sender: Any) {
        delegate?.declineButtonPressed(cell: self)
    }
    
    
    @IBAction func decideButtonPressed(_ sender: Any) {
        delegate?.decideButtonPressed(cell: self)
    }
}
