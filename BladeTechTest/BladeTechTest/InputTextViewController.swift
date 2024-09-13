//
//  WebViewController.swift
//  BladeTechTest
//
//  Created by Vladyslav Savonik on 12.09.2024.
//

import UIKit
import WebKit
import AdSupport
import AppsFlyerLib
import AppTrackingTransparency

class InputTextViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    var conversionData: [AnyHashable: Any]?
    let network = Network()

    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(urlTextField)
        view.addSubview(searchButton)
        super.viewDidLoad()
    }

    private lazy var urlTextField: UITextField = {
        let urlTextField = UITextField()
        urlTextField.frame = CGRect(x: 20, y: 100, width: view.frame.size.width - 100, height: 40)
        urlTextField.borderStyle = .roundedRect
        urlTextField.delegate = self
        urlTextField.placeholder = "Enter URL here"
        return urlTextField
    }()

    private lazy var searchButton: UIButton = {
        let searchButton = UIButton()
        searchButton.frame = CGRect(x: view.frame.size.width - 70, y: 100, width: 50, height: 40)
        searchButton.setTitle("Go", for: .normal)
        searchButton.backgroundColor = .blue
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return searchButton
    }()

    @objc func searchButtonTapped() {
        if let urlString = urlTextField.text, let url = URL(string: urlString) {
            fetchAndSendIdentifiersWith(url: url)
            showWebViewController(_with: url)
        }
        urlTextField.resignFirstResponder()
    }

    private func showWebViewController(_with url: URL) {
        let webKitViewController = WebKitViewController()
        webKitViewController.modalPresentationStyle = .fullScreen
        webKitViewController.urlString = "\(url)"
        show(webKitViewController, sender: self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonTapped()
        return true
    }

    private func fetchAndSendIdentifiersWith(url: URL) {
        let url = url
        let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        print("Advertising ID: \(advertisingId)")
        let appsFlyerDeviceId = AppsFlyerLib.shared().getAppsFlyerUID()
        print("Appsflyer Device ID: \(appsFlyerDeviceId)")
        //        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        AppsFlyerLib.shared().start { (dictionary, error) in
            if let conversionData = dictionary {
                self.network.sendRequestWithIDs(url: url, advertisingId: advertisingId, appsFlyerDeviceId: appsFlyerDeviceId, conversionData: conversionData)
            } else if let error = error {
                print("Error fetching Appsflyer Conversion Data: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - AppsFlyerLibDelegate

    //this method is called when AppsFlyer receives conversion data for an installd app
    private func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        print("Conversion Data Success: \(conversionInfo)")
        self.conversionData = conversionInfo
    }

    private func onConversionDataFail(_ error: Error) {
        print("Conversion Data Failed: \(error.localizedDescription)")
    }

    private func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
        print("On App Open Attribution: \(attributionData)")
    }

    private func onAppOpenAttributionFailure(_ error: Error) {
        print("On App Open Attribution Failure: \(error.localizedDescription)")
    }
}
