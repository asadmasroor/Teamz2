//
//  JoinedFixtureViewCell.swift
//  Teamz2
//
//  Created by Asad Masroor on 08/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit

protocol joinedFixtureDelegate: AnyObject {
   
    func availableButtonPressed(cell: JoinedFixtureViewCell)
    func notAvailableButtonPressed(cell: JoinedFixtureViewCell)
  
}
class JoinedFixtureViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    weak var delegate: joinedFixtureDelegate?
    
  
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

 
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    func setFixture(fixture: Fixture){
        self.addressLabel.text = fixture.address
        self.titleLabel.text = fixture.title
        self.dateLabel.text = "Date: \(fixtureDate(date: fixture.date)), Time: \(fixtureTime(date: fixture.time)) "
    }
    @IBAction func availableButtonPressed(_ sender: UIButton) {
        delegate?.availableButtonPressed(cell: self)
    }
    
    @IBAction func notAvailableButtonPressed(_ sender: Any) {
        delegate?.notAvailableButtonPressed(cell: self)
    }
    
    func fixtureTime(date: Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func fixtureDate(date: Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

}
