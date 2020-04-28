//
//  NavigationBarBuilder.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/26/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI

struct NavigationBarBuilder: UIViewControllerRepresentable {

    var build: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationBarBuilder>) -> UIViewController {

        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationBarBuilder>) {

        if let navigationController = uiViewController.navigationController{
            self.build(navigationController)
        }
    }
}
