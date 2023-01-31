//
//  FilterVC.swift
//  WooW
//
//  Created by Rahul Chopra on 09/05/21.
//

import UIKit

class FilterVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var closureDidTap: ((FilterEnum) -> ())?
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
    }
}


// MARK:- COLLECTION VIEW DATA SOURCE & DELEGATE METHODS
extension FilterVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableCell", for: indexPath) as! FilterTableCell
        cell.configure(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FilterTableCell {
            cell.backgroundColor = UIColor.rgb(red: 233, green: 63, blue: 51)
            cell.nameLbl.textColor = .white
            
            self.dismiss(animated: true) {
                if self.closureDidTap != nil {
                    self.closureDidTap!(indexPath.row == 0 ? .newest : indexPath.row == 1 ? .oldest : indexPath.row == 2 ? .aToZ : .random)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FilterTableCell {
            cell.backgroundColor = .white
            cell.nameLbl.textColor = .black
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}
