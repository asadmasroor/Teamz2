//
//  SearchTableViewCell.swift
//  Teamz2
//
//  Created by Asad Masroor on 07/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import Foundation
import UIKit

protocol SearchClubDelegate: AnyObject {
    func joinButtonPressed(cell: SearchTableViewCell)
    
}

class SearchTableViewCell :  UITableViewCell {
    
    weak var delegate: SearchClubDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descLabel: UITextView!
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        delegate?.joinButtonPressed(cell: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
