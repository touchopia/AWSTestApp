//
//  ViewController.swift
//  AWSTestApp
//
//  Created by Phil Wright on 1/11/18.
//  Copyright © 2018 Touchopia, LLC. All rights reserved.
//

import UIKit
import AWSS3

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transferManager = AWSS3TransferManager.default()
        
        let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("phil.png")
        
        if let downloadRequest = AWSS3TransferManagerDownloadRequest() {
            
            downloadRequest.bucket = "wgu.test.bucket"
            downloadRequest.key = "phil.png"
            downloadRequest.downloadingFileURL = downloadingFileURL
            
            transferManager.download(downloadRequest).continueWith(executor: AWSExecutor.mainThread(), block: { task -> Any? in
                
                if let error = task.error as NSError? {
                    if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch code {
                        case .cancelled, .paused:
                            break
                        default:
                            print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
                        }
                    } else {
                        print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
                    }
                    return nil
                }
                print("Download complete for: \(String(describing: downloadRequest.key))")
                if let _ = task.result {
                    
                    self.imageView.image = UIImage(contentsOfFile: downloadingFileURL.path)
                } else {
                    print("could not load file at \(downloadingFileURL.path)")
                }
                return nil
            })
        }
        
    }
    
    
}

