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

