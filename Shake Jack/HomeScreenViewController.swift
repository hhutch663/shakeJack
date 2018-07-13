//
//  HomeScreenViewController.swift
//  Shake Jack
//
//  Created by Heidi Hutchinson on 6/29/18.
//  Copyright © 2018 Heidi Hutchinson. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    @IBOutlet weak var gameStart: UIButton!
    
    var savedDeck: Deck? {
        didSet {
                gameStart.isEnabled = savedDeck != nil
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        gameStart.isEnabled = false
        
        self.fetchDeck()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let alertController = UIAlertController(title: "Welcome to Shake Jack!", message: "There are just a few rules to remember for this game: \n\n1. The cards will begin once you press the button to begin.  \n\n2. When you see a Jack, shake your phone.  DO NOT SLAP YOUR PHONE!  We don't want to have to replace any broken screens here.  \n\n3. When you shake your phone, if you shake it for a Jack, you will get a point on your score.  If you shake your phone for a card other than a Jack, you will lose points.  \n\n4. When the game is over, you can press the shuffle deck button to get a new deck and play again.  \n\n5. Please enjoy the game!",
                preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Let's Shake Some Jacks!", style: .default) { (action: UIAlertAction!) in
            
            //Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame", let vc = segue.destination as? GameViewController {
            vc.savedDeck = self.savedDeck
            vc.startTimer()
        }
    }
    
}
extension HomeScreenViewController {
    func fetchDeck() {
        let url = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=52")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            do {
                if let data = data, let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let deckDict = response["cards"] as? [[String: Any]] {
                        DispatchQueue.main.sync {
                            let deck = Deck.init(AppDelegate.context, json: deckDict)
                            self.savedDeck = deck
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
    }
}
