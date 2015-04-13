//
//  AddCostsVC.swift
//  Toshl iOS
//
//  Created by Marko Budal on 25/03/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import UIKit
import CoreData

class AddCostsVC: UIViewController {

    var segueMode:String!
    var colorTable:[Dictionary<String,UIColor>] = []
    
    @IBOutlet weak var enterArrow: UIBarButtonItem!
    
    var firstContainder: UIView!
    var secondContainder: UIView!
    var secondContainerGrey: UIView!
    
    var euroLabel: UILabel!
    var numberLabel: UILabel!
    
    var oneButton: UIButton!
    var twoButton: UIButton!
    var threeButton: UIButton!
    var fourButton: UIButton!
    var fiveButton: UIButton!
    var sixButton: UIButton!
    var sevenButton: UIButton!
    var eightButton: UIButton!
    var nineButton: UIButton!
    var zeroButton: UIButton!
   
    var comaButton: UIButton!
    
    var removeButton: UIButton!
    var sumButton: UIButton!
    var procentButton: UIButton!
    var enterButton: UIButton!
    
    var fromAccount: UIView!
    var toAccount: UIView!
    var date:UIView!
    
    let kHalf:CGFloat = 1.0/2.0
    let kFourth:CGFloat = 1.0/4.0
    
    let appDelegete = (UIApplication.sharedApplication().delegate as! AppDelegate)
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var tableExpensiveCategory = ["Home & Utilities", "Food & Drinks", "Charity", "Transport", "FInancial Instruments"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 243/255, green: 241/255, blue: 230/255, alpha: 1.0)
        
        getSegurMode()
        setupFirstContainer()
        
        if segueMode == "addGrey" {
            setupSecondContainerGray()
        }else {
            setupSecondContainder()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeButtonItem(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveToCoreData(sender: UIBarButtonItem) {
        println("Save To CoreData")
        saveToCoreDataButtons()
    }
    
    func saveToCoreDataButtons(){
        var fetchRequest = NSFetchRequest(entityName: "DateDay")

        var date = NSDate()
        var day = Date.getDateDay(date: date)
        var mounth = Date.getDateMounth(date: date)
        var year = 2015
        
        let exprTitle = NSExpression(forKeyPath: "date")
        let exprValue = NSExpression(forConstantValue: Date.from(year: year, month: mounth, day: day))
        let predicate = NSComparisonPredicate(leftExpression: exprTitle, rightExpression: exprValue, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.EqualToPredicateOperatorType, options: nil)
        
        fetchRequest.predicate = predicate
        var dateExist = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [DateDay]
        
        if dateExist.count != 0 {
            var cost1 = NSEntityDescription.insertNewObjectForEntityForName("Cost", inManagedObjectContext: self.managedObjectContext!) as! Cost
            cost1 = preperCostForSaveing(cost1, year: year, mounth: mounth, day: day)
            
            let costNumber = cost1.cost.floatValue
            dateExist[0].costs = costNumber + (dateExist[0].costs).floatValue
            dateExist[0].numberCost = 1 +  dateExist[0].numberCost.integerValue
            
            appDelegete.saveContext()
            
        }else {
            var cost1 = NSEntityDescription.insertNewObjectForEntityForName("Cost", inManagedObjectContext: self.managedObjectContext!) as! Cost
            cost1 = preperCostForSaveing(cost1, year: year, mounth: mounth, day: day)
            
            var day1 = NSEntityDescription.insertNewObjectForEntityForName("DateDay", inManagedObjectContext: self.managedObjectContext!) as! DateDay
            day1.date = Date.from(year: year, month: mounth, day: day)
            day1.numberCost = 1
            day1.costs = cost1.cost.floatValue
            
            var dayRelation1 = day1.mutableSetValueForKey("costsDay")
            dayRelation1.addObject(cost1)
            
            appDelegete.saveContext()
        }
     
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func preperCostForSaveing(cost:Cost, year: Int, mounth: Int, day: Int) -> Cost {
        cost.name = "internet"
        cost.category = tableExpensiveCategory[Int(arc4random_uniform(UInt32(tableExpensiveCategory.count)))]
        cost.toAccount = "Bank"
        cost.date = Date.from(year: year, month: mounth, day: day)
        cost.repeat = Int(arc4random_uniform(UInt32(20)))
        cost.cost = (NSNumberFormatter().numberFromString(numberLabel.text!)?.floatValue)!
        
        return cost
    }
    
    
    func addNumber(button: UIButton){
        let number = button.currentTitle!
       // println("Number pressed: \(number)")
        if numberLabel.text == "0" {
            numberLabel.text = number
        }else {
            numberLabel.text = numberLabel.text! + number
        }
    }

    func addOperator(button: UIButton){
        let oper = button.currentTitle!
        println(oper)
        switch oper {
            case ",":
                println(",")
            case ">":
                saveToCoreDataButtons()
            case "←":
                if numberLabel.text != "0" {
                    println("\(count(numberLabel.text!))")
                    if count(numberLabel.text!) > 1 {
                        var s = numberLabel.text
                        numberLabel.text = dropLast(s!)
                    }else {
                        numberLabel.text = "0"
                    }
            }
        default:
            println("Error operator")
        }
    }
    
    //alert for the buttons that dont have any action
    func notImplemented(button: UIButton) {
        var alertController = UIAlertController(title: "Button not implemented", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //color of the buttons number
    func getSegurMode(){
        if segueMode == "addRed" {
            colorTable = [
                ["one" : UIColor(red: 254/255, green: 184/255, blue: 152/255, alpha: 1.0)],
                ["two" : UIColor(red: 237/255, green: 135/255, blue: 116/255, alpha: 1.0)],
                ["three" : UIColor(red: 212/255, green: 96/255, blue: 95/255, alpha: 1.0)],
                ["four" : UIColor(red: 237/255, green: 135/255, blue: 116/255, alpha: 1.0)],
                ["five" : UIColor(red: 212/255, green: 96/255, blue: 95/255, alpha: 1.0)],
                ["six" : UIColor(red: 186/255, green: 72/255, blue: 89/255, alpha: 1.0)],
                ["seven" : UIColor(red: 212/255, green: 96/255, blue: 95/255, alpha: 1.0)],
                ["eight" : UIColor(red: 186/255, green: 72/255, blue: 89/255, alpha: 1.0)],
                ["nine" : UIColor(red: 160/255, green: 52/255, blue: 84/255, alpha: 1.0)],
                ["zero" : UIColor(red: 160/255, green: 52/255, blue: 84/255, alpha: 1.0)],
                ["coma" : UIColor(red: 134/255, green: 37/255, blue: 82/255, alpha: 1.0)]
            ]
            enterArrow.tintColor = UIColor(red: 134/255, green: 37/255, blue: 82/255, alpha: 1.0)
            
        }else if segueMode == "addGreen" {
            colorTable = [
                ["one" : UIColor(red: 115/255, green: 211/255, blue: 107/255, alpha: 1.0)],
                ["two" : UIColor(red: 80/255, green: 185/255, blue: 94/255, alpha: 1.0)],
                ["three" : UIColor(red: 54/255, green: 161/255, blue: 89/255, alpha: 1.0)],
                ["four" : UIColor(red: 80/255, green: 185/255, blue: 94/255, alpha: 1.0)],
                ["five" : UIColor(red: 54/255, green: 161/255, blue: 89/255, alpha: 1.0)],
                ["six" : UIColor(red: 34/255, green: 137/255, blue: 88/255, alpha: 1.0)],
                ["seven" : UIColor(red: 54/255, green: 161/255, blue: 89/255, alpha: 1.0)],
                ["eight" : UIColor(red: 33/255, green: 138/255, blue: 88/255, alpha: 1.0)],
                ["nine" : UIColor(red: 20/255, green: 116/255, blue: 87/255, alpha: 1.0)],
                ["zero" : UIColor(red: 20/255, green: 116/255, blue: 87/255, alpha: 1.0)],
                ["coma" : UIColor(red: 9/255, green: 91/255, blue: 84/255, alpha: 1.0)]
            ]
            
            enterArrow.tintColor = UIColor(red: 9/255, green: 91/255, blue: 84/255, alpha: 1.0)
        }
    }
    
    //Priprava kako bo kaj zgledalo
    func setupFirstContainer(){
        let x = CGRect(x: 0, y:0 , width: self.view.bounds.width, height: self.view.bounds.height * kHalf)
        self.firstContainder = UIView(frame: x)
        firstContainder.backgroundColor = UIColor(red: 243/255, green: 241/255, blue: 230/255, alpha: 1.0)
        view.addSubview(firstContainder)
        
        euroLabel = UILabel(frame: CGRect(x: 0, y: firstContainder.frame.height * kFourth * 3, width: firstContainder.frame.width * kFourth, height: firstContainder.frame.height * kFourth))
        euroLabel.text = "€"
        euroLabel.textColor = UIColor(red: 79/255, green: 76/255, blue: 79/255, alpha: 1.0)
        euroLabel.font = UIFont(name: "Superclarendon-Bold", size: 30)
        euroLabel.textAlignment = NSTextAlignment.Center
        
        numberLabel = UILabel(frame: CGRect(x: firstContainder.frame.width * kFourth, y: firstContainder.frame.height * kFourth * 3, width: firstContainder.frame.width * kFourth * 3 - 15, height: firstContainder.frame.height * kFourth))
        numberLabel.text = "0"
        numberLabel.textColor = UIColor(red: 79/255, green: 76/255, blue: 79/255, alpha: 1.0)
        numberLabel.font = UIFont(name: "Superclarendon-Bold", size: 30)
        numberLabel.textAlignment = NSTextAlignment.Right
        
        firstContainder.addSubview(euroLabel)
        firstContainder.addSubview(numberLabel)
    }
    
    func setupSecondContainder(){
        //println("Y:\(self.view.bounds.height)")
        let x = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.height * kHalf, width: self.view.bounds.width, height: self.view.bounds.height * kHalf)
        self.secondContainder = UIView(frame: x)
        view.addSubview(secondContainder)
        
        oneButton = UIButton(frame: CGRect(x: 0, y: 0, width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        oneButton.setTitle("1", forState: UIControlState.Normal)
        oneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        oneButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        oneButton.backgroundColor = colorTable[0]["one"]
        oneButton.addTarget(self, action: "addNumber:", forControlEvents: UIControlEvents.TouchUpInside)

        twoButton = UIButton(frame: CGRect(x: secondContainder.frame.width * kFourth, y: 0 , width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        twoButton.setTitle("2", forState: UIControlState.Normal)
        twoButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        twoButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        twoButton.backgroundColor = colorTable[1]["two"]
        twoButton.addTarget(self, action: "addNumber:", forControlEvents: UIControlEvents.TouchUpInside)
        
        threeButton = UIButton(frame: CGRect(x: secondContainder.frame.width * kFourth * 2, y: 0 , width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        threeButton.setTitle("3", forState: UIControlState.Normal)
        threeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        threeButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        threeButton.backgroundColor = colorTable[2]["three"]
        threeButton.addTarget(self, action: "addNumber:", forControlEvents: UIControlEvents.TouchUpInside)
        
        removeButton = UIButton(frame: CGRect(x: secondContainder.frame.width * kFourth * 3, y: 0 , width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        removeButton.setTitle("←", forState: UIControlState.Normal)
        removeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        removeButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        removeButton.backgroundColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
        removeButton.addTarget(self, action: "addOperator:", forControlEvents: UIControlEvents.TouchUpInside)
        
        secondContainder.addSubview(oneButton)
        secondContainder.addSubview(twoButton)
        secondContainder.addSubview(threeButton)
        secondContainder.addSubview(removeButton)
        
        
        fourButton = UIButton(frame: CGRect(x: 0, y: secondContainder.frame.height * kFourth, width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        fourButton.setTitle("4", forState: UIControlState.Normal)
        fourButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        fourButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        fourButton.backgroundColor = colorTable[3]["four"]
        fourButton.addTarget(self, action: "addNumber:", forControlEvents: UIControlEvents.TouchUpInside)
        
        fiveButton = UIButton(frame: CGRect(x: secondContainder.frame.width * kFourth, y: secondContainder.frame.height * kFourth , width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        fiveButton.setTitle("5", forState: UIControlState.Normal)
        fiveButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        fiveButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        fiveButton.backgroundColor = colorTable[4]["five"]
        fiveButton.addTarget(self, action: "addNumber:", forControlEvents: UIControlEvents.TouchUpInside)
        
        sixButton = UIButton(frame: CGRect(x: secondContainder.frame.width * kFourth * 2, y: secondContainder.frame.height * kFourth , width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        sixButton.setTitle("6", forState: UIControlState.Normal)
        sixButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        sixButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        sixButton.backgroundColor = colorTable[5]["six"]
        sixButton.addTarget(self, action: "addNumber:", forControlEvents: UIControlEvents.TouchUpInside)
        
        sumButton = UIButton(frame: CGRect(x: secondContainder.frame.width * kFourth * 3, y: secondContainder.frame.height * kFourth , width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        sumButton.setTitle("∑", forState: UIControlState.Normal)
        sumButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        sumButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        sumButton.backgroundColor = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1.0)
        sumButton.addTarget(self, action: "notImplemented:", forControlEvents: UIControlEvents.TouchUpInside)
        
        secondContainder.addSubview(fourButton)
        secondContainder.addSubview(fiveButton)
        secondContainder.addSubview(sixButton)
        secondContainder.addSubview(sumButton)
        
        
        sevenButton = UIButton(frame: CGRect(x: 0, y: secondContainder.frame.height * kFourth * 2, width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        sevenButton.setTitle("7", forState: UIControlState.Normal)
        sevenButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        sevenButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        sevenButton.backgroundColor = colorTable[6]["seven"]
        sevenButton.addTarget(self, action: "addNumber:", forControlEvents: UIControlEvents.TouchUpInside)
        
        eightButton = UIButton(frame: CGRect(x: secondContainder.frame.width * kFourth, y: secondContainder.frame.height * kFourth * 2, width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        eightButton.setTitle("8", forState: UIControlState.Normal)
        eightButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        eightButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        eightButton.backgroundColor = colorTable[7]["eight"]
        eightButton.addTarget(self, action: "addNumber:", forControlEvents: UIControlEvents.TouchUpInside)
        
        nineButton = UIButton(frame: CGRect(x: secondContainder.frame.width * kFourth * 2, y: secondContainder.frame.height * kFourth * 2, width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        nineButton.setTitle("9", forState: UIControlState.Normal)
        nineButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        nineButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        nineButton.backgroundColor = colorTable[8]["nine"]
        nineButton.addTarget(self, action: "addNumber:", forControlEvents: UIControlEvents.TouchUpInside)
        
        procentButton = UIButton(frame: CGRect(x: secondContainder.frame.width * kFourth * 3, y: secondContainder.frame.height * kFourth * 2, width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        procentButton.setTitle("%", forState: UIControlState.Normal)
        procentButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        procentButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        procentButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        procentButton.addTarget(self, action: "notImplemented:", forControlEvents: UIControlEvents.TouchUpInside)
        
        secondContainder.addSubview(sevenButton)
        secondContainder.addSubview(eightButton)
        secondContainder.addSubview(nineButton)
        secondContainder.addSubview(procentButton)
        
        zeroButton = UIButton(frame: CGRect(x: 0, y: secondContainder.frame.height * kFourth * 3, width: secondContainder.frame.width * kFourth * 2, height: secondContainder.frame.height * kFourth))
        zeroButton.setTitle("0", forState: UIControlState.Normal)
        zeroButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        zeroButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        zeroButton.backgroundColor = colorTable[9]["zero"]
        zeroButton.addTarget(self, action: "addNumber:", forControlEvents: UIControlEvents.TouchUpInside)
        
        comaButton = UIButton(frame: CGRect(x: secondContainder.frame.width * kFourth * 2, y: secondContainder.frame.height * kFourth * 3, width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        comaButton.setTitle(",", forState: UIControlState.Normal)
        comaButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        comaButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        comaButton.backgroundColor = colorTable[10]["coma"]
        
        enterButton = UIButton(frame: CGRect(x: secondContainder.frame.width * kFourth * 3, y: secondContainder.frame.height * kFourth * 3, width: secondContainder.frame.width * kFourth, height: secondContainder.frame.height * kFourth))
        enterButton.setTitle(">", forState: UIControlState.Normal)
        enterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        enterButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 20)
        enterButton.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        enterButton.addTarget(self, action: "addOperator:", forControlEvents: UIControlEvents.TouchUpInside)
        
        secondContainder.addSubview(zeroButton)
        secondContainder.addSubview(comaButton)
        secondContainder.addSubview(enterButton)
    }
    
    func setupSecondContainerGray(){

        let x = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.height * kHalf, width: self.view.bounds.width, height: self.view.bounds.height * kHalf)
        self.secondContainder = UIView(frame: x)
        secondContainder.backgroundColor = UIColor(red: 243/255, green: 241/255, blue: 230/255, alpha: 1.0)
        view.addSubview(secondContainder)
        
        fromAccount = UIView(frame: CGRect(x: 0, y: 0, width: secondContainder.bounds.width, height: secondContainder.bounds.height * 1.0/5.0))
        fromAccount.backgroundColor = UIColor(red: 192/255, green: 191/255, blue: 183/255, alpha: 1.0)
        var imageView = UIImageView(frame: CGRect(x: 15, y: fromAccount.bounds.height / 1.0/3.0, width: fromAccount.bounds.height / 1.0/3.0, height: fromAccount.bounds.height / 1.0/3.0))
        imageView.image =  UIImage(named: "houseOne")
        fromAccount.addSubview(imageView)
        
        var nameLabel = UILabel(frame: CGRect(x: 50, y: fromAccount.bounds.height / 1.0/3.0, width: 200, height: fromAccount.bounds.height / 1.0/3.0))
        nameLabel.text = "From account"
        nameLabel.font = UIFont(name: "Superclarendon-Bold", size: 20)
        nameLabel.textColor = UIColor.whiteColor()
        fromAccount.addSubview(nameLabel)
        
        var nameLabelTwo = UILabel(frame: CGRect(x: fromAccount.bounds.width - 60 , y: fromAccount.bounds.height / 1.0/3.0, width: 50, height: fromAccount.bounds.height / 1.0/3.0))
        nameLabelTwo.text = "Cash"
        nameLabel.font = UIFont(name: "Superclarendon", size: 20)
        nameLabelTwo.textColor = UIColor.whiteColor()
        fromAccount.addSubview(nameLabelTwo)

        secondContainder.addSubview(fromAccount)
        
        toAccount = UIView(frame: CGRect(x: 0, y: secondContainder.bounds.height * 1.0/5.0, width: secondContainder.bounds.width, height: secondContainder.bounds.height * 1.0/5.0))
        toAccount.backgroundColor = UIColor(red: 180/255, green: 179/255, blue: 171/255, alpha: 1.0)
        imageView = UIImageView(frame: CGRect(x: 15, y: toAccount.bounds.height / 1.0/3.0, width: toAccount.bounds.height / 1.0/3.0, height: toAccount.bounds.height / 1.0/3.0))
        imageView.image =  UIImage(named: "houseTwo")
        toAccount.addSubview(imageView)
        
        nameLabel = UILabel(frame: CGRect(x: 50, y: toAccount.bounds.height / 1.0/3.0, width: 200, height: toAccount.bounds.height / 1.0/3.0))
        nameLabel.text = "To account"
        nameLabel.font = UIFont(name: "Superclarendon-Bold", size: 20)
        nameLabel.textColor = UIColor.whiteColor()
        toAccount.addSubview(nameLabel)
        
        nameLabelTwo = UILabel(frame: CGRect(x: toAccount.bounds.width - 60 , y: toAccount.bounds.height / 1.0/3.0, width: 50, height: toAccount.bounds.height / 1.0/3.0))
        nameLabelTwo.text = "Bank"
        nameLabel.font = UIFont(name: "Superclarendon", size: 20)
        nameLabelTwo.textColor = UIColor.whiteColor()
        toAccount.addSubview(nameLabelTwo)
        
        secondContainder.addSubview(toAccount)
        
        date = UIView(frame: CGRect(x: 0, y: secondContainder.bounds.height * 1.0/5.0 * 2, width: secondContainder.bounds.width, height: secondContainder.bounds.height * 1.0/5.0))
        date.backgroundColor = UIColor(red: 154/255, green: 153/255, blue: 146/255, alpha: 1.0)
        imageView = UIImageView(frame: CGRect(x: 15, y: date.bounds.height / 1.0/3.0, width: date.bounds.height / 1.0/3.0, height: date.bounds.height / 1.0/3.0))
        imageView.image =  UIImage(named: "number")
        date.addSubview(imageView)
        
        nameLabel = UILabel(frame: CGRect(x: 50, y: date.bounds.height / 1.0/3.0, width: 200, height: date.bounds.height / 1.0/3.0))
        nameLabel.text = "Date"
        nameLabel.font = UIFont(name: "Superclarendon-Bold", size: 20)
        nameLabel.textColor = UIColor.whiteColor()
        date.addSubview(nameLabel)
        
        nameLabelTwo = UILabel(frame: CGRect(x: date.bounds.width - 60 , y: date.bounds.height / 1.0/3.0, width: 50, height: date.bounds.height / 1.0/3.0))
        nameLabelTwo.text = "Today"
        nameLabel.font = UIFont(name: "Superclarendon", size: 20)
        nameLabelTwo.textColor = UIColor.whiteColor()
        date.addSubview(nameLabelTwo)
        
        secondContainder.addSubview(date)
    }
    
}
