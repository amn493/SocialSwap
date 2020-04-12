//
//  QrViewController.swift
//  SocialSwap
//
//  Created by DAYE JACK on 4/11/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit

class QrViewController: UIViewController {
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrImageView.image = Code.generateQr(withString: "hello swap");
        // Do any additional setup after loading the view.
        //inspired my Medium article
     //   // https://medium.com/@dominicfholmes/generating-qr-codes-in-swift-4-b5dacc75727c
     //   let mystring = "hello world";
     //   let data = mystring.data(using: String.Encoding.ascii);
     //   guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
     //       return;
     //   }
     //   qrFilter.setValue(data, forKey: "inputMessage");
     //
     //   guard let qrImage = qrFilter.outputImage else {
     //       return;
     //   }
     //
     //   let transform = CGAffineTransform(scaleX: 10, y: 10);
     //   let scaledImg = qrImage.transformed(by: transform)
     //
     //   qrImageView.image = UIImage(ciImage: scaledImg);
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}