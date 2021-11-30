//
//  BroadcastSetupViewController.swift
//  ScreenRecordSetupUI
//
//  Created by Darshil Gada on 29/11/21.
//  Copyright © 2021 BrowserStack. All rights reserved.
//

import ReplayKit

class BroadcastSetupViewController: UIViewController {

    // Call this method when the user has finished interacting with the view controller and a broadcast stream can start
    func userDidFinishSetup() {
        // URL of the resource where broadcast can be viewed that will be returned to the application
        let broadcastURL = URL(string:"http://apple.com/broadcast/streamID")
        
        // Dictionary with setup information that will be provided to broadcast extension when broadcast is started
        let setupInfo: [String : NSCoding & NSObjectProtocol] = ["broadcastName": "example" as NSCoding & NSObjectProtocol]
        
        // Tell ReplayKit that the extension is finished setting up and can begin broadcasting
        if #available(iOSApplicationExtension 11.0, *) {
            self.extensionContext?.completeRequest(withBroadcast: broadcastURL!, setupInfo: setupInfo)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func userDidCancelSetup() {
        let error = NSError(domain: "YouAppDomain", code: -1, userInfo: nil)
        // Tell ReplayKit that the extension was cancelled by the user
        self.extensionContext?.cancelRequest(withError: error)
    }
}
