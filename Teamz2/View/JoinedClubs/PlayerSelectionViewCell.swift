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
    
}

class PlayerSelectionViewCell: UITableViewCell {
    
weak var delegate: playerSelectionDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!
    @IBAction func confirmButtonPressed(_ sender: Any) {
        delegate?.confirmButtonPressed(cell: self)
    }
    
    
    @IBAction func declineButtonPressed(_ sender: Any) {
        delegate?.declineButtonPressed(cell: self)
    }
}
