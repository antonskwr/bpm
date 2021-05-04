//
//  BaseController.swift
//  Bpm-iphone
//
//  Created by Anton Skvartsou on 27/03/2019.
//  Copyright © 2019 Anton Skvartsou. All rights reserved.
//

import UIKit

typealias BaseController = BaseVC & BaseVCDelegate

protocol BaseVCDelegate {
    func setupBottomButton()
}

class BaseVC: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var bottomButtonConstraints: AnchoredConstraints?
    
    let bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 30)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBottomButtonPressed), for: .touchUpInside)
        return button
    }()
    
    public let coverView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.alpha = 0
        return view
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutStatusBar()
        layoutBottomButton()
        layoutCoverView()
        setupCoverView()
    }
    
    fileprivate func layoutBottomButton() {
        view.addSubview(bottomButton)
        bottomButtonConstraints = bottomButton.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            size: Size(width: nil, height: 70)
        )
        
        switch ScreenService.shared.getSize() {
        case .iPhone4Inch:
            bottomButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 26)
            bottomButtonConstraints?.height?.constant = 64
        case .iPhoneX:
            bottomButtonConstraints?.leading?.constant = 16
            bottomButtonConstraints?.trailing?.constant = -16
            bottomButton.layer.cornerRadius = 16
        case .iPhone678:
            break
        }
    }
    
    fileprivate func layoutCoverView() {
        view.addSubview(coverView)
        coverView.fillSuperview()
    }
    
    @objc func handleBottomButtonPressed() {}
    func layoutStatusBar() {}
    func setupCoverView() {}
}
