//
//  ViewController.swift
//  Team Picker
//
//  Created by Muhamed Zahiri on 11.05.22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var attackerTextfield: UITextField!
    @IBOutlet weak var midfielderTextfield: UITextField!
    @IBOutlet weak var defenderTextfield: UITextField!
    
    @IBOutlet weak var attackerLabel: UILabel!
    @IBOutlet weak var midfielderLabel: UILabel!
    @IBOutlet weak var defenderLabel: UILabel!
    
    @IBOutlet weak var teamALabel: UILabel!
    @IBOutlet weak var teamBLabel: UILabel!
    
    @IBOutlet weak var positionNameStack: UIStackView!
    @IBOutlet weak var positionStack: UIStackView!
    
    @IBOutlet weak var teamNameStack: UIStackView!
    @IBOutlet weak var teamStack: UIStackView!
    
    @IBOutlet weak var createTeamButton: UIButton!
    
    var teamA: [String] = []
    var teamB: [String] = []
    
    var attackers: [String] = []
    var midfielders: [String] = []
    var defenders: [String] = []
    
    var destroyedBalance: String?
    var teamWasFormed: Bool = false
    var moreAttackers: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        attackerTextfield.delegate = self
        midfielderTextfield.delegate = self
        defenderTextfield.delegate = self
    }
    
    func formTeam() {
        teamA.removeAll()
        teamB.removeAll()
        
        attackers.shuffle()
        midfielders.shuffle()
        defenders.shuffle()
        
        switch attackers.count {
        case 0:
            return
        case 1:
            teamA.append(attackers.first!)
        case 2...:
            teamA.append(contentsOf: attackers.split().left)
            teamB.append(contentsOf: attackers.split().right)
            if attackers.count % 2 != 0 {
                moreAttackers = teamA.count > teamB.count ? "teamA" : "teamB"
            }
        default:
            return
        }
        
        compareTeamStrength()
        
        switch midfielders.count {
        case 0:
            return
            
        case 1:
            if destroyedBalance == "teamA" || destroyedBalance == "false" {
                teamB.append(midfielders.first!)
            } else {
                teamA.append(midfielders.first!)
            }
            
        case 2...:
            if destroyedBalance == "teamA" || destroyedBalance == "false" {
                teamA.append(contentsOf: midfielders.split().left.count < midfielders.split().right.count ? midfielders.split().left : midfielders.split().right)
                teamB.append(contentsOf: midfielders.split().left.count < midfielders.split().right.count ? midfielders.split().right : midfielders.split().left)
            } else {
                teamA.append(contentsOf: midfielders.split().left.count < midfielders.split().right.count ? midfielders.split().right : midfielders.split().left)
                teamB.append(contentsOf: midfielders.split().left.count < midfielders.split().right.count ? midfielders.split().left : midfielders.split().right)
            }
            
        default:
            return
        }
        
        compareTeamStrength()
        
        switch defenders.count {
        case 0:
            return
        case 1:
            if destroyedBalance == "teamA" || destroyedBalance == "false" {
                teamB.append(defenders.first!)
            } else {
                teamA.append(defenders.first!)
            }
        case 2...:
            if destroyedBalance == "teamA" || destroyedBalance == "false" {
                teamA.append(contentsOf: defenders.split().left.count < defenders.split().right.count ? defenders.split().left : defenders.split().right)
                teamB.append(contentsOf: defenders.split().left.count < defenders.split().right.count ? defenders.split().right : defenders.split().left)
            } else {
                teamA.append(contentsOf: defenders.split().left.count < defenders.split().right.count ? defenders.split().right : defenders.split().left)
                teamB.append(contentsOf: defenders.split().left.count < defenders.split().right.count ? defenders.split().left : defenders.split().right)
            }
            
            if teamA.count != teamB.count {
                if moreAttackers == "teamA" {
                    teamB.append(teamA.last ?? "nope")
                    teamA.removeLast()
                } else {
                    teamA.append(teamB.last ?? "nope")
                    teamB.removeLast()
                }
            }
        default:
            return
        }
        
        for players in teamA{
            teamALabel.text?.append("\(players)\n")
        }
        
        for players in teamB{
            teamBLabel.text?.append("\(players)\n")
        }
        
    }
    
    func compareTeamStrength() {
        if teamA.count == teamB.count {
            destroyedBalance = "false"
        } else if teamA.count > teamB.count {
            destroyedBalance = "teamA"
        } else if teamA.count < teamB.count {
            destroyedBalance = "teamB"
        }
    }
    
    @IBAction func createTeamButtonPressed(_ sender: UIButton) {
        
        if teamWasFormed == true {
            attackers.removeAll()
            midfielders.removeAll()
            defenders.removeAll()
            
            teamNameStack.isHidden = true
            teamStack.isHidden = true
            
            teamALabel.text = ""
            teamBLabel.text = ""
            
            positionNameStack.isHidden = false
            positionStack.isHidden = false
            
            attackerLabel.text = ""
            midfielderLabel.text = ""
            defenderLabel.text = ""
            
            teamWasFormed = false
            
            createTeamButton.setTitle("Formo Skuadrën", for: .normal)
            
            return
        } else {
            positionNameStack.isHidden = true
            positionStack.isHidden = true
            
            teamNameStack.isHidden = false
            teamStack.isHidden = false
            
            formTeam()
            
            teamWasFormed = true
            
            createTeamButton.setTitle("Pastro", for: .normal)
        }
    }
    
    @IBAction func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if attackerTextfield.isFirstResponder {
            if textField.text!.isEmptyOrWhitespace(){
                textField.text?.removeAll()
                return false
            } else {
                attackers.append(textField.text ?? "nope")
                attackerLabel.text?.append("\(textField.text ?? "nope")\n")
                textField.text = nil
            }
        } else if midfielderTextfield.isFirstResponder {
            if textField.text!.isEmptyOrWhitespace(){
                textField.text?.removeAll()
                return false
            } else {
                midfielders.append(textField.text ?? "nope")
                midfielderLabel.text?.append("\(textField.text ?? "nope")\n")
                textField.text = nil
            }
        } else if defenderTextfield.isFirstResponder {
            if textField.text!.isEmptyOrWhitespace(){
                textField.text?.removeAll()
                return false
            } else {
                defenders.append(textField.text ?? "nope")
                defenderLabel.text?.append("\(textField.text ?? "nope")\n")
                textField.text = nil
            }
        }
        
        return false
    }
}

extension Array {
    func split() -> (left: [Element], right: [Element]) {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}

extension String {
    func isEmptyOrWhitespace() -> Bool {
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}
