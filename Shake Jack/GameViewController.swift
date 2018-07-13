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
    
    var savedDeck: Deck?
    var totalTime = 52
    var cardsLeft = 52
    var currentScore = 0

    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var howManyCardUsed: UILabel!
    @IBOutlet weak var currentCardView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
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
                    score.text = "\(currentScore)"
                } else {
                    currentScore -= 1
                    score.text = "\(currentScore)"
                }
            }
        }
    }
    

    
        override func viewWillAppear(_ animated: Bool) {
        guard let card = savedDeck?.drawCard() else {
            return
        }
       currentCardView.imageFromURL(urlString: card.image)
        
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
        } else {
            endTimer()
        }
    }
    
    func nextCard() {
        let card = savedDeck?.drawCard()
        currentCardView.imageFromURL(urlString: card?.image)
    }
    
    //MARK: ACTIONS
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
    }
    
    @IBAction func nextCardDrawn(_ sender: Any) {
        nextCard()
    }
    
}

