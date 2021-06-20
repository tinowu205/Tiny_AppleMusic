//
//  SongModel.swift
//  AppleMusic
//
//  Created by tino又想吃肉了 on 2021/6/19.
//

import Foundation
struct SongModel : Equatable{
    let songName : String
    let singerName : String
    let path : String
    let albumImage : String
    
    init(_ song:String,_ singer:String,_ path:String,albumImage:String){
        self.songName = song
        self.singerName = singer
        self.path = path
        self.albumImage = albumImage
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.songName == rhs.songName && lhs.singerName == rhs.singerName {
            return true
        }else{
            return false
        }
    }
}
