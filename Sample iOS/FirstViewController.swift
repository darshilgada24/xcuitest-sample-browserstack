//
//  FirstViewController.swift
//  Sample iOS
//
//  Created by Lalit on 21/01/18.
//  Copyright © 2018 BrowserStack. All rights reserved.
//

import UIKit
import ReplayKit

@available(iOS 12.0, *)
class FirstViewController: UIViewController {

    @IBOutlet weak var ButtonTextInput: UIButton!
    @IBOutlet weak var ButtonNativeAlert: UIButton!
    var broadcastPicker: RPSystemBroadcastPickerView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ---ButtonTextInput starts ---
        
        ButtonTextInput.setGradientBackground(colorOne: UIColor(red: 0.00, green: 0.95, blue: 1.00, alpha: 1.0), colorTwo: UIColor(red: 0.00, green: 0.61, blue: 0.99, alpha: 1.0))
        
        // ---ButtonTextInput ends ---

        // ---ButtonNativeAlert starts ---
        
        ButtonNativeAlert.setGradientBackground(colorOne: UIColor(red: 0.00, green: 0.95, blue: 1.00, alpha: 1.0), colorTwo: UIColor(red: 0.00, green: 0.61, blue: 0.99, alpha: 1.0))
        
        // ---ButtonNativeAlert ends ---

        
        // Do any additional setup after loading the view, typically from a nib.
        
        let kPickerFrame = CGRect(x: 10.0, y: 300, width: 100.0, height: 100.0)
        broadcastPicker = RPSystemBroadcastPickerView(frame: kPickerFrame);
        broadcastPicker?.preferredExtension = "com.browserstack.Sample-iOS.ScreenRecord";
        view.addSubview(broadcastPicker!)
    }

    // Mark: Actions
    
    @IBAction func showAlert(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert", message: "This is a native alert.", preferredStyle: UIAlertControllerStyle.alert)
       
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
    
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    


}

