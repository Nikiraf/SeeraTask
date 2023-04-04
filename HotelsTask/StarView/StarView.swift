//
//  StarView.swift
//  HotelsTask
//
//  Created by Aleksandar Nikolic on 3.4.23..
//

import UIKit

// Can be made as UIStackView and imageView can be added throught the loop which will result in less lines of the code
class StarView: UIView {
  
  @IBOutlet weak var starOneImageView: UIImageView!
  @IBOutlet weak var starTwoImageView: UIImageView!
  @IBOutlet weak var starThreeImageView: UIImageView!
  @IBOutlet weak var starFourImageView: UIImageView!
  @IBOutlet weak var starFiveImageView: UIImageView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureView()
  }
  
  private func configureView() {
    guard let view = self.loadViewFromNib(nibName: "StarView") else { return }
    view.frame = self.bounds
    self.addSubview(view)
  }
  
  func setRating(_ rating: Int) {
    setAllStartsImageToNil()
    if rating == 5 {
      starOneImageView.image = UIImage(systemName: "star.fill")
      starTwoImageView.image = UIImage(systemName: "star.fill")
      starThreeImageView.image = UIImage(systemName: "star.fill")
      starFourImageView.image = UIImage(systemName: "star.fill")
      starFiveImageView.image = UIImage(systemName: "star.fill")
    } else if rating == 4 {
      starOneImageView.image = UIImage(systemName: "star.fill")
      starTwoImageView.image = UIImage(systemName: "star.fill")
      starThreeImageView.image = UIImage(systemName: "star.fill")
      starFourImageView.image = UIImage(systemName: "star.fill")
      starFiveImageView.image = UIImage(systemName: "star")
    } else if rating == 3 {
      starOneImageView.image = UIImage(systemName: "star.fill")
      starTwoImageView.image = UIImage(systemName: "star.fill")
      starThreeImageView.image = UIImage(systemName: "star.fill")
      starFourImageView.image = UIImage(systemName: "star")
      starFiveImageView.image = UIImage(systemName: "star")
    } else if rating == 2 {
      starOneImageView.image = UIImage(systemName: "star.fill")
      starTwoImageView.image = UIImage(systemName: "star.fill")
      starThreeImageView.image = UIImage(systemName: "star")
      starFourImageView.image = UIImage(systemName: "star")
      starFiveImageView.image = UIImage(systemName: "star")
    } else if rating == 1 {
      starOneImageView.image = UIImage(systemName: "star.fill")
      starTwoImageView.image = UIImage(systemName: "star")
      starThreeImageView.image = UIImage(systemName: "star")
      starFourImageView.image = UIImage(systemName: "star")
      starFiveImageView.image = UIImage(systemName: "star")
    } else {
      setAllStartsImageToNil()
    }
  }
  
  private func setAllStartsImageToNil() {
    starOneImageView.image = nil
    starTwoImageView.image = nil
    starThreeImageView.image = nil
    starFourImageView.image = nil
    starFiveImageView.image = nil
  }
  
}
