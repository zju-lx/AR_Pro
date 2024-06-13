//
//  TableViewController.swift
//  AR_Pro
//
//  Created by zjucvglab509 on 2024/6/13.
//

import Foundation
import UIKit

class MusicViewController: UITableViewController {
        
        var musicList: [Song] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            updateMusicList()
        }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            updateMusicList()
            tableView.reloadData()
        }
        
    func updateMusicList() {
        musicList.removeAll()
        musicList.append(getSong(songName: "LittleStar"))
        musicList.append(Song(id: 1, name: "RememberMe", difficulty: 1, speed: 80, notes: [], pre: 0, length: 0))
        musicList.append(Song(id: 2, name: "Ob-La-Di, Ob-La-Da", difficulty: 3, speed: 80, notes: [], pre: 0, length: 0))
        musicList.append(Song(id: 3, name: "Yesterday", difficulty: 2, speed: 80, notes: [], pre: 0, length: 0))
        musicList.append(Song(id: 4, name: "LetItBe", difficulty: 4, speed: 80, notes: [], pre: 0, length: 0))
        musicList.append(Song(id: 5, name: "HeyJude", difficulty: 3, speed: 80, notes: [], pre: 0, length: 0))
        musicList.append(Song(id: 6, name: "Imagine", difficulty: 2, speed: 80, notes: [], pre: 0, length: 0))
        musicList.append(Song(id: 7, name: "YesterdayOnceMore", difficulty: 1, speed: 80, notes: [], pre: 0, length: 0))
    }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return musicList.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableCell", for: indexPath) as! MusicTableCell
            
            cell.song = musicList[indexPath.row]
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You selected cell #\(indexPath.row)!")
            let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            gameViewController.setSongName(songName: musicList[indexPath.row].name)
            self.navigationController?.pushViewController(gameViewController, animated: false)
        }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
        
        override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 80
        }
        
        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = .systemBlue
            
            let label = UILabel()
            label.text = "Music List"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            label.frame = CGRect(x: 20, y: 20, width: 200, height: 30)
            
            headerView.addSubview(label)
            
            return headerView
        }
        
}
