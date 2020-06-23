//
//  Speech.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 23/06/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import Foundation
import AVFoundation

func utilsSpeak(text : String){
    let synthesizer = AVSpeechSynthesizer()
    let utterance = AVSpeechUtterance(string: text)
    let locale = Locale.current.identifier
    utterance.voice = AVSpeechSynthesisVoice(language: locale)
    synthesizer.speak(utterance)
}
