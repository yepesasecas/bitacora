//
//  ProgressHUD.swift
//  dogs
//
//  Created by Andres Yepes on 12/25/18.
//  Copyright © 2018 limonada_de_mango. All rights reserved.
//

import UIKit

class ProgressHUD: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    let stackView: UIStackView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        self.stackView = UIStackView.init(arrangedSubviews: [activityIndictor, label])
        self.stackView.axis = .vertical
        self.stackView.alignment = .fill
        self.stackView.distribution = .fillEqually
        self.stackView.spacing = 3
        super.init(effect: blurEffect)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        self.stackView = UIStackView.init(arrangedSubviews: [activityIndictor, label])
        self.stackView.axis = .vertical
        self.stackView.alignment = .fill
        self.stackView.distribution = .fillEqually
        self.stackView.spacing = 3
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(stackView)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 1.3
            let height: CGFloat = 80.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            
            vibrancyView.frame = self.bounds
            stackView.frame = vibrancyView.bounds

            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.numberOfLines = 0

            label.textColor = UIColor.darkGray
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func show(text: String) {
        self.isHidden = false
        self.label.text = text
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hide()
        }
    }
    
    func hide() {
        self.isHidden = true
    }
}
