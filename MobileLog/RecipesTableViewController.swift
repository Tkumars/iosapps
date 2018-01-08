//
//  MobileTableViewController.swift
//  Swift-TableView-Example
//
//  Created by Mahi Velu on 12/26/2017.
//


import UIKit


struct Mobile {
    let deviceType: String
    let model: String
    let color: String
    let version: String
    let owner: String
    let serialNo: String
    let imei: String
    let macysdevice: String
    let pin: String
    let checkedinout: String
    let ischeckedout: String
    let rowid: String
    }

class RecipesTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var mobile = [Mobile]()
    let identifier: String = "tableCell"
    var sql: String = ""
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mobiletable: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        navigationItem.title = "Mobile Test Devices"
        sql = "SELECT a.*,rowid  FROM DeviceLog a";
        
        self.mobiletable.contentInset = UIEdgeInsets.zero
        
        refreshtable()
        
        
    }
    
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            sql = "SELECT a.*,rowid  FROM DeviceLog a";
            refreshtable()
        case 1:
            sql = "SELECT a.*,rowid  FROM DeviceLog a where ischeckedout = 'Y'";
            refreshtable()
        case 2:
             sql = "SELECT a.*,rowid  FROM DeviceLog a where ischeckedout = 'N'";
            refreshtable()
        default:
            break
        }
    }
    
    func refreshtable() {
        
        mobile.removeAll()
        
        
        
        LocalDatabase.sharedInstance.methodToSelectData(sql, completion: { (dataReturned) in
            
            print(dataReturned)
            
            for dbdata in dataReturned {
                var isCheckedout = "N"
                var imei = ""
                var model = ""
                var deviceType = ""
                var color = ""
                var version = ""
                var pin = ""
                var macysdevice = ""
                var serialno = ""
                var rowid = 0
                
                var checkedinoutdate = "None"
                var owner = "None"
                if let jsonDict = dbdata as? NSDictionary {
                    if let vavailable = jsonDict["IsCheckedOut"] as? String {
                        isCheckedout = vavailable
                    }
                    if let vcolor = jsonDict["Color"] as? String {
                        color = vcolor
                    }
                    if let vversion = jsonDict["version"] as? String {
                        version = vversion
                    }
                    if let vpin = jsonDict["PIN"] as? String {
                        pin = vpin
                    }
                    if let vserial = jsonDict["SerialNo"] as? String {
                        serialno = vserial
                    }
                    if let vmacysdevice = jsonDict["MacysDevice#"] as? String {
                        macysdevice = vmacysdevice
                    }
                    if let vIMEI = jsonDict["IMEI"] as? String {
                        imei = vIMEI
                    }
                    if let vMobileName = jsonDict["Model"] as? String {
                        model = vMobileName
                    }
                    if let vMobileType = jsonDict["DeviceType"] as? String {
                        deviceType = vMobileType
                    }
                    if let vUserAssignedDate = jsonDict["CheckedInOutDate"] as? String {
                        checkedinoutdate = vUserAssignedDate
                    }
                    if let vrowid = jsonDict["rowid"] as? Int {
                        rowid = vrowid
                        print("rowid : "+String(rowid))
                    }
                    if let vUserName = jsonDict["Owner"] as? String {
                        
                        owner = vUserName
                        
                    }
                    if  model != "" {
                        self.mobile.append(Mobile(deviceType:deviceType,model:model,color:color,version:version,owner:owner,serialNo:serialno,imei:imei,macysdevice:macysdevice,pin:pin,checkedinout:checkedinoutdate,ischeckedout:isCheckedout,rowid:String(rowid)))
                    }
                }
                
                print("In Loop......");
                
            }
 
            
            
            
            
        })
        
        
        self.mobiletable.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        refreshtable()
        print("view called.......")
    }

    
    // MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TableCell
        cell.configurateTheCell(mobile[indexPath.row])
        return cell!
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count :"+String(mobile.count))
        return mobile.count
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            mobile.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
    // MARK: Segue Method
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeDetail" {
            let indexPath = self.mobiletable!.indexPathForSelectedRow
            let destinationViewController: DetailViewController = segue.destination as! DetailViewController
            destinationViewController.recipe = mobile[indexPath!.row]
        }
    }
}
