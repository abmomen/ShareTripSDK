//
//  FlightLegPlaceholderView.swift
//  ShareTrip
//
//  Created by Mac on 11/25/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class FlightLegPlaceholderView: UIView {
    
    /*@IBOutlet weak var airplaneLogo: UIView!
    @IBOutlet weak var legView: UIView!
    @IBOutlet weak var airplaneName: UIView!
    @IBOutlet weak var stopView: UIView!
    @IBOutlet weak var timeView: UIView!
    */
    
    class func instanceFromNib() -> FlightLegPlaceholderView {
        let bundle = Bundle(for: FlightLegPlaceholderView.self)
        return UINib(nibName: "FlightLegPlaceholderView", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! FlightLegPlaceholderView
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupView()
    }

    private func setupView() {
        
        /*let sViews = self.subviewsRecursive().filter({ (obj) -> Bool in
            obj.tag < 0
        })
        for view in sViews {
            view.layer.cornerRadius = view.layer.frame.size.height/2
        }*/
        
        /*airplaneLogo.layer.cornerRadius = airplaneLogo.layer.frame.size.height/2
        legView.layer.cornerRadius = legView.layer.frame.size.height/2
        airplaneName.layer.cornerRadius = airplaneName.layer.frame.size.height/2
        stopView.layer.cornerRadius = stopView.layer.frame.size.height/2
        timeView.layer.cornerRadius = timeView.layer.frame.size.height/2
        */
        
        
    }
}
