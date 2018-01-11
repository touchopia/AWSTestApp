//
//  AppDelegate.swift
//  AWSTestApp
//
//  Created by Phil Wright on 1/11/18.
//  Copyright © 2018 Touchopia, LLC. All rights reserved.
//

import UIKit
import AWSCore
import AWSCognito

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupAmazonCredentials()
        
        return true
    }
    
    func setupAmazonCredentials() {
        // Initialize the Amazon Cognito credentials provider
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast2,
                                                                identityPoolId:"us-east-2:ce072390-bfb8-47b3-a577-8ed3bf2d92d1")
        
        let configuration = AWSServiceConfiguration(region:.USEast2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let syncClient = AWSCognito.default()
        let dataset = syncClient.openOrCreateDataset("myDataset")
        dataset.setString("myValue", forKey:"myKey")
        dataset.synchronize().continueWith(block: { (task) -> Any? in
            // Your handler code here
            return nil
        })
    }
}

