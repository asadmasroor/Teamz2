//
//  JoinedChallengeViewCell.swift
//  Teamz2
//
//  Created by Asad Masroor on 24/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit

protocol joinedChallengeDelegate: AnyObject {
    func attemptChallenegeButtonPressed(cell: JoinedChallengeViewCell)
    func viewAttemptsButtonPressed(cell: JoinedChallengeViewCell)
    
}
class JoinedChallengeViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    weak var delegate: joinedChallengeDelegate?


    @IBAction func attemptChallenegeButtonPressed(_ sender: Any) {
        delegate?.attemptChallenegeButtonPressed(cell: self)
    }
    
    @IBAction func viewAttemptsButtonPressed(_ sender: Any) {
        delegate?.viewAttemptsButtonPressed(cell: self)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var clubLabel: UILabel!
    
    func setChallenge(challenge: Challenge){
        self.nameLabel.text = ("\(challenge.name): \(calculateTimeleft(expiryDate: challenge.expirydate)) days left")
        self.descriptionLabel.text = challenge.desc
        self.milesLabel.text = String(challenge.miles)
        self.clubLabel.text = challenge.club?.name
        
        adjustUITextViewHeight(arg: descriptionLabel)
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
       arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
        arg.textAlignment = .center
        

    }
    
    func calculateTimeleft(expiryDate: Date) -> Int{
        let currentTime = Date()
        
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: currentTime)
        let date2 = calendar.startOfDay(for: expiryDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day!

    }
    
    
    
    
    
    
    
}
