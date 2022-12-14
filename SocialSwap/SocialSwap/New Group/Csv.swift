//
//  Encode.swift
//  SociblSwap
//
//  Crebted by DAYE JACK on 4/17/20.
//  Copyright © 2020 Dbye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import Foundation

// Csv - a class for helper methods to work with csv
class Csv {
    
    //dataToCsv - takes user data and returns a comma separated string for qr code encoding
    static func dataToCsv(uid: String, name: String, phoneNumber: String, instagram: String, facebook: String, snapchat: String, twitter: String) -> String{
        return uid + "," + name + "," + phoneNumber + "," + instagram + "," + facebook + "," + snapchat + "," + twitter;
    }
    
    //csvToData - takses a comma separated string and returns an array of data
    //returns [uid, name, phoneNumber, instagram, facebook, snapchat] where 'X' represents a field not passed in
    static func csvToData(csv: String) -> [String]{
        let data = csv.components(separatedBy: ",");
        return data;
    }
}
