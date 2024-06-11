//
//  Song.swift
//  AR_Pro
//
//  Created by zjucvglab509 on 2024/6/7.
//

import Foundation

struct Song: Codable {
    var speed: Int           // 歌曲的速度
    var notes: [Note]        // 歌曲的音符
    var pre: Int             // 前奏长度（第一个音符的出现时间等于 0）
    var length: Int          // 歌曲的长度
}

extension Song {
    struct Note: Codable {
        var id: Int         // 音符的 id
        var track: Int      // 音符出现在第几轨道
        var start: Int      // 音符出现的时间
        var duration: Int   // 音符持续的时间
    }
}

func getSong(songName: String) -> Song {
    guard let url = Bundle.main.url(forResource: songName, withExtension: "json") else {
        fatalError("Can't find song file")
    }
    print(url)
    
    let jsonData = try? Data(contentsOf: url)
    let decoder = JSONDecoder()
    var song = try? decoder.decode(Song.self, from: jsonData!)
    for i in 0..<song!.notes.count {
        song!.notes[i].start += song!.pre
    }
    return song!
}

// parse a json to get a song
func getSong() -> Song {
    let json = """
{
    "speed": 80,
    "pre": 0,
    "notes": [
        {
            "id": 0,
            "track": 0,
            "start": 0,
            "duration": 4
        },
        {
            "id": 1,
            "track": 1,
            "start": 4,
            "duration": 4
        },
        {
            "id": 2,
            "track": 2,
            "start": 8,
            "duration": 4
        },
        {
            "id": 3,
            "track": 3,
            "start": 12,
            "duration": 4
        }
    ],
    "length": 20
}
"""
    let jsonData = json.data(using: .utf8)!
    let decoder = JSONDecoder()
    let song = try! decoder.decode(Song.self, from: jsonData)
    return song
}
