//
//  GameController.swift
//  AR_Pro
//
//  Created by zjucvglab509 on 2024/6/7.
//

import Foundation
import ARKit

class GameController {
    
    var worldPlane: SCNNode?
    var viewController: ViewController?
    
    var song: Song?
    var nextNoteIndex = 0
    
    let interval = 4        // 规定音符从轨道的一端滑动到另一端消耗 4 个 time beat
    var beatCount = -4
    
    var timer: Timer?
    
    init(worldPlane: SCNNode, viewController: ViewController) {
        song = getSong()
        self.worldPlane = worldPlane
        self.viewController = viewController
    }
    
    func startGame() {
        beatCount = -4;
        nextNoteIndex = 0;
        timer = Timer.scheduledTimer(timeInterval: (60.0 / Double(song!.speed)) / 4.0, target: self, selector: #selector(step), userInfo: nil, repeats: true)
    }
    
    @objc private func step() {
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
            print("over.")
            timer!.invalidate()
            viewController!.state = .gameOver
        }
    }

}
