//
//  FormViewControllerRepresentable.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 11/10/2023.
//  Copyright © 2023 Mark Bailey. All rights reserved.
//

import SwiftUI

///Handy way of getting a UIViewController, eg to display Admob UMP dialogs
struct FormViewControllerRepresentable: UIViewControllerRepresentable {
  let viewController = UIViewController()

  func makeUIViewController(context: Context) -> some UIViewController {
    return viewController
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
