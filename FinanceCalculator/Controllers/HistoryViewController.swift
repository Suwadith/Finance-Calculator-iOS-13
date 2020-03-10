//
//  HistoryViewController.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/5/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController : UITableViewController {
    
    ///initialization of the history string array
    var history : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initHistoryInfo()
    }
    
    
    ///Identifies and loads appropriate history data from the view that is coming from
    func initHistoryInfo() {
        if let vcs = self.navigationController?.viewControllers {
            let previousVC = vcs[vcs.count - 2]
            
            if previousVC is MortgageViewController {
                loadDefaultsData("MortgageHistory")
            } else if previousVC is LoansViewController {
                loadDefaultsData("LoansHistory")
            } else if previousVC is CompoundSavingsViewController {
                loadDefaultsData("CompoundSavingsHistory")
            } else if previousVC is SavingsViewController {
                loadDefaultsData("SavingsHistory")
            }
        }
    }
    
    ///loads the appropriate UserDefaults storage object according to the view name (key provided to created the storage object)
    func loadDefaultsData(_ historyKey :String) {
        let defaults = UserDefaults.standard
        history = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    ///creates the appropriate number of rows in the table according the data that ws stroed before
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    ///populates the history table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableHistoryCell")!
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = history[indexPath.row]
        return cell
    }
    
}
