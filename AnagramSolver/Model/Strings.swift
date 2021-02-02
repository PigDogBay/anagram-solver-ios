//
//  Strings.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 28/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation
struct Strings {
    static let appName = "Anagram Solver"
    static var version : String {Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String }
    static let appId = "id973923699"
    static let privacyURL = "https://pigdogbay.blogspot.co.uk/2018/05/privacy-policy.html"
    static let itunesAppURL = "https://itunes.apple.com/app/"+Strings.appId
    static let emailAddress = "mpdbailey@yahoo.co.uk"
    static let webAddress = "www.mpdbailey.co.uk"
    static let feedbackSubject = "AS iOS v\(Strings.version)"
    static let tellFriends = "Take a look at Anagram Solver "+Strings.itunesAppURL
    static let errorTitle = "Don't Panic!"
    static let errorMessage = "Something went wrong so let's fix this.\n\n1-Restart the app\n2-Close other apps\n3-Power off/on"
}
