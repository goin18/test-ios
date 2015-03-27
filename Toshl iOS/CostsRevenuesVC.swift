//
//  CostsRevenuesVC.swift
//  Toshl iOS
//
//  Created by Marko Budal on 25/03/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import UIKit
import CoreData

class CostsRevenuesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var myPathView:PathView!

    var plusButton: UIButton!

    var tableOfDays:[DanEntiteta]!
    var tableDayDisplay:[DayStruct] = []
    var tableOfCousts:[Cost]!
    var tableCostPerSection:[CostStruct] = []
    
    let appDelegete = (UIApplication.sharedApplication().delegate as AppDelegate)
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    //let entityDescription = NSEntityDescription.entityForName("KpBus", inManagedObjectContext: (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
  
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 243/255, green: 241/255, blue: 230/255, alpha: 1.0)
        
        var requestDay = NSFetchRequest(entityName: "DanEntiteta")
        var dayFromRequest = managedObjectContext?.executeFetchRequest(requestDay, error: nil) as [DanEntiteta]
        
        tableOfDays = dayFromRequest
        
        for day in tableOfDays {
            var dayStruct:DayStruct = DayStruct(toggle: true, date:day.dan, cost:day.skupniStroski)
            tableDayDisplay += [dayStruct]
        }
        
        var requestCosts = NSFetchRequest(entityName: "Cost")
        var dayFromCosts = managedObjectContext?.executeFetchRequest(requestCosts, error: nil) as [Cost]
        
        tableOfCousts = dayFromCosts
        
        setPlus()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        var requestDay = NSFetchRequest(entityName: "DanEntiteta")
        var dayFromRequest = managedObjectContext?.executeFetchRequest(requestDay, error: nil) as [DanEntiteta]
        
        tableOfDays = dayFromRequest
        
        for day in tableOfDays {
            var dayStruct:DayStruct = DayStruct(toggle: true, date:day.dan, cost:day.skupniStroski)
            tableDayDisplay += [dayStruct]
        }
        
        var requestCosts = NSFetchRequest(entityName: "Cost")
        var dayFromCosts = managedObjectContext?.executeFetchRequest(requestCosts, error: nil) as [Cost]
        
        tableOfCousts = dayFromCosts
        println("ViewDid")
        tableView.reloadData()
    }
    
    //Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addGreen" {
            let addCostslVC: AddCostsVC = segue.destinationViewController as AddCostsVC
            addCostslVC.segueMode = "addGreen"
        } else if segue.identifier == "addRed" {
            let addCostslVC: AddCostsVC = segue.destinationViewController as AddCostsVC
            addCostslVC.segueMode = "addRed"
        }else if segue.identifier == "addGrey" {
            let addCostslVC: AddCostsVC = segue.destinationViewController as AddCostsVC
            addCostslVC.segueMode = "addGrey"
        }else if segue.identifier == "costDetail" {
            println("OK")
        }
    }
    
    //UITableViewDataSorce
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return tableOfDays.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableCostPerSection = []
            var number = 0
            for dayC in tableOfCousts {
                if Date.getDateDay(date: dayC.date) == Date.getDateDay(date: tableOfDays[section].dan) {
                    var cost:CostStruct = CostStruct(name: dayC.name, category: dayC.category, repeat: "\(dayC.repeat)", cost: dayC.cost)
                    tableCostPerSection.append(cost)
                    number++
                }
            }
            return number
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as Cell
        cell.celllabel.text = tableCostPerSection[indexPath.row].name + "      € " + tableCostPerSection[indexPath.row].cost
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func toggleCell(sender: UIButton) {
        if tableDayDisplay[sender.tag].toggle == true {
            tableDayDisplay[sender.tag].toggle == false
        }else{
        tableDayDisplay[sender.tag].toggle == true
        }
        /*
        if dateTable[sender.tag].2 == true {
            dateTable[sender.tag].2 = false
        }else{
            dateTable[sender.tag].2 = true
        }
*/
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as HeaderCell
        cell.dateLabel.text = Date.toString(date: tableOfDays[section].dan)
        cell.monthlyCostsLabel.text = "€\(tableOfDays[section].skupniStroski)"
        var buttonPressed = UIButton(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height))
        buttonPressed.tag = section
        cell.addSubview(buttonPressed)
        buttonPressed.addTarget(self, action: "toggleCell:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    //UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Row: \(indexPath.row)")
        performSegueWithIdentifier("costDetail", sender: self)
    }
    
    
    
    //Helper Funct
    func setPlus() {
        
        plusButton = UIButton(frame: CGRect(x: 10, y: self.view.bounds.height * 0.9, width: 60, height: 60))
        plusButton.setImage(UIImage(named: "redPlus"), forState: UIControlState.Normal)
        plusButton.tag = 0
       // plusButton.addTarget(self, action: "buttonTuchDown:", forControlEvents: UIControlEvents.TouchDown)
        let panOnPoints = UIPanGestureRecognizer(target: self, action: Selector("panOnPoints:"))
        plusButton.addGestureRecognizer(panOnPoints)
        view.addSubview(plusButton)
    }
    
    func panOnPoints(sender:UIPanGestureRecognizer)
    {
        var xX:CGFloat = sender.locationInView(view).x
        var yY:CGFloat = sender.locationInView(view).y
        
        var point = CGPoint(x: xX, y: yY)
        
        let redArea = view.bounds.width / 1.0/3.0
        let greeArea = view.bounds.width / 1.0/3.0
        let greyArea = view.bounds.width / 1.0/3.0 * 2
        
        let yBound = self.view.bounds.height * 0.80
        let yBoundSledi = self.view.bounds.height * 0.70


        if sender.state.hashValue == 2 {
            
            if point.y > yBound {
                plusButton.center = point
                if point.x < greeArea {
                    plusButton.setImage(UIImage(named: "redPlus"), forState: UIControlState.Normal)
                }else if point.x >= greeArea && point.x < greyArea {
                    plusButton.setImage(UIImage(named: "greenPlus"), forState: UIControlState.Normal)
                    
                } else if point.x > greeArea {
                    plusButton.setImage(UIImage(named: "greyPlus"), forState: UIControlState.Normal)
                }
            }else {
                plusButton.frame.origin = CGPoint(x: 10, y: self.view.bounds.height - 70)
                plusButton.setImage(UIImage(named: "redPlus"), forState: UIControlState.Normal)
              //  plusButton.center = point
            }

        }else if sender.state.hashValue == 3 {
            if point.y > yBound {
              if point.x < greeArea {
                performSegueWithIdentifier("addRed", sender: self)
              }else if point.x >= greeArea && point.x < greyArea {
                performSegueWithIdentifier("addGreen", sender: self)
              } else if point.x > greeArea {
                performSegueWithIdentifier("addGrey", sender: self)
            }
                plusButton.frame.origin = CGPoint(x: 10, y: self.view.bounds.height - 70)
                plusButton.setImage(UIImage(named: "redPlus"), forState: UIControlState.Normal)
            } else {
                plusButton.frame.origin = CGPoint(x: 10, y: self.view.bounds.height - 70)
                plusButton.setImage(UIImage(named: "redPlus"), forState: UIControlState.Normal)
            }
        }
    }
    
    
}
