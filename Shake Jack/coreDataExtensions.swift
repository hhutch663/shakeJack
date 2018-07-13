//
//  coreDataExtensions.swift
//  Shake Jack
//
//  Created by Heidi Hutchinson on 6/29/18.
//  Copyright © 2018 Heidi Hutchinson. All rights reserved.
//

import Foundation
import CoreData

extension Deck {
    convenience init?(_ context: NSManagedObjectContext, json:[[String: Any]]) {
      self.init(context: context)
        var cards:[Card] = []
        for dict in json {
            if let card = Card.init(context, json: dict) {
               cards.append(card)
            }
        }
        self.cards = NSMutableOrderedSet.init(array: cards)
        
    }
    
    func drawCard()->Card? {
        guard let card = cards?.firstObject as? Card else {
            return nil
        }
        let mutableCards = cards?.mutableCopy() as! NSMutableOrderedSet
    
        mutableCards.removeObject(at: 0)
        cards = mutableCards
        
        self.currentCard = card
        
        return card
    }
}
extension Card {
    convenience init?(_ context: NSManagedObjectContext, json:[String: Any]) {
        self.init(context: context)
        guard let image = json["image"] as? String, let value = json["value"] as? String, let suit = json["suit"] as? String else {
            return nil
        }
        self.image = image
        self.value = value
        self.suit = suit
    }
}
