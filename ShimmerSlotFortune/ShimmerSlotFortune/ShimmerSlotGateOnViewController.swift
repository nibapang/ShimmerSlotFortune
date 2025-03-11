//
//  GateOnVC.swift
//  ShimmerSlotFortune
//
//  Created by ShimmerSlot Fortune on 2025/3/11.
//


import UIKit

class ShimmerSlotGateOnViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var buttonCollection: [UIButton]!
    @IBOutlet weak var spinButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var matchedCountLabel: UILabel!
    
    let gridSize = 5
    var grid = [[Bool]]()
    let slotImages = ["11", "12", "13", "14", "15", "16", "17", "18", "19", "110"]
    var matchedCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupGrid()
        showGameRules()
        setupPickerView()
        spinButton.isEnabled = false
    }
    
    func showGameRules() {
        let rules = """
        Game Rules:
        1. Tap buttons to open all doors.
        2. Once all doors are open, you can spin the slot.
        3. Match all three slot images to win.
        """
        let alert = UIAlertController(title: "Welcome to GateOn Slot!", message: rules, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func setupGrid() {
        grid = Array(repeating: Array(repeating: true, count: gridSize), count: gridSize) // All doors start as closed
        
        for (index, button) in buttonCollection.enumerated() {
            let row = index / gridSize
            let col = index % gridSize
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.tag = index
            button.imageView?.contentMode = .scaleAspectFill
            updateButtonAppearance(button, isOn: grid[row][col])
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let tag = sender.tag
        let row = tag / gridSize
        let col = tag % gridSize
        
        toggleState(row: row, col: col)
        toggleState(row: row - 1, col: col)
        toggleState(row: row + 1, col: col)
        toggleState(row: row, col: col - 1)
        toggleState(row: row, col: col + 1)
        
        checkForWin()
    }
    
    func toggleState(row: Int, col: Int) {
        guard row >= 0, row < gridSize, col >= 0, col < gridSize else { return }
        let index = row * gridSize + col
        grid[row][col].toggle()
        updateButtonAppearance(buttonCollection[index], isOn: grid[row][col])
    }
    
    func updateButtonAppearance(_ button: UIButton, isOn: Bool) {
        let imageName = isOn ? "close" : "open"
        button.setBackgroundImage(UIImage(named: imageName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
    }
    
    func checkForWin() {
        if grid.allSatisfy({ $0.allSatisfy { !$0 } }) {
            let alert = UIAlertController(title: "You Win!", message: "All doors are open! Spin the slot!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            spinButton.isEnabled = true
        }
    }
    
    func resetGame() {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                grid[row][col] = true // Reset all doors to closed
                let index = row * gridSize + col
                updateButtonAppearance(buttonCollection[index], isOn: grid[row][col])
            }
        }
        spinButton.isEnabled = false
        pickerView.selectRow(0, inComponent: 0, animated: false)
        pickerView.selectRow(0, inComponent: 1, animated: false)
        pickerView.selectRow(0, inComponent: 2, animated: false)
    }
    
    @IBAction func resetgame(_ sender: Any) {
        resetGame()
    }
    
    func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func spinSlot(_ sender: UIButton) {
        guard spinButton.isEnabled else {
            let alert = UIAlertController(title: "Cannot Spin", message: "First, open all gates!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let firstIndex = Int.random(in: 0..<slotImages.count)
        let secondIndex = Int.random(in: 0..<slotImages.count)
        let thirdIndex = Int.random(in: 0..<slotImages.count)
        
        pickerView.selectRow(firstIndex, inComponent: 0, animated: true)
        pickerView.selectRow(secondIndex, inComponent: 1, animated: true)
        pickerView.selectRow(thirdIndex, inComponent: 2, animated: true)
        
        if slotImages[firstIndex] == slotImages[secondIndex] && slotImages[secondIndex] == slotImages[thirdIndex] {
            matchedCount += 1
            matchedCountLabel.text = "Matches: \(matchedCount)"
            let alert = UIAlertController(title: "Matched!", message: "You matched all three slots!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    // Picker View DataSource & Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return slotImages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard row < slotImages.count else { return UIView() }
        
        let iconName = slotImages[row]
        let imageView = UIImageView(image: UIImage(named: iconName))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return imageView
    }
}
