//
//  CostDetailVC.swift
//  Toshl iOS
//
//  Created by Marko Budal on 26/03/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import UIKit
import CoreData

class CostDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tableImage:[String] = []
    var costDetail:Cost!
    var tableCostDetail:[String] = []
    
    let appDelegete = (UIApplication.sharedApplication().delegate as AppDelegate)
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableImage += ["home", "internet", "bank", "numberTwo"]
        tableCostDetail += [costDetail.category, costDetail.name, costDetail.toAccount, Date.toString(date: costDetail.date), "\(costDetail.repeat)"]
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 243/255, green: 241/255, blue: 230/255, alpha: 1.0)
        
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
        
        if indexPath.section == 1 {
            cell.imageView?.image = UIImage(named: "iconRepeat")
            cell.textLabel?.text = "Repeats each month on \(tableCostDetail[4])"
        }else {
            cell.imageView?.image = UIImage(named: tableImage[indexPath.row])
            cell.textLabel?.text = tableCostDetail[indexPath.row]
        }
        
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
            costLabel.text = String(format: "€%.2f", (costDetail.cost).floatValue)
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
            return 220
         } else {
        return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            var costView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.bounds.height - tableView.bounds.height))
            costView.backgroundColor = UIColor(red: 243/255, green: 241/255, blue: 230/255, alpha: 1.0)
            
            var deleteButton = UIButton(frame: CGRect(x: 10, y: 15, width: view.frame.width - 20, height: 30))
            deleteButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            deleteButton.setTitle("Delete", forState: UIControlState.Normal)
            deleteButton.addTarget(self, action: "removeDataFromCoreData:", forControlEvents: UIControlEvents.TouchUpInside)
            costView.addSubview(deleteButton)
            
            return costView
        }
        return nil
    }
    
    func removeDataFromCoreData(button: UIButton){
        var fetchRequest = NSFetchRequest(entityName: "DateDay")
        
        let exprTitle = NSExpression(forKeyPath: "date")
        let exprValue = NSExpression(forConstantValue: costDetail.date)
        let predicate = NSComparisonPredicate(leftExpression: exprTitle, rightExpression: exprValue, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.EqualToPredicateOperatorType, options: nil)
        
        fetchRequest.predicate = predicate
        var x = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as [DateDay]
        
        if x[0].numberCost.intValue > 1 {
            x[0].numberCost = x[0].numberCost.integerValue - 1
            x[0].costs = x[0].costs.floatValue - costDetail.cost.floatValue
        }else{
            managedObjectContext!.deleteObject(x[0])
        }
        
        managedObjectContext!.deleteObject(costDetail)
        appDelegete.saveContext()
        navigationController?.popViewControllerAnimated(true)

    }
}
