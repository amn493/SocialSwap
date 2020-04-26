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
    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //initialize user object
        let db = Firestore.firestore()
                                db.collection("users").document(String(Auth.auth().currentUser!.uid)).getDocument { (document, error) in
                                    if let document = document, document.exists {
                                       _ = document.data().map(String.init(describing:)) ?? "nil"
                                       self.user.firstName = (document.data()!["firstName"]! as! String)
                                       self.user.lastName = (document.data()!["lastName"]! as! String)
                                       self.user.uid = (document.data()!["id"]! as! String)
                                     self.user.email = (document.data()!["email"]! as! String)
                                     self.user.instagram = (document.data()!["instagram"]! as! String)
                                     self.user.phoneNumber = (document.data()!["phoneNumber"]! as! String)
                                     self.user.snapchat = (document.data()!["snapchat"]! as! String)
                                     self.user.twitter = (document.data()!["twitter"]! as! String)
                                     self.user.twoWaySwap = (document.data()!["twoWaySwap"]! as! Bool)
                                     self.user.userNamesOfSwapRecieves = (document.data()!["userNamesOfSwapRecieves"]! as! Array)
                                    } else {
                                        print("Document does not exist")
                                    }
                            }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let followvc: FollowViewController = segue.destination as! FollowViewController
        followvc.sendFollowBackNotification = false
    }
    

}
