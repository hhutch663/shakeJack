//
//  ViewController.swift
//  Shake Jack
//
//  Created by Heidi Hutchinson on 6/25/18.
//  Copyright © 2018 Heidi Hutchinson. All rights reserved.
//

import UIKit
import CoreData

var countdownTimer: Timer!

class GameViewController: UIViewController {
    
    var cardsLeft: Int {
        return savedDeck?.cards?.count ?? 0
    }
    
    var savedDeck: Deck?
    var totalTime = 52
    var currentScore = 0
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var howManyCardLeft: UILabel!
    @IBOutlet weak var currentCardView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let card = savedDeck?.drawCard() else {
            return
        }
        currentCardView.imageFromURL(urlString: card.image)
        
        
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        guard (savedDeck?.currentCard) != nil else { return }
        if motion == .motionShake {
            if let currentCard = savedDeck?.currentCard {
                if currentCard.value == "JACK" {
                    currentScore += 1
                    score.text = "Score: \(currentScore)"
                } else {
                    currentScore -= 1
                    score.text = "Score: \(currentScore)"
                }
            }
        }
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(totalTime)"
        if totalTime != 0 {
            totalTime -= 1
            nextCard()
            howManyCardLeft.text = "Cards Left: \(cardsLeft)"
        } else {
            endTimer()
            self.restartGameOrDoNothing()
        }
    }
    
    func nextCard() {
        let card = savedDeck?.drawCard()
        currentCardView.imageFromURL(urlString: card?.image)
    }
    
    func restartGameOrDoNothing() {
        let shuffleDeck = UIAlertAction(title: "Yes", style: .default) { (action) in
//            func fetchDeck() {
                let url = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=52")!
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    do {
                        if let data = data, let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let deckDict = response["cards"] as? [[String: Any]] {
                                DispatchQueue.main.sync {
                                    let deck = Deck.init(AppDelegate.context, json: deckDict)
                                    self.savedDeck = deck
                                    self.totalTime = 52
                                    self.startTimer()
                                }
                                print(deckDict)
                            } else {
                                print("broke")
                            }
                        } else {
                            print("broke")
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            
                task.resume()
            
//            }
        }
        
        let doNothing = UIAlertAction(title: "No", style: .default) { (action) in
            return
        }
        let alert = UIAlertController(title: "Game Over", message: "Thank you for playing Shake Jack!  You've finished the game.  Do you want to play again?", preferredStyle: .alert)
        alert.addAction(shuffleDeck)
        alert.addAction(doNothing)
        
        self.present(alert, animated: true)
        
    }
    
    
    
    
    
    //MARK: ACTIONS
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        if button.titleLabel?.text == "Pause" {
            button.setTitle("Play", for: .normal)
            endTimer()
        } else {
            button.setTitle("Pause", for: .normal)
            startTimer()
        }
        
    }
    
    @IBAction func nextCardDrawn(_ sender: Any) {
        nextCard()
    }
    
}








