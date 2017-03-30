//
//  ViewController.swift
//  SwiftExampleApp
//
//  Created by David White on 29/03/2017.
//  Copyright © 2017 deltaDNA. All rights reserved.
//

import UIKit
import DeltaDNA

class ViewController: UIViewController, DDNASmartAdsRegistrationDelegate, DDNAInterstitialAdDelegate, DDNARewardedAdDelegate {
    
    @IBOutlet weak var sdkVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sdkVersion.text = DDNASmartAds.sdkVersion()
        
        DDNASDK.sharedInstance().clientVersion = "1.0.0"
        DDNASDK.sharedInstance().hashSecret = "KmMBBcNwStLJaq6KsEBxXc6HY3A4bhGw"
        DDNASDK.sharedInstance().start(withEnvironmentKey: "55822530117170763508653519413932",
                                       collectURL: "http://collect2010stst.deltadna.net/collect/api",
                                       engageURL: "http://engage2010stst.deltadna.net")
        
        DDNASmartAds.sharedInstance().registrationDelegate = self
        DDNASmartAds.sharedInstance().registerForAds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showInterstitialAd(_ sender: AnyObject) {
        let interstitialAd = DDNAInterstitialAd(delegate: self)
        interstitialAd?.show(fromRootViewController: self)
    }
    
    @IBAction func showRewardedAd(_ sender: AnyObject) {
        let rewardedAd = DDNARewardedAd(delegate: self)
        rewardedAd?.show(fromRootViewController: self)
    }
}

