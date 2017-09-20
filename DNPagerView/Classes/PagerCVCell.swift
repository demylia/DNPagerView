//
//  PagerCVCell.swift
//  DNPagerView
//
//  Created by Dmitry.Tihonov on 09/19/2017.
//  Copyright (c) 2017 Dmitry.Tihonov. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var defaultColor: UIColor {
        return UIColor(red: 129.0 / 255.0, green: 23.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
    }
}

class PagerCVCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public weak var delegate: PagerViewDelegate?
    
    var pagerButton: UIButton!
    private func setup(){
        
        pagerButton = UIButton(frame: bounds)
        pagerButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        pagerButton.setTitleColor(PagerView.controlColor, for: .normal)
        pagerButton.addTarget(self, action: #selector(didSelectNumber), for: .touchUpInside)
        pagerButton.isEnabled = false
        
        addSubview(pagerButton)
    }
    
    override func prepareForReuse() {
        
        deselect()
    }
    
    func deselect(){
        pagerButton.layer.cornerRadius = 0
        pagerButton.backgroundColor = UIColor.white
        pagerButton.setTitleColor(PagerView.controlColor, for: .normal)
    }
    
    func didSelectNumber(sender: UIButton){
        
        delegate?.didSelectNumber(sender.tag)
    }
    
    func reload(_ value: Int){
        
        pagerButton.tag = value
        pagerButton.setTitle("\(value)", for: .normal)
        pagerButton.sizeToFit()
    }
    
    func reloadAndSelect(_ value: Int){
        reload(value)
        pagerButton.layer.cornerRadius = 3
        pagerButton.setTitleColor(UIColor.white, for: .normal)
        pagerButton.backgroundColor = PagerView.controlColor
    }
    
}
