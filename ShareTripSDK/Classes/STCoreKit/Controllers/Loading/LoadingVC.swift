//
//  LoadingVC.swift
//  TBBD
//
//  Created by TBBD on 3/25/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import Lottie

public struct LoadingData {
    public let title: String
    public let subtitle: String
    public let animationName: String
    
    public init(title: String, subtitle: String, animationName: String) {
        self.title = title
        self.subtitle = subtitle
        self.animationName = animationName
    }
}

public class LoadingVC: UIViewController {
    
    @IBOutlet weak var loadingAnimationView: LottieAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var loadingData: LoadingData!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadingAnimationView
        let animation = LottieAnimation.named(loadingData.animationName, subdirectory: "LottieResources")
        loadingAnimationView.animation = animation
        loadingAnimationView.contentMode = .scaleAspectFit
        loadingAnimationView.backgroundBehavior = .pauseAndRestore
        
        titleLabel.text = loadingData.title
        subtitleLabel.text = loadingData.subtitle
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadingAnimationView.play(fromProgress: 0,
                                  toProgress: 1,
                                  loopMode: LottieLoopMode.loop,
                                  completion: { (finished) in
                                    STLog.info("Animation \(finished ? "Completed" : "Cancelled")")
                                  })
    }
}
