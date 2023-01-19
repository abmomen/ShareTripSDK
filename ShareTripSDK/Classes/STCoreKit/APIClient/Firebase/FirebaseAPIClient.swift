//
//  FirebaseDefaultAPIClient().swift
//  ShareTrip
//
//  Created by ShareTrip iOS on 13/9/21.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

import Alamofire

public protocol TNCService {
    func getTNC(completion: @escaping (AFResult<TNC>) -> Void)
}

public protocol FAQService {
    func getFAQ(completion: @escaping (AFResult<FAQ>) -> Void)
}

//MARK:- TNCService APIClient
extension DefaultAPIClient: TNCService {
    public func getTNC(completion: @escaping (AFResult<TNC>) -> Void) {
        DefaultAPIClient().performRequest(route: FirebaseRouter.tnc, completion: completion)
    }
}

//MARK:- FAQService APIClient
extension DefaultAPIClient: FAQService {
    public func getFAQ(completion: @escaping (AFResult<FAQ>) -> Void) {
        DefaultAPIClient().performRequest(route: FirebaseRouter.faq, completion: completion)
    }
}
