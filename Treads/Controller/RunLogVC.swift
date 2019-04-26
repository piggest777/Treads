//
//  RunLogVC.swift
//  Treads
//
//  Created by Denis Rakitin on 2019-04-11.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit

class RunLogVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
 
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
            tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Run.getAllRuns()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RunLogCell") as? LogCell  else {return UITableViewCell()}
       
        guard  let run = Run.getAllRuns()?[indexPath.row] else {
            return LogCell()
        }
        cell.configure(run: run)
        
        return cell
        
    }


}

