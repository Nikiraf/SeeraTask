//
//  Extensions.swift
//  HotelsTask
//
//  Created by Aleksandar Nikolic on 2.4.23..
//

import UIKit

extension UIViewController {
  func showAlert(title: String, text: String) {
    let alertController = UIAlertController(title: title,
                                            message: text,
                                            preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
}

extension UIView {
  func loadViewFromNib(nibName: String) -> UIView? {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: nibName, bundle: bundle)
    return nib.instantiate(withOwner: self, options: nil).first as? UIView
  }
  func applyShadow (cornerRadius: CGFloat? = nil) {
    if let cornerRadius = cornerRadius {
      layer.cornerRadius = cornerRadius
    }
    layer.masksToBounds = false
    layer.shadowRadius = 4.0
    layer.shadowOpacity = 0.30
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOffset = CGSize (width: 0, height: 5)
  }
}
