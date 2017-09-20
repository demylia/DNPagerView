//
//  PagerView.swift
//  DNPagerView
//
//  Created by Dmitry.Tihonov on 09/19/2017.
//  Copyright (c) 2017 Dmitry.Tihonov. All rights reserved.
//

import UIKit

public protocol PagerViewDelegate: class {
    
    func didOpen()
    func didClose()
    func didSelectNumber(_ number: Int)
}

extension UIView {
    func addShadow(){
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
    }
}

public class PagerView: UIView {
    
    static var controlColor = UIColor.defaultColor
    var collectionView: UICollectionView!
    let pagerButton = TriangleButton()
    
    public var numberOfItemsInSection = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    var selectedNumberOfPage = 1
    private var totalPages = 1
    var indexPathOfDefaultSelectedCell: IndexPath?
    public var isPagerOpened = false
    public weak var delegate:PagerViewDelegate?
    
    
    //MARK: - Geometry
    var collectionViewWidth: CGFloat {
        get {
            return collectionView.frame.size.width
        }
        set {
            collectionView.frame.size.width = newValue
        }
    }
    
    private var originX: CGFloat {
        return width - pagerButton.frame.size.width
    }
    
    private var width: CGFloat {
        return (superview?.frame.width ?? 20) - 10
    }
    var height: CGFloat = 35
    
    var offsetX: CGFloat = 6
    var cornerRadius: CGFloat = 3
    
    //MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup(){
        
        let frame = CGRect(x: 0, y: 0, width: 100, height: height)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.alpha = 0
        addShadow()
        layer.cornerRadius = cornerRadius
        collectionView.dataSource = self
        collectionView.delegate = self
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionView.register(PagerCVCell.self, forCellWithReuseIdentifier: "pagerCell")
        addSubview(collectionView)
        
        pagerButton.layer.cornerRadius = cornerRadius
        addSubview(pagerButton)
        pagerButton.backgroundColor = PagerView.controlColor
        pagerButton.addTarget(self, action: #selector(openClosePages), for: .touchUpInside)
        
        
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        pagerButton.center.y = bounds.midY
        collectionView.center.y = bounds.midY
        setupLayout()
    }
    
    private func setupLayout(){
        
        self.pagerButton.frame.origin.x = self.isPagerOpened ? self.originX : 0
        self.collectionViewWidth = self.isPagerOpened ? self.pagerButton.frame.minX : 0
        self.frame.size.width = self.isPagerOpened ? self.width : self.pagerButton.frame.size.width
    }
    
    private func setTitle(_ title: String){
        pagerButton.setTitle(title, for: .normal)
        pagerButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        pagerButton.sizeToFit()
        pagerButton.setNeedsDisplay()

    }
    
    public func openPage(_ pageNumber: Int, totalPages: Int){
        
        selectedNumberOfPage = pageNumber
        self.totalPages = totalPages
        setTitle(" \(pageNumber)/\(totalPages) ")
        
        if !isPagerOpened {
            frame.size = pagerButton.frame.size
        }
    }
    
    @objc public func openClosePages(){
        
        guard totalPages > 1 else { return }
        
        if isPagerOpened {
            delegate?.didClose()
        } else {
            delegate?.didOpen()
            collectionView.reloadData()
            //scrollToSelectedPage
            if selectedNumberOfPage - 3 > 1 {
                let indexPath = IndexPath(item: selectedNumberOfPage - 4, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
            }
        }
        
        isPagerOpened = !isPagerOpened
        self.backgroundColor = self.isPagerOpened ? PagerView.controlColor : UIColor.white
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .beginFromCurrentState,
                       animations: {
                        self.collectionView.alpha = self.isPagerOpened ? 1 : 0
                        self.setupLayout()
        }, completion: nil)
    }
}

extension PagerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: height, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pagerCell", for: indexPath) as! PagerCVCell
        cell.delegate = delegate
        let value = indexPath.row + 1
        if value == selectedNumberOfPage {
            cell.reloadAndSelect(value)
            indexPathOfDefaultSelectedCell = indexPath
        } else {
            cell.reload(value)
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = indexPath.row + 1
        guard index != selectedNumberOfPage else { return }
        selectedNumberOfPage = index
        
        if let cell = collectionView.cellForItem(at: indexPath) as? PagerCVCell {
            cell.reloadAndSelect(index)
            delegate?.didSelectNumber(index)
            openClosePages()
        }
        
        if let idx = indexPathOfDefaultSelectedCell {
            collectionView.delegate?.collectionView!(collectionView, didDeselectItemAt: idx)
            indexPathOfDefaultSelectedCell = nil
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? PagerCVCell {
            cell.deselect()
        }
    }
}
