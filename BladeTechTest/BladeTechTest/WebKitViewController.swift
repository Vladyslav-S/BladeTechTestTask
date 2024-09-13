//
//  WebKitViewController.swift
//  BladeTechTest
//
//  Created by Vladyslav Savonik on 13.09.2024.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {

    var urlString: String?

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.scrollView.isScrollEnabled = true
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        loadTheUrl()
    }

    private func loadTheUrl() {
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            self.webView.frame = CGRect(origin: CGPoint.zero, size: size)
        }, completion: nil)
    }
}
