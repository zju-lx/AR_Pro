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
    var length: Int          // 歌曲的长度
}

extension Song {
    struct Note: Codable {
        var track: Int      // 音符出现在第几轨道
        var start: Int      // 音符出现的时间
        var duration: Int   // 音符持续的时间
    }
}

// parse a json to get a song
func getSong() -> Song {
    let json = """
{
    "speed": 80,
    "notes": [
        {
            "track": 0,
            "start": 0,
            "duration": 4
        },
        {
            "track": 1,
            "start": 4,
            "duration": 4
        },
        {
            "track": 2,
            "start": 8,
            "duration": 4
        },
        {
            "track": 3,
            "start": 12,
            "duration": 4
        }
    ],
    "length": 16
}
"""
    let jsonData = json.data(using: .utf8)!
    let decoder = JSONDecoder()
    let song = try! decoder.decode(Song.self, from: jsonData)
    return song
}

func getSong(fileName: String) -> Song {
    let path = Bundle.main.path(forResource: fileName, ofType: "json")
    let url = URL(fileURLWithPath: path!)
    let jsonData = try! Data(contentsOf: url)
    let decoder = JSONDecoder()
    let song = try! decoder.decode(Song.self, from: jsonData)
    return song
}
