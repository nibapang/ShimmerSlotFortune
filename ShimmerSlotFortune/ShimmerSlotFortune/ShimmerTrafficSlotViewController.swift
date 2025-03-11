//
//  TrafficSlotVC.swift
//  ShimmerSlotFortune
//
//  Created by ShimmerSlot Fortune on 2025/3/11.
//


import UIKit
import AVFoundation

class ShimmerTrafficSlotViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var slotPicker: UIPickerView!
    @IBOutlet weak var spinButton: UIButton!
    @IBOutlet weak var trafficLightImageView: UIImageView!
    @IBOutlet weak var matchLabel: UILabel!
    
    // MARK: - Properties
    let slotImages = ["11", "12", "13", "14", "15", "16", "17", "18", "19", "110"]
    let trafficLights = ["light1", "light2", "light3", "light4"]
    var selectedSlotValues = [String]()
    var currentLightIndex = 0
    var maatchedcount = 0 {
        didSet {
            matchLabel.text = "Match: \(maatchedcount)"
         }
    }
    var lightTimer: Timer?
    var soundPlayer: AVAudioPlayer?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slotPicker.dataSource = self
        slotPicker.delegate = self
        showGameRules()
        startTrafficLightSequence()
    }
    
    func showGameRules() {
           let rules = """
           Game Rules:
           1. The traffic light changes randomly.
           2. You can only spin the slot machine when the light is GREEN.
           3. If all three slots match, you win a Match.
           4. The traffic light resets after every spin.
           """
           let alert = UIAlertController(title: "Welcome to Traffic Slot!", message: rules, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lightTimer?.invalidate()
    }
    
    func startTrafficLightSequence() {
        lightTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.5...1.5), target: self, selector: #selector(updateTrafficLight), userInfo: nil, repeats: true)
    }
    
    @objc func updateTrafficLight() {
        guard !trafficLights.isEmpty else { return }
        
        currentLightIndex = Int.random(in: 0..<trafficLights.count)
        trafficLightImageView.image = UIImage(named: trafficLights[currentLightIndex])
        playSound()
        
        if trafficLights[currentLightIndex] != "light4" {
            resetGame()
        }
    }
    
    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: "lightChange", withExtension: "mp3") else {
            print("Error: Sound file not found")
            return
        }
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
            soundPlayer?.play()
        } catch {
            print("Sound error: \(error.localizedDescription)")
        }
    }
    
    func resetGame() {
        DispatchQueue.main.async {
            self.slotPicker.reloadAllComponents()
        }
    }
    
    // MARK: - Actions
    @IBAction func spinButtonTapped(_ sender: UIButton) {
        guard !slotImages.isEmpty, trafficLights[currentLightIndex] == "light4" else {
            return
        }
        
        var results = [String]()
        
        for component in 0..<slotPicker.numberOfComponents {
            let randomRow = Int.random(in: 0..<slotImages.count)
            slotPicker.selectRow(randomRow, inComponent: component, animated: true)
            results.append(slotImages[randomRow])
        }
        
        if results[0] == results[1] && results[1] == results[2] {
            showMatchAlert()
            maatchedcount += 1
        }
    }
    
    func showMatchAlert() {
        let alert = UIAlertController(title: "Match!", message: "All three slots matched!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - PickerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return slotImages.count
    }
    
    // MARK: - PickerView Delegate
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard row < slotImages.count else { return UIView() }
        
        let iconName = slotImages[row]
        let imageView = UIImageView(image: UIImage(named: iconName))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return imageView
    }
}
