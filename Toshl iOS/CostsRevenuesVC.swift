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
    var titleLabel: UILabel!

    let appDelegete = (UIApplication.sharedApplication().delegate as! AppDelegate)
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var tableDays:[(DateDay, Bool)] = []
    var tableCostDay:[[Cost]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
  
        navigationController?.navigationBar.barTintColor = UIColor(red: 243/255, green: 241/255, blue: 230/255, alpha: 1.0)
        
        setPlusButton()
        titleLabel = UILabel()
        titleLabel.hidden = true
        view.addSubview(titleLabel)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        tableDays = []
        getDaysFromCoreData()
        setButtonToBeginState()
     
        tableView.reloadData()
    }
    
    //Segue - navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addGreen" {
            let addCostslVC: AddCostsVC = segue.destinationViewController as! AddCostsVC
            addCostslVC.segueMode = "addGreen"
        } else if segue.identifier == "addRed" {
            let addCostslVC: AddCostsVC = segue.destinationViewController as! AddCostsVC
            addCostslVC.segueMode = "addRed"
        }else if segue.identifier == "addGrey" {
            let addCostslVC: AddCostsVC = segue.destinationViewController as! AddCostsVC
            addCostslVC.segueMode = "addGrey"
        }else if segue.identifier == "costDetail" {
            let costDetailVC: CostDetailVC = segue.destinationViewController as! CostDetailVC
            costDetailVC.costDetail = tableCostDay[tableView.indexPathForSelectedRow()!.section][tableView.indexPathForSelectedRow()!.row]
        }
    }
    
    //UITableViewDataSorce
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableDays.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableDays[section].1 {
            return tableDays[section].0.numberCost.integerValue
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableCostDay = []
        
        for day in tableDays {
            costDataForDay(day: day.0.date)
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! Cell
    
        cell.labelCategory.text = tableCostDay[indexPath.section][indexPath.row].category
        cell.labelCategory.textColor = UIColor.darkGrayColor()
        cell.labelCategory.sizeToFit()
        cell.labelCategory.frame.origin = CGPoint(x: 10, y: 12)
        
        cell.labelName.text = tableCostDay[indexPath.section][indexPath.row].name
        cell.labelName.textColor = UIColor.lightGrayColor()
        cell.labelName.sizeToFit()
        cell.labelName.frame.origin = CGPoint(x: (cell.labelCategory.frame.width + 20), y: 12)
        
        cell.labelCost.text = String(format: "€%.2f", (tableCostDay[indexPath.section][indexPath.row].cost).floatValue)
        cell.labelCost.textColor = UIColor.lightGrayColor()
        cell.labelCost.sizeToFit()
        cell.labelCost.frame.origin = CGPoint(x: view.bounds.width - cell.labelCost.bounds.width - 40, y: 12)
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
     
        return cell
    }
    
    //TableViewDataSorce - Header
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderCell
        var cost:Float = tableDays[section].0.costs.floatValue
        cell.dateLabel.text = Date.toString(date:tableDays[section].0.date)
        cell.monthlyCostsLabel.text = String(format: "€%.2f", cost)
        
        var buttonPressed = UIButton(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height))
        buttonPressed.addTarget(self, action: "toggleCellPushDown:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonPressed.tag = section
        cell.addSubview(buttonPressed)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func toggleCellPushDown(sender: UIButton) {
        if tableDays[sender.tag].1 {
            tableDays[sender.tag].1 = false
        }else {
            tableDays[sender.tag].1 = true
        }
        tableView.reloadData()
    }
    
    //UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("costDetail", sender: self)
    }
    
    //Helper Funct
    func getDaysFromCoreData(){
        let fetchRequest = NSFetchRequest(entityName: "DateDay")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let objectsDay = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [DateDay]
        
        for object in objectsDay {
            tableDays += [(object,true)]
        }
    }
    
    func costDataForDay(#day: NSDate) {
        let fetchRequest = NSFetchRequest(entityName: "Cost")
        
        let exprTitle = NSExpression(forKeyPath: "date")
        let exprValue = NSExpression(forConstantValue: day)
        let predicate = NSComparisonPredicate(leftExpression: exprTitle, rightExpression: exprValue, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.EqualToPredicateOperatorType, options: nil)
        
        fetchRequest.predicate = predicate
        var x = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Cost]
       // println(x.count)
        tableCostDay += [x]
        
    }
    
    func setPlusButton() {
        
        plusButton = UIButton(frame: CGRect(x: 10, y: self.view.bounds.height * 0.9, width: 60, height: 60))
        plusButton.setImage(UIImage(named: "redPlus"), forState: UIControlState.Normal)
        plusButton.tag = 0
       // plusButton.addTarget(self, action: "buttonTuchDown:", forControlEvents: UIControlEvents.TouchDown)
        let panOnPoints = UIPanGestureRecognizer(target: self, action: Selector("panOnPoints:"))
        plusButton.addGestureRecognizer(panOnPoints)
        view.addSubview(plusButton)

    }
    
    func panOnPoints(sender:UIPanGestureRecognizer) {
        var xX:CGFloat = sender.locationInView(view).x
        var yY:CGFloat = sender.locationInView(view).y
        
        var point = CGPoint(x: xX, y: yY)
        
        let redArea = (view.bounds.width / 1.0/3.0) - 70
        let greeArea = (view.bounds.width / 1.0/3.0) + 20
        let greyArea = (view.bounds.width / 1.0/3.0 * 2) + 50
        
        let yBound = self.view.bounds.height * 0.80
        let yBoundSledi = self.view.bounds.height * 0.70

        let centerPoint = CGPoint(x: view.bounds.width, y: view.bounds.height - 10)
        let radiusMax = CGFloat(view.bounds.width - 15)
        let radiusMin = CGFloat(view.bounds.width - 100)
        let radiusMiddel = CGFloat(view.bounds.width - 50)
        //println("radius: \(radius)")
        
        var dr = CGPoint(x: point.x - centerPoint.x, y: point.y - centerPoint.y)
        var pointRadius = abs(sqrt(pow((point.x - centerPoint.x), 2) + pow((point.y - centerPoint.y), 2)))
        //println("pointRadius: \(pointRadius)")
        //println("radiusMiddel: \(radiusMiddel)")
        var d = pointRadius - radiusMiddel
       
        var newPoint = CGPoint(x: point.x + d, y: point.y + d)

        if sender.state.hashValue == 2 {
           // println("ViewBound: \(CGPoint(x: view.bounds.width, y: view.bounds.height)))")
            titleLabel.hidden = false
        
            var newPoint = CGPoint(x: point.x + d, y: point.y + d)
            if pointRadius > radiusMin && pointRadius < radiusMax {
                plusButton.center = newPoint
                if newPoint.x < greeArea {
                    titleLabel.hidden = false
                    plusButton.setImage(UIImage(named: "redPlus"), forState: UIControlState.Normal)
                    setTitleLabel(color: "red", point: newPoint)
                }else if newPoint.x >= greeArea && point.x < greyArea {
                    titleLabel.hidden = false
                    plusButton.setImage(UIImage(named: "greenPlus"), forState: UIControlState.Normal)
                    setTitleLabel(color: "green", point: newPoint)
                } else if newPoint.x > greeArea {
                    titleLabel.hidden = false
                    plusButton.setImage(UIImage(named: "greyPlus"), forState: UIControlState.Normal)
                    setTitleLabel(color: "grey", point: newPoint)
                }else{
                    setButtonToBeginState()
                }
            } else {
                setButtonToBeginState()
            }

        } else if sender.state.hashValue == 3 {
            if pointRadius > radiusMin && pointRadius < radiusMax {
                setButtonToBeginState()
                if newPoint.x < greeArea {
                     performSegueWithIdentifier("addRed", sender: self)
                }else if newPoint.x >= greeArea && point.x < greyArea {
                    performSegueWithIdentifier("addGreen", sender: self)
                } else if newPoint.x > greeArea {
                    performSegueWithIdentifier("addGrey", sender: self)
                }
            }
        }
    }
    
    func setTitleLabel(#color:String, point: CGPoint){
        switch color {
        case "red":
            titleLabel.text = "Add expense"
            titleLabel.backgroundColor = UIColor(red: 187/255, green: 45/255, blue: 62/255, alpha: 1.0)
            var textLabellength = titleLabel.bounds.width / 2
            if point.x > textLabellength {
                textLabellength = textLabellength + (point.x - textLabellength)
            }
             titleLabel.center = CGPoint(x: textLabellength, y: point.y - 65)
        case "green":
            titleLabel.text = "Add income"
            titleLabel.backgroundColor = UIColor(red: 29/255, green: 156/255, blue: 61/255, alpha: 1.0)
            titleLabel.center = CGPoint(x: point.x, y: point.y - 65)
        case "grey":
            titleLabel.text = "Make transaction"
            titleLabel.backgroundColor = UIColor(red: 129/255, green: 127/255, blue: 121/255, alpha: 1.0)
            var textLabellength = titleLabel.bounds.width / 2
            if point.x > (view.bounds.width - textLabellength) {
                textLabellength = (view.bounds.width - textLabellength)
                titleLabel.center = CGPoint(x: textLabellength, y: point.y - 65)
            }else {
                titleLabel.center = CGPoint(x: point.x, y: point.y - 65)
            }
            
        default:
            println("Error")
        }
        
        titleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.bounds.size = CGSize(width: 150, height: 35)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.layer.cornerRadius = 10.0
        titleLabel.clipsToBounds = true
        
    }
    
    func setButtonToBeginState(){
        plusButton.frame.origin = CGPoint(x: 10, y: self.view.bounds.height - 70)
        plusButton.setImage(UIImage(named: "redPlus"), forState: UIControlState.Normal)
        titleLabel.hidden = true
    }
    
    
}
