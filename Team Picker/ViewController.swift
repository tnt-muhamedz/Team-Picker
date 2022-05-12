//
//  ViewController.swift
//  Team Picker
//
//  Created by Muhamed Zahiri on 11.05.22.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var attackerTextfield: UITextField!
    @IBOutlet weak var midfielderTextfield: UITextField!
    @IBOutlet weak var defenderTextfield: UITextField!
    
    @IBOutlet weak var teamALabel: UILabel!
    @IBOutlet weak var teamBLabel: UILabel!
    
    @IBOutlet weak var positionNameStack: UIStackView!
    
    @IBOutlet weak var teamNameStack: UIStackView!
    @IBOutlet weak var teamStack: UIStackView!
    
    @IBOutlet weak var attackerTableView: UITableView!
    @IBOutlet weak var midfielderTableView: UITableView!
    @IBOutlet weak var defenderTableView: UITableView!
    @IBOutlet weak var tableViewStack: UIStackView!
    
    @IBOutlet weak var createTeamButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    
    //MARK: - Properties
    var teamA: [String] = []
    var teamB: [String] = []
    
    var attackers: [String] = []
    var midfielders: [String] = []
    var defenders: [String] = []
    
    var destroyedBalance: String?
    var teamWasFormed: Bool = false
    var moreAttackers: String?
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        commonInit()
    }
    
    //MARK: - CommonInit
    func commonInit() {
        self.setupHideKeyboardOnTap()
        
        attackerTextfield.delegate = self
        midfielderTextfield.delegate = self
        defenderTextfield.delegate = self
        
        attackerTableView.delegate = self
        attackerTableView.dataSource = self
        attackerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "attackerCell")
        
        midfielderTableView.delegate = self
        midfielderTableView.dataSource = self
        midfielderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "midfielderCell")
        
        defenderTableView.delegate = self
        defenderTableView.dataSource = self
        defenderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "defenderCell")
    }
    
    
    //MARK: - FormTeam Function
    func formTeam() {
        teamA.removeAll()
        teamB.removeAll()
        
        attackers.shuffle()
        midfielders.shuffle()
        defenders.shuffle()
        
        switch attackers.count {
        case 0:
            print("No attacker")
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
            print("No midfielder")
            
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
            print("No defender")
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
    
    //MARK: - IBAction
    @IBAction func createTeamButtonPressed(_ sender: UIButton) {
        
        if teamWasFormed == true {
            
            teamALabel.text = ""
            teamBLabel.text = ""
            
            formTeam()
            
            teamWasFormed = true
            
            return
        } else {
            positionNameStack.isHidden = true
            tableViewStack.isHidden = true
            
            teamNameStack.isHidden = false
            teamStack.isHidden = false
            
            formTeam()
            
            teamWasFormed = true
            
            createTeamButton.setTitle("Retry", for: .normal)
            clearButton.isHidden = false
        }
        
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        attackers.removeAll()
        midfielders.removeAll()
        defenders.removeAll()
        
        attackerTableView.reloadData()
        midfielderTableView.reloadData()
        defenderTableView.reloadData()
        
        teamNameStack.isHidden = true
        teamStack.isHidden = true
        
        teamALabel.text = ""
        teamBLabel.text = ""
        
        positionNameStack.isHidden = false
        tableViewStack.isHidden = false
        
        teamWasFormed = false
        
        createTeamButton.setTitle("Formo Skuadrën", for: .normal)
        clearButton.isHidden = true
    }
    
    
}

//MARK: - Textfield
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if attackerTextfield.isFirstResponder {
            if textField.text!.isEmptyOrWhitespace(){
                textField.text?.removeAll()
                return false
            } else {
                attackers.append("\(textField.text ?? "nope") (sulm)")
                attackerTableView.reloadData()
                textField.text = nil
            }
        } else if midfielderTextfield.isFirstResponder {
            if textField.text!.isEmptyOrWhitespace(){
                textField.text?.removeAll()
                return false
            } else {
                midfielders.append("\(textField.text ?? "nope") (mes)")
                midfielderTableView.reloadData()
                textField.text = nil
            }
        } else if defenderTextfield.isFirstResponder {
            if textField.text!.isEmptyOrWhitespace(){
                textField.text?.removeAll()
                return false
            } else {
                defenders.append("\(textField.text ?? "nope") (mbroj)")
                defenderTableView.reloadData()
                textField.text = nil
            }
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if attackerTextfield.isFirstResponder {
            midfielderTextfield.text = nil
            defenderTextfield.text = nil
        } else if midfielderTextfield.isFirstResponder {
            attackerTextfield.text = nil
            defenderTextfield.text = nil
        } else if defenderTextfield.isFirstResponder {
            attackerTextfield.text = nil
            midfielderTextfield.text = nil
        }
    }
}


//MARK: - TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == attackerTableView) {
            return attackers.count
        } else if (tableView == midfielderTableView) {
            return midfielders.count
        } else if (tableView == defenderTableView) {
            return defenders.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt called")
        if (tableView == attackerTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "attackerCell", for: indexPath)
            
//          var content = cell.defaultContentConfiguration()
//          content.text = attackers[indexPath.row]
//          cell.contentConfiguration = content
            
            cell.textLabel?.text = attackers[indexPath.row].replacingOccurrences(of: " (sulm)", with: "")
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = .clear
            
            return cell
            
        } else if (tableView == midfielderTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "midfielderCell", for: indexPath)
            
            cell.textLabel?.text = midfielders[indexPath.row].replacingOccurrences(of: " (mes)", with: "")
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = .clear
            
            return cell
            
            
        } else if (tableView == defenderTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "defenderCell", for: indexPath)
            
            cell.textLabel?.text = defenders[indexPath.row].replacingOccurrences(of: " (mbroj)", with: "")
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = .clear
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == attackerTableView) {
            attackers.remove(at: indexPath.row)
            tableView.reloadData()
        } else if (tableView == midfielderTableView) {
            midfielders.remove(at: indexPath.row)
            tableView.reloadData()
        } else if (tableView == defenderTableView) {
            defenders.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
}



//MARK: - Extensions
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

open class SelfSizedTableView: UITableView {
    override open var contentSize: CGSize {
        didSet {
            if oldValue != contentSize {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height)
    }
}


extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
