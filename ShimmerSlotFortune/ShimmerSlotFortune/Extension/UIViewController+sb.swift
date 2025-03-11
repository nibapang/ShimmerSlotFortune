//
//  UIViewController+sb.swift
//  ShimmerSlotFortune
//
//  Created by ShimmerSlot Fortune on 2025/3/11.
//

import UIKit

extension UIViewController {
    @IBAction func BackBtnTapped (_ sender : Any) {
        navigationController?.popViewController(animated: true)
    }
}
