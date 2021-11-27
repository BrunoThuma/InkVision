//
//  StartScreenViewController.swift
//  InkVision
//
//  Created by Bruno Thuma on 24/11/21.
//

import UIKit

class StartScreenViewController: UIViewController {
    
    private var startScreenView: StartScreenView!

    override func loadView() {
        view = StartScreenView()
        
        view.insetsLayoutMarginsFromSafeArea = false
    }
    
    override func viewDidLoad() {
        startScreenView = (view as! StartScreenView)
        
        startScreenView.addTargetToStartButton(self, action: #selector(startButtonTapped))
        
        super.viewDidLoad()
    }
    
    @objc func startButtonTapped() {
//        let bodyTrackingVC = MotionDetectionViewController()
//        navigationController?.pushViewController(bodyTrackingVC,
//                                                 animated: true)

        let infoVC = InfoViewController()
        present(infoVC,
                animated: true,
                completion: nil)
    }
}
