//
//  DefinitionSynonymsRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 23/03/2023.
//  Copyright © 2023 Mark Bailey. All rights reserved.
//

import SwiftUI

struct DefinitionSynonymsRow: View {
    let partOfSpeech : String
    let synonyms : LocalizedStringKey

    var body: some View {
        Group {
            Text(partOfSpeech)
                .foregroundColor(Color("exampleResult")) +
            Text(synonyms)
        }
        .tint(Color("synonymColor")) //Links color
    }
}

struct DefinitionSynonymsRow_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionSynonymsRow(partOfSpeech: "(n) ", synonyms: "[close-fitting](close-fitting), [thaumaturgy](thaumaturgy), [magic trick](magic%20trick)"
)
    }
}
