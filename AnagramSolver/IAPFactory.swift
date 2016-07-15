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
    class func createIAPInterface()->IAPInterface{
        //return createMock()
        return createReal()
    }
    class func getProductID()->String{
        //return getTestPurchaseId()
        return getGoProId()
    }

    private class func getGoProId()->String
    {
        return "com.mpdbailey.ios.anagramsolver.gopro"
    }
    private class func getTestPurchaseId()->String
    {
        return "com.mpdbailey.ios.anagramsolver.testpurchase"
    }

    private class func createGoProProduct() -> IAPProduct
    {
        return IAPProduct(id: IAPFactory.getGoProId(),price: "£2.99", title: "Go Pro", description: "Bigger word list, supergram searches and No ads!")
    }
    private class func createTestProduct() -> IAPProduct
    {
        return IAPProduct(id: IAPFactory.getTestPurchaseId(),price: "£0.69", title: "Test", description: "Consumable test purchase")
    }
    private class func createMock()->IAPInterface{
        let mock = MockIAP()
        mock.delay=3
        mock.serverProducts.append(createGoProProduct())
        mock.serverProducts.append(createTestProduct())
        return mock
    }
    private class func createReal()->IAPInterface{
        let real = IAPHelper()
        real.productIdentifiers.insert(getGoProId())
        real.productIdentifiers.insert(getTestPurchaseId())
        return real
    }
}