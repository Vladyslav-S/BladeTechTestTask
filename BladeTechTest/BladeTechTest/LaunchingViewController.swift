//
//  ViewController.swift
//  BladeTechTest
//
//  Created by Vladyslav Savonik on 12.09.2024.
//

import UIKit

class ViewController: UIViewController {
    private let ballView = UIView()
    private var isAnimating = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBall()
        animateBall()
    }

    private func setupBall() {
        ballView.frame = CGRect(x: view.frame.size.width / 2 - 25, y: view.frame.size.height / 2 - 25, width: 50, height: 50)
        ballView.backgroundColor = .red
        ballView.layer.cornerRadius = 25
        view.addSubview(ballView)
    }

    private func animateBall() {
        guard isAnimating else { return }
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.ballView.frame.origin.y -= 50
        })

        let delay: Double = 4.5
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let viewController = InputTextViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }

    deinit {
        isAnimating = false
    }
}
