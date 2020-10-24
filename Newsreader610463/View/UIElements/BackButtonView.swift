//
//  BackButtonView.swift
//  Newsreader610463
//
//  Created by Vicente on 24/10/2020.
//

import Foundation
import SwiftUI

struct MyBackButton: View {
    let label: String
    let closure: () -> ()

    var body: some View {
        Button(action: { self.closure() }) {
            HStack {
                Image(systemName: "chevron.left")
                Text(label)
            }
        }
    }
}
