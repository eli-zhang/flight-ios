//
//  HomeView.swift
//  Flight
//
//  Created by Eli Zhang on 5/5/20.
//  Copyright © 2020 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class HomeView: UIViewController {
    
    var imageView: UIImageView!
    var button: UIButton!
    var imageTaken: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        button = UIButton()
        button.layer.cornerRadius = 40
        button.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        button.setImage(UIImage(named: "Camera"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(button)
        
        Sockets.connect(completion: {
            print("connected")
        })
        Sockets.registerImageHandler(imageFunction: { image in
            self.imageView.image = image
        })
        setupPortraitConstraints()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext) in
            let orientation = UIApplication.shared.statusBarOrientation
            if orientation == .landscapeLeft || orientation == .landscapeRight
            {
                self.setupLandscapeConstraints()
            }
            else
            {
                self.setupPortraitConstraints()
            }
        }) { (context: UIViewControllerTransitionCoordinatorContext) in
            // will execute after rotation
        }
    }
    
    func setupPortraitConstraints() {
        imageView.snp.remakeConstraints { (make) -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        button.snp.remakeConstraints { (make) -> Void in
            make.height.width.equalTo(80)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    func setupLandscapeConstraints() {
        imageView.snp.remakeConstraints { (make) -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        button.snp.remakeConstraints { (make) -> Void in
            make.height.width.equalTo(80)
            make.centerY.equalTo(view)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    
    
    @objc func buttonPressed() {
        if !imageTaken {
            Sockets.takePhoto()
        } else {
            Sockets.resumeVideo()
        }
        toggleButtons()
    }
    
    func toggleButtons() {
        if imageTaken {
            imageTaken = false
            UIView.animate(withDuration: 0.3, animations: {
                self.button.backgroundColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
                self.button.setImage(UIImage(named: "Camera"), for: .normal)
            })
        }
        else {
            imageTaken = true
            UIView.animate(withDuration: 0.3, animations: {
                self.button.backgroundColor = UIColor (red: 0.9, green: 0.9, blue: 0.97, alpha: 1)
                self.button.setImage(UIImage(named: "Back"), for: .normal)
            })
        }
    }
}
