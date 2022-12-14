//
//  FollowViewController.swift
//  SocialSwap
//
//  Created by Ashley Nussbaum on 4/18/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//
import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

class FollowViewController: UIViewController {
    var user = User()
    var currentUser: User?
    var dbloaded = false

    //buttons
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var snapchatButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var contactsButton: UIButton!
    var buttons: [UIButton] = []
    
    //icons
    @IBOutlet weak var instagramIcon: UIImageView!
    @IBOutlet weak var facebookIcon: UIImageView!
    @IBOutlet weak var snapchatIcon: UIImageView!
    @IBOutlet weak var twitterIcon: UIImageView!
    @IBOutlet weak var contactsIcon: UIImageView!
    var icons: [UIImageView] = []
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var scannedUser: User?
    var csvForSwap: String?
    var swapData: [String]?
    var sessionStarter: SessionStarterDelegate?
    
    //vars for follow back
    var instagramPressed: Bool = false
    var facebookPressed: Bool = false
    var snapchatPressed: Bool = false
    var twitterPressed: Bool = false
    var contactsPressed: Bool = false
    
    var instagramEnabled: Bool = false
    var twitterEnabled: Bool = false
    var snapchatEnabled: Bool = false
    var twoWaySwapEnabled: Bool = false
    var contactsEnabled: Bool = false
    var facebookEnabled: Bool = false
    
    var sendFollowBackNotification: Bool = false
    var fromNotifications: Bool = false
    var notificationsVC: NotificationsTableViewController = NotificationsTableViewController()
    
    
    
    func disableButton(button: UIButton) {
        button.isEnabled = false
        button.alpha = 0.3
        button.setTitle("               N/A", for: UIControl.State.normal)
        icons[buttons.firstIndex(of: button)!].alpha = 0.3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //initialize button arrays
        buttons = [instagramButton, facebookButton, snapchatButton, twitterButton, contactsButton]
        
        icons = [instagramIcon, facebookIcon, snapchatIcon, twitterIcon, contactsIcon]
        
        
        if(scannedUser != nil){
            self.nameLabel.text = scannedUser!.firstName! + " " + scannedUser!.lastName!
            
            
            
            //disable buttons if scannedUser didnt share account and currentUser doesnt have account
            if !instagramEnabled || currentUser!.instagram == "" {
               disableButton(button: instagramButton)
            }
            if !facebookEnabled || currentUser!.facebook == "" {
               disableButton(button: facebookButton)
            }
            if !snapchatEnabled || currentUser!.snapchat == "" {
                disableButton(button: snapchatButton)            }
            if !twitterEnabled || currentUser!.twitter == "" {
               disableButton(button: twitterButton)
            }
            if !contactsEnabled {
               disableButton(button: contactsButton)
            }
        }
         
        //scannedUser == nil
        else {
            for i in 0..<buttons.count {
                disableButton(button: buttons[i])
            }
        }
            
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if(self.sessionStarter != nil){
            self.sessionStarter!.startSession();
        }
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func DoneButtonPressed(_ sender: Any) {
        
        //update notifications table
        if fromNotifications {
            notificationsVC.populateTable()
        }
        
        self.presentingViewController?.dismiss(animated: true, completion: {
       //     if(self.sessionStarter != nil){
       //         self.sessionStarter!.startSession();
       //     }
        })
    }
    
    @IBAction func instagramPressed(_ sender: Any) {
        if(scannedUser != nil){
            SwapHelper.openInstagram(handle: scannedUser!.instagram!)
            instagramButton.setTitle("               Followed", for: UIControl.State.normal)
            
            //from scanner and two way swap is on
            if !instagramPressed && sendFollowBackNotification {
                instagramPressed = true
                
                //uid is in map
                if scannedUser!.swapReceives[(currentUser!.uid)!] != nil {
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.instagram!, forKey: "instagram")
                    let db = Firestore.firestore()
                    db.collection("users").document(scannedUser!.uid!).updateData([
                        "swapReceives" : scannedUser!.swapReceives
                               ])
                }
                //uid isnt in map
                else{
                    scannedUser!.swapReceives.updateValue(["instagram":currentUser!.instagram!], forKey: currentUser!.uid!)
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.firstName!, forKey: "firstName")
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.lastName!, forKey: "lastName")
                    let db = Firestore.firestore()
                    db.collection("users").document(scannedUser!.uid!).updateData([
                        "swapReceives" : scannedUser!.swapReceives
                               ])
                }
            }
            
            
            if !instagramPressed && fromNotifications {
                instagramPressed = true
                
                var currentUserReceives = currentUser!.swapReceives
                currentUserReceives[(scannedUser!.uid)!]!.removeValue(forKey: "instagram")
                if currentUserReceives[(scannedUser!.uid)!]!.count==2{
                    currentUserReceives.removeValue(forKey: (scannedUser!.uid)!)
                }
                currentUser!.swapReceives = currentUserReceives
                let db = Firestore.firestore()
                                   db.collection("users").document(currentUser!.uid!).updateData([
                                       "swapReceives" : currentUser!.swapReceives
                                              ])
                
            }
        }
    }
    
    @IBAction func facebookPressed(_ sender: Any) {
        if(scannedUser != nil){
            SwapHelper.openFacebook(url: scannedUser!.facebook!)
            facebookButton.setTitle("               Added", for: UIControl.State.normal)
            
            
            if !facebookPressed && sendFollowBackNotification {
                facebookPressed = true
                
                //uid is in map
                if scannedUser!.swapReceives[(currentUser!.uid)!] != nil {
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.facebook!, forKey: "facebook")
                    let db = Firestore.firestore()
                    db.collection("users").document(scannedUser!.uid!).updateData([
                        "swapReceives" : scannedUser!.swapReceives
                               ])
                }
                //uid isnt in map
                else{
                    scannedUser!.swapReceives.updateValue(["facebook":currentUser!.facebook!], forKey: currentUser!.uid!)
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.firstName!, forKey: "firstName")
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.lastName!, forKey: "lastName")
                    let db = Firestore.firestore()
                    db.collection("users").document(scannedUser!.uid!).updateData([
                        "swapReceives" : scannedUser!.swapReceives
                               ])
                }
            }
            
            if !facebookPressed && fromNotifications {
                facebookPressed = true
                
                var currentUserReceives = currentUser!.swapReceives
                currentUserReceives[(scannedUser!.uid)!]!.removeValue(forKey: "facebook")
                if currentUserReceives[(scannedUser!.uid)!]!.count==2{
                    currentUserReceives.removeValue(forKey: (scannedUser!.uid)!)
                }
                currentUser!.swapReceives = currentUserReceives
                let db = Firestore.firestore()
                                   db.collection("users").document(currentUser!.uid!).updateData([
                                       "swapReceives" : currentUser!.swapReceives
                                              ])
                
            }
        }
    }
    
    @IBAction func snapchatPressed(_ sender: Any) {
        if(scannedUser != nil){
            SwapHelper.openSnapchat(handle: scannedUser!.snapchat!)
            snapchatButton.setTitle("               Added", for: UIControl.State.normal)
            
            
            if !snapchatPressed && sendFollowBackNotification {
                snapchatPressed = true
                
                //uid is in map
                if scannedUser!.swapReceives[(currentUser!.uid)!] != nil {
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.snapchat!, forKey: "snapchat")
                    let db = Firestore.firestore()
                    db.collection("users").document(scannedUser!.uid!).updateData([
                        "swapReceives" : scannedUser!.swapReceives
                               ])
                }
                //uid isnt in map
                else{
                    scannedUser!.swapReceives.updateValue(["snapchat":currentUser!.snapchat!], forKey: currentUser!.uid!)
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.firstName!, forKey: "firstName")
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.lastName!, forKey: "lastName")
                    let db = Firestore.firestore()
                    db.collection("users").document(scannedUser!.uid!).updateData([
                        "swapReceives" : scannedUser!.swapReceives
                               ])
                }
            }
            if !snapchatPressed && fromNotifications {
                snapchatPressed = true
                
                var currentUserReceives = currentUser!.swapReceives
                currentUserReceives[(scannedUser!.uid)!]!.removeValue(forKey: "snapchat")
                if currentUserReceives[(scannedUser!.uid)!]!.count==2{
                    currentUserReceives.removeValue(forKey: (scannedUser!.uid)!)
                }
                currentUser!.swapReceives = currentUserReceives
                let db = Firestore.firestore()
                                   db.collection("users").document(currentUser!.uid!).updateData([
                                       "swapReceives" : currentUser!.swapReceives
                                              ])
                
            }
        }
    }
    
    @IBAction func twitterPressed(_ sender: Any) {
        if(scannedUser != nil){
            SwapHelper.openTwitter(handle: scannedUser!.twitter!)
            twitterButton.setTitle("               Followed", for: UIControl.State.normal)
            
            
            if !twitterPressed && sendFollowBackNotification {
                twitterPressed = true
                
                //uid is in map
                if scannedUser!.swapReceives[(currentUser!.uid)!] != nil {
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.twitter!, forKey: "twitter")
                    let db = Firestore.firestore()
                    db.collection("users").document(scannedUser!.uid!).updateData([
                        "swapReceives" : scannedUser!.swapReceives
                               ])
                }
                //uid isnt in map
                else{
                    scannedUser!.swapReceives.updateValue(["twitter":currentUser!.twitter!], forKey: currentUser!.uid!)
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.firstName!, forKey: "firstName")
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.lastName!, forKey: "lastName")
                    let db = Firestore.firestore()
                    db.collection("users").document(scannedUser!.uid!).updateData([
                        "swapReceives" : scannedUser!.swapReceives
                               ])
                }
            }
            
            if !twitterPressed && fromNotifications {
                twitterPressed = true
                
                var currentUserReceives = currentUser!.swapReceives
                currentUserReceives[(scannedUser!.uid)!]!.removeValue(forKey: "twitter")
                if currentUserReceives[(scannedUser!.uid)!]!.count==2{
                    currentUserReceives.removeValue(forKey: (scannedUser!.uid)!)
                }
                currentUser!.swapReceives = currentUserReceives
                let db = Firestore.firestore()
                                   db.collection("users").document(currentUser!.uid!).updateData([
                                       "swapReceives" : currentUser!.swapReceives
                                              ])
                
            }
        }
    }
    
    @IBAction func contactsPressed(_ sender: Any) {
        if(scannedUser != nil){
            SwapHelper.saveContact(firstName: scannedUser!.firstName!, lastName: scannedUser!.lastName!, phoneNumber: scannedUser!.phoneNumber!)
            contactsButton.setTitle("               Added", for: UIControl.State.normal)
            
            
            if !contactsPressed && sendFollowBackNotification {
                contactsPressed = true
                
                //uid is in map
                if scannedUser!.swapReceives[(currentUser!.uid)!] != nil {
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.phoneNumber!, forKey: "phoneNumber")
                    let db = Firestore.firestore()
                    db.collection("users").document(scannedUser!.uid!).updateData([
                        "swapReceives" : scannedUser!.swapReceives
                               ])
                }
                //uid isnt in map
                else{
                    scannedUser!.swapReceives.updateValue(["phoneNumber":currentUser!.phoneNumber!], forKey: currentUser!.uid!)
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.firstName!, forKey: "firstName")
                    scannedUser!.swapReceives[(currentUser!.uid)!]!.updateValue( currentUser!.lastName!, forKey: "lastName")
                    let db = Firestore.firestore()
                    db.collection("users").document(scannedUser!.uid!).updateData([
                        "swapReceives" : scannedUser!.swapReceives
                               ])
                }
            }
            
            if !contactsPressed && fromNotifications {
                contactsPressed = true
                
                var currentUserReceives = currentUser!.swapReceives
                currentUserReceives[(scannedUser!.uid)!]!.removeValue(forKey: "phoneNumber")
                if currentUserReceives[(scannedUser!.uid)!]!.count==2{
                    currentUserReceives.removeValue(forKey: (scannedUser!.uid)!)
                }
                currentUser!.swapReceives = currentUserReceives
                let db = Firestore.firestore()
                                   db.collection("users").document(currentUser!.uid!).updateData([
                                       "swapReceives" : currentUser!.swapReceives
                                              ])
            }
        }
    }
}
