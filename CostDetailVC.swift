//
//  CostDetailVC.swift
//  Toshl iOS
//
//  Created by Marko Budal on 26/03/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import UIKit

class CostDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tableImage:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableImage += ["home", "internet", "bank", "numberTwo"]
        navigationController?.navigationBar.barTintColor = UIColor(red: 243/255, green: 241/255, blue: 230/255, alpha: 1.0)
        
        //tableImage += [UIImage(named: "")]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITableViewDataSorce
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }else {
            return 1
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.imageView?.image = UIImage(named: tableImage[indexPath.row])
        cell.textLabel?.text = "Home & Utilities"
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 100
        }
        else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            var costView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
            costView.backgroundColor = UIColor(red: 243/255, green: 241/255, blue: 230/255, alpha: 1.0)
            
            var costLabel: UILabel = UILabel()
            costLabel.text = "€42.50"
            costLabel.font = UIFont(name: "Superclarendon", size: 45)
            costLabel.textColor = UIColor(red: 79/255, green: 77/255, blue: 79/255, alpha: 1.0)
            costLabel.sizeToFit()
            costLabel.center = CGPoint(x: costView.frame.width * 1.0/2.0, y: costView.frame.height * 1.0/4.0 * 2)
            costView.addSubview(costLabel)
            
            return costView
        }else {
            var costView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
            costView.backgroundColor = UIColor(red: 243/255, green: 241/255, blue: 230/255, alpha: 1.0)
            
             return costView
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
         if section == 1 {
            return 200
         } else {
        return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            var costView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
            costView.backgroundColor = UIColor(red: 243/255, green: 241/255, blue: 230/255, alpha: 1.0)
            
            var deleteButton = UIButton(frame: CGRect(x: 10, y: 15, width: view.frame.width - 20, height: 30))
            deleteButton.setTitle("Delete", forState: UIControlState.Normal)
            costView.addSubview(deleteButton)
            
            return costView
        }
        return nil
    }
}
