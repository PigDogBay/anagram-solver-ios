//
//  IAPFactory.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 11/07/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

public class IAPFactory
{
    class func getGoProId()->String
    {
        return "com.mpdbailey.ios.anagramsolver.gopro"
    }

    class func createGoProProduct() -> IAPProduct
    {
        return IAPProduct(id: IAPFactory.getGoProId(),price: "£2.99", title: "Go Pro", description: "Bigger word list, supergram searches and No ads!")
    }
    class func createMock()->IAPInterface{
        let mock = MockIAP()
        mock.delay=5
        mock.serverProducts.append(createGoProProduct())
        return mock
    }
}