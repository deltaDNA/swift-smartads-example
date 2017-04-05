//
// Copyright (c) 2017 deltaDNA Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import DeltaDNA

class ViewController: UIViewController {
    
    @IBOutlet weak var sdkVersion: UILabel!
    
    var interstitialAd: DDNAInterstitialAd?
    var rewardedAd: DDNARewardedAd?
    
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
        self.interstitialAd?.delegate = nil
        self.interstitialAd = interstitialAd
    }
    
    @IBAction func showRewardedAd(_ sender: AnyObject) {
        let rewardedAd = DDNARewardedAd(delegate: self)
        rewardedAd?.show(fromRootViewController: self)
        self.rewardedAd?.delegate = nil
        self.rewardedAd = rewardedAd
    }
}

extension ViewController: DDNASmartAdsRegistrationDelegate {
    func didRegisterForInterstitialAds() {
        print("Registered for interstitial ads.")
    }
    func didFailToRegisterForInterstitialAds(withReason reason: String!) {
        print("Failed to register for interstitial ads: \(reason).")
    }
    func didRegisterForRewardedAds() {
        print("Registered for rewarded ads.")
    }
    func didFailToRegisterForRewardedAds(withReason reason: String!) {
        print("Failed to register for rewarded ads: \(reason).")
    }
}

extension ViewController: DDNAInterstitialAdDelegate {
    func didOpen(_ interstitialAd: DDNAInterstitialAd!) {
        print("Opened interstitial ad.")
    }
    func didFail(toOpen interstitialAd: DDNAInterstitialAd!, withReason reason: String!) {
        print("Failed to open interstitial ad: \(reason).")
    }
    func didClose(_ interstitialAd: DDNAInterstitialAd!) {
        print("Closed interstitial ad.")
    }
}

extension ViewController: DDNARewardedAdDelegate {
    func didOpen(_ rewardedAd: DDNARewardedAd!) {
        print("Opened rewarded ad.")
    }
    func didFail(toOpen rewardedAd: DDNARewardedAd!, withReason reason: String!) {
        print("Failed to open rewarded ad.")
    }
    func didClose(_ rewardedAd: DDNARewardedAd!, withReward reward: Bool) {
        print("Closed rewarded ad with reward = \(reward)")
    }
}


