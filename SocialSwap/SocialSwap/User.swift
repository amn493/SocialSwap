//
//  User.swift
//  SocialSwap
//
//  Created by DAYE JACK on 4/22/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import Foundation

// User - allows a user of the app to be stored conveniently as an object with
// all relevant information pertaining to the app. This is good for accessing a user
// conveniently without having to constantly traverse Firebase.
class User {
    var uid: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var twitter: String?
    var instagram: String?
    var facebook: String?
    var snapchat: String?
    var twoWaySwap: Bool?
    var swapReceives:  [String:[String:Any]]
    init(){
        self.uid = ""
        self.firstName=""
        self.lastName=""
        self.email=""
        self.phoneNumber=""
        self.twitter = ""
        self.instagram = ""
        self.facebook = ""
        self.snapchat = ""
        self.twoWaySwap = true
        self.swapReceives = [:]
    }
    init(uid: String, firstName: String, lastName: String, email: String, phoneNumber: String) {
        self.uid = uid
        self.firstName=firstName
        self.lastName=lastName
        self.email=email
        self.phoneNumber=phoneNumber
        self.twoWaySwap=true
        self.twitter = ""
        self.instagram = ""
        self.facebook = ""
        self.snapchat = ""
        self.twoWaySwap = true
        self.swapReceives = [:]
    }
    init(uid: String, firstName: String, lastName: String, email: String, phoneNumber: String,   twitter: String,
         instagram: String,
         facebook: String,
         snapchat: String,
         twoWaySwap: Bool,
         swapReceives: [String:[String:Any]] ) {
        self.uid = uid
        self.firstName=firstName
        self.lastName=lastName
        self.email=email
        self.phoneNumber=phoneNumber
        self.twoWaySwap=true
        self.twitter = twitter
        self.instagram = instagram
        self.facebook = facebook
        self.snapchat = snapchat
        self.twoWaySwap = true
        self.swapReceives = swapReceives
    }
}
