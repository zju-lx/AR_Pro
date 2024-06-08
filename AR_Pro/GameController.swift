//
//  GameController.swift
//  AR_Pro
//
//  Created by zjucvglab509 on 2024/6/7.
//

import Foundation
import ARKit

enum GameState : Int {
    case waiting = 0;
    case playing;
    case over;
}

class GameController {
    var timer: Timer?
    var song: Song?
    var state: GameState = .waiting {
        didSet {
            handleGameStateUpdate()
        }
    }
    var nextNoteIndex = 0
    var beatCount = 0
    
    init() {
        song = getSong()
        state = .waiting
    }
    
    private func handleGameStateUpdate() {
        switch state {
        case .waiting:
            timer?.invalidate()
            print("game waiting")
            break
        case .playing:
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(run), userInfo: nil, repeats: true)
            print("game playing")
            break
        case .over:
            timer?.invalidate()
            print("over")
            break
        }
    }
    
    @objc func run() {
        print("bee")
        if nextNoteIndex < (song?.notes.count)! {
            var nextNote = song?.notes[nextNoteIndex]
            while nextNote?.start == beatCount {
                print("play note " + String(nextNoteIndex))
                nextNoteIndex += 1
                if nextNoteIndex == song?.notes.count {
                    break
                }
                nextNote = song?.notes[nextNoteIndex]
            }
        }
        beatCount += 1
        if beatCount == song?.length {
            state = .over
            timer?.invalidate()
        }
    }
    
    func startGame() {
        beatCount = 0;
        nextNoteIndex = 0;
        state = .playing
    }
}
