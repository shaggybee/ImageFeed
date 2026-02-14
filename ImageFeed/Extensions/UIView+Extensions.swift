//
//  UIView+Extensions.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 14.02.2026.
//

import UIKit

extension UIView {
    func forAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
