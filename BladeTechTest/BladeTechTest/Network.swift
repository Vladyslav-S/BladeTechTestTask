//
//  Network.swift
//  BladeTechTest
//
//  Created by Vladyslav Savonik on 12.09.2024.
//

import Foundation
import AppsFlyerLib
import AdSupport

class Network {

    func sendRequestWithIDs(url: URL, advertisingId: String, appsFlyerDeviceId: String, conversionData: [AnyHashable: Any]) {
        guard let url = URL(string: "\(url)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "advertisingId": advertisingId,
            "appsFlyerDeviceId": appsFlyerDeviceId,
            "conversionData": conversionData
        ]

        // MARK: - JSON Serializer

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error: cannot create JSON from requestBody")
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "No data")")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
            }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
}
