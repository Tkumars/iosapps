//
//  DetailViewController.swift
//  Swift-TableView-Example
//
//
//  Created by Mahi Velu on 12/26/2017.
//

import Foundation
import UIKit

class DetailViewController: UITableViewController,UITextFieldDelegate {

    
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var model: UILabel?
    @IBOutlet var imei: UILabel?
    @IBOutlet var serial: UILabel?

    @IBOutlet var color: UILabel?
    @IBOutlet var version: UILabel?
    @IBOutlet var macysdevice: UILabel?
    @IBOutlet var pin: UILabel?
 
    @IBOutlet var mybutton: UIButton?
    @IBOutlet var myownertype: UILabel?
    @IBOutlet var mycheckedtype: UILabel?
    @IBOutlet var mycheckeddatetype: UILabel?
    
    
    @IBOutlet var owner: UILabel?
    @IBOutlet var date: UILabel?
    
    @IBOutlet var mytextinput: UITextField?
    
    
    
    
    @IBOutlet weak var myLabel: UILabel!
    
    @IBAction func AssignUser(sender: UIButton) {
        print("val"+myLabel.text!)
        if (myLabel.text == " Choose User ") {
        print("val"+myLabel.text!)
        let alert = UIAlertController(title: "Alert", message: "Choose User to Assign", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        else {
        
        let sql = "Update DeviceLog set owner='"+myLabel.text!+"',checkedinoutdate=current_date , ischeckedout='Y' where IMEI ='"+recipe!.imei+"'"
        
        LocalDatabase.sharedInstance.methodToInsertUpdateDeleteData(sql, completion: { (completed) in
            if completed
            {
                print("Data updated successfully")
            }
            else
            {
                print("Fail while data updation")
            }
        })
            owner?.text = "Assigned User: "+myLabel.text!
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
    
            date?.text = "Assigned Date: "+formatter.string(from: Date())
            
            
            let alert = UIAlertController(title: "Alert", message: "User Assigned Successfully", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
           }
    @IBAction func ReturnDevice(sender: UIButton) {
        
        if sender.titleLabel?.text == "Check In" {
        
        let sql = "Update DeviceLog set checkedinoutdate=current_date,ischeckedout='N' where rowid ="+recipe!.rowid
        
        LocalDatabase.sharedInstance.methodToInsertUpdateDeleteData(sql, completion: { (completed) in
            if completed
            {
                print("Data updated successfully")
            }
            else
            {
                print("Fail while data updation")
            }
        })
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        date?.text = formatter.string(from: Date())
        
        myownertype?.text = "Past Owner"
        mycheckedtype?.text = "Check Out Owner"
        mycheckeddatetype?.text = "Checked In Date"
        mybutton?.setTitle("Check Out", for: .normal)

        let alertmsg = (owner?.text!)!+" Retured Device Successfully"

        let alert = UIAlertController(title: "Alert", message: alertmsg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
            
        }
        else
        {
            print("checkedddddddddd out")
            
            print("val"+(mytextinput?.text!)!)
            
            let txtlbl = (mytextinput?.text!)!
            
            if (txtlbl == "") {
             //   print("val"+myLabel.text!)
                let alert = UIAlertController(title: "Alert", message: "Please enter Checked Out Owner", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                
                let sql = "Update DeviceLog set owner='"+txtlbl+"',checkedinoutdate=current_date , ischeckedout='Y' where rowid ="+recipe!.rowid
                
                LocalDatabase.sharedInstance.methodToInsertUpdateDeleteData(sql, completion: { (completed) in
                    if completed
                    {
                        print("Data updated successfully")
                    }
                    else
                    {
                        print("Fail while data updation")
                    }
                })
                owner?.text = txtlbl
                
                myownertype?.text = "Current Owner"
                mycheckedtype?.text = ""
                mycheckeddatetype?.text = "Checked Out Date"
                mybutton?.setTitle("Check In", for: .normal)
                mytextinput?.text = ""
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                date?.text = formatter.string(from: Date())
                
                let alertmsg = txtlbl+" Checked Out Successfully"
                
                let alert = UIAlertController(title: "Alert", message: alertmsg, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }

    }
    
    
    var recipe: Mobile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mytextinput?.delegate = self
        
        myLabel?.text = "None"
        
        navigationItem.title = recipe?.deviceType
        
    if recipe?.deviceType == "Android" {
        imageView?.image = UIImage(named: "android.png")
    }
    else
    {
        imageView?.image = UIImage(named: "apple.png")
    }
        model?.text = recipe!.model
        imei?.text = "IMEI : " + recipe!.imei
        owner?.text = recipe!.owner
        date?.text = recipe!.checkedinout
        color?.text = recipe!.color
        pin?.text = recipe!.pin
        version?.text = recipe!.version
        macysdevice?.text = recipe!.macysdevice
        
        if recipe!.ischeckedout == "Y" {
            mybutton?.setTitle("Check In", for: .normal)
            myownertype?.text = "Current Owner"
            mycheckedtype?.text = ""
            mycheckeddatetype?.text = "Checked Out Date"
        }
        else
        {
            mybutton?.setTitle("Check Out", for: .normal)
            myownertype?.text = "Past Owner"
            mycheckedtype?.text = "Check Out Owner"
            mycheckeddatetype?.text = "Checked In Date"


        }
        
        

        
    }
    
    // UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField did begin editing method called")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called")
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        print(textField.text ?? "None")
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    

    
  
}


