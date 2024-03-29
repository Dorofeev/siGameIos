//
//  UILoadableView.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 30.07.2022.
//

import UIKit

class UILoadableView: UIView {
    
    @IBOutlet weak fileprivate var view: UIView!
    
    var nibName: String { return String(describing: type(of: self)) } //Not exists, must override
    let bundle = Bundle.main //can override in specific cases
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    
    private func xibSetUp() {
        // setup the view from .xib
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        // grabs the appropriate bundle
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView ?? UIView()
        return view
    }
}
