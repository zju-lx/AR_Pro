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
    var noteNodes: [Int:NoteNode] = [:]
    
    let interval = 4        // 规定音符从轨道的一端滑动到另一端消耗 4 个 time beat
    var beatCount = 0
    
    var score = 0;
    
    var timer: Timer?
    
    init(worldPlane: SCNNode, viewController: ViewController) {
        song = getSong()
        self.worldPlane = worldPlane
        self.viewController = viewController
    }
    
    func startGame() {
        beatCount = 0;
        nextNoteIndex = 0;
        score = 0;
        
        song = getSong(songName: "LittleStar")
        let AudioSource = AudioPlayer.load(name: "LittleStar");
        AudioPlayer.play(source: AudioSource, on: worldPlane!)
        
        timer = Timer.scheduledTimer(timeInterval: (60.0 / Double(song!.speed)) / 4.0, target: self, selector: #selector(step), userInfo: nil, repeats: true)
    }
    
    @objc private func step() {
//        print("bee")
        if nextNoteIndex < (song?.notes.count)! {
            var nextNote = song?.notes[nextNoteIndex]
            while nextNote!.start - 4 == beatCount {
//                print("play note " + String(nextNoteIndex))
                noteNodes[nextNote!.id] = NoteNode(song: song!, note: nextNote!)
                worldPlane?.addChildNode(noteNodes[nextNote!.id]!)
                nextNoteIndex += 1
                if nextNoteIndex == song?.notes.count {
                    break
                }
                nextNote = song?.notes[nextNoteIndex]
            }
        }
        updateNodes()
        judge()
        beatCount += 1
        if beatCount >= song!.length && noteNodes.isEmpty {
//            print("over.")
            timer!.invalidate()
            viewController!.state = .gameOver
        }
    }
    
    private func judge() {
        let buttonNodes = viewController!.buttonNodes
        for (id, noteNode) in noteNodes {
            if noteNode.hitCheck(timeBeat: beatCount) {
                print("note " + String(id) + " hit")
                if buttonNodes[noteNode.note!.track]!.isHit() {
                    score += 1
                    viewController!.showMessage("Score: \(score)")
                }
            }
        }
    }
    
    private func updateNodes() {
        for (id, noteNode) in noteNodes {
            switch noteNode.state {
            case .waiting:
//                print("note " + String(id) + ": waiting")
                noteNode.activate()
                break;
            case .moving:
//                print("note " + String(id) + ": moving")
                break;
            case .reached:
//                print("note " + String(id) + ": reached")
                noteNode.removeFromParentNode()
                noteNodes.removeValue(forKey: id)
                break;
            }
        }
    }
}
