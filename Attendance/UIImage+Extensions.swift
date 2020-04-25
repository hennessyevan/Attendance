//
//  UIImage+Extensions.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/24/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//
import UIKit

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
           return UIGraphicsImageRenderer(size: size).image { rendererContext in
               self.setFill()
               rendererContext.fill(CGRect(origin: .zero, size: size))
           }
       }
}
