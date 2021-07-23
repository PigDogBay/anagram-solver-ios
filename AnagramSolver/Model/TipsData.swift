//
//  TipsData.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/02/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import Foundation

let tipsData : [Tip] = load("tips.json")
let anagramTip = tipsData[0]
let crosswordTip = tipsData[1]
let blankLettersTip = tipsData[2]
let twoWordAnagramTip = tipsData[3]
let shortcutsTip = tipsData[4]
let supergramsTip = tipsData[5]
let prefixSuffixTip = tipsData[6]
let codewordsTip = tipsData[7]

struct Tip : Identifiable, Codable{
    var id : Int
    var title : String
    var subtitle : String
    var description : String
    var example : String
    var advanced : String
    var showMe : String
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
