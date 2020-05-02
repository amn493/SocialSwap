//
//  NotificationsTableViewController.swift
//  SocialSwap
//
//  Created by Ashley Nussbaum on 4/25/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class NotificationsTableViewController: UITableViewController {
    var currentUser: User?
    var followBackUsers: [User] = [];
    
    override func viewWillAppear(_ animated: Bool) {
        //do not display empty cells
        self.tableView.tableFooterView = UIView()
        followBackUsers = []
        
        //get user and populate followBackUsers - the datasource for the table view
        UserService.getUser(uid: Auth.auth().currentUser!.uid) { (user) in
            self.currentUser = user;
            //update follow back data
            var first = "";var last = ""; var insta="";
            var tw=""; var fb=""; var snap = ""; var mail=""; var num = "";
            for (uid, infoDict) in user!.swapReceives {
                
                if let twitterHandle = infoDict["twitter"] {
                    tw = twitterHandle as! String
                }
                if let instagramHandle = infoDict["instagram"] {
                    insta = instagramHandle as! String
                }
                if let facebookUrl = infoDict["facebook"] {
                    fb = facebookUrl as! String
                    
                }
                if let snapchatHandle = infoDict["snapchat"] {
                    snap = snapchatHandle as! String
                }
                if let firstName = infoDict["firstName"]{
                    first = firstName as! String
                }
                if let lastName = infoDict["lastName"] {
                    last = lastName as! String
                }
                if let email = infoDict["email"] {
                    mail = email as! String
                }
                if let phoneNumber = infoDict["phoneNumber"] {
                    num = phoneNumber as! String
                }
                
                let followBackUser = User(uid: uid, firstName: first, lastName: last, email: mail, phoneNumber: num, twitter: tw, instagram: insta, facebook: fb, snapchat: snap, twoWaySwap: false, swapReceives: [:])
                
                print(followBackUser)

                self.followBackUsers.append(followBackUser)
            }
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.followBackUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel!.text = self.followBackUsers[indexPath.row].firstName! + " " + self.followBackUsers[indexPath.row].lastName! + " followed you"
        cell.detailTextLabel!.text = "Follow back?"
        return cell
    }
   
    /* Table View Delegate */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let followVc = storyboard.instantiateViewController(identifier: "FollowVC") as! FollowViewController
        let scannedUser = self.followBackUsers[indexPath.row]
        followVc.scannedUser = scannedUser
            
        //followVc.twoWaySwapEnabled = twoWaySwap
        followVc.contactsEnabled = scannedUser.phoneNumber != ""
        followVc.instagramEnabled = scannedUser.instagram! != ""
        followVc.facebookEnabled = scannedUser.facebook! != ""
        followVc.snapchatEnabled = scannedUser.snapchat! != ""
        followVc.twitterEnabled = scannedUser.twitter! != ""

        followVc.currentUser = self.currentUser
        followVc.fromNotifications = true
        followVc.sendFollowBackNotification = false
        
        tableView.deselectRow(at: indexPath, animated: true)

        self.present(followVc, animated: true)

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let followvc: FollowViewController = segue.destination as! FollowViewController
        followvc.sendFollowBackNotification = false
    }
     */
    
}
