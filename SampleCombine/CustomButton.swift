//
//  CustomButton.swift
//  SampleCombine
//
//  Created by hyunsu on 2021/05/17.
//

import UIKit

class CustomButton: UIButton {

    override func draw(_ rect: CGRect) {
        clipsToBounds = true
        layer.cornerRadius = frame.height/3
    }
    
    override var isEnabled: Bool {
        get {
            return super.isEnabled
        }
        set {
            backgroundColor = newValue ? .systemGreen : .lightGray
            super.isEnabled = newValue
        }
    }
}
