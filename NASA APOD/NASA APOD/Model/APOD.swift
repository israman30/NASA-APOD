//
//  APOD.swift
//  NASA APOD
//
//  Created by Israel Manzo on 3/20/25.
//

import Foundation

struct APOD: Decodable {
    let date: String
    let explanation: String
    let hdurl: String?
    let media_type: String
    let title: String
    let url: String?
}
