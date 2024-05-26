//
//  Program.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/30/24.
//

import UIKit

struct Program {
    var image: UIImage
    var title: String = ""
    var rank: Int = 0
    var channel: String = ""
    var rating: Float = 0.0
}

extension Program {
    static var main: [Self] {
        [Program(image: .program1),
         Program(image: .program2),
         Program(image: .program3),
         Program(image: .program4),
         Program(image: .program5)]
    }
    
    static var recommend: [Self] {
        [Program(image: .program1, title: "너의 이름은"),
         Program(image: .program2, title: "시그널"),
         Program(image: .program3, title: "해리포터"),
         Program(image: .program4, title: "반지의 제왕"),
         Program(image: .program5, title: "스즈메의 문단속")]
    }
    
    static var paramounts: [Self] {
        [Program(image: .program1, title: "너의 이름은"),
         Program(image: .program2, title: "시그널"),
         Program(image: .program3, title: "해리포터"),
         Program(image: .program4, title: "반지의 제왕"),
         Program(image: .program5, title: "스즈메의 문단속")]
    }
    
    static var mostViewed: [Self] {
        [Program(image: .program1, title: "너의 이름은", rank: 1, channel: "OCN", rating: 18.7),
         Program(image: .program2, title: "시그널", rank: 2, channel: "tvn", rating: 18.7),
         Program(image: .program3, title: "해리포터", rank: 3, channel: "OCN", rating: 18.7),
         Program(image: .program4, title: "반지의 제왕", rank: 4, channel: "OCN", rating: 18.7),
         Program(image: .program5, title: "스즈메의 문단속", rank: 5, channel: "OCN", rating: 18.7)]
    }
    
    static var longLogo: [Self] {
        [Program(image: .doosanWhiteLogo),
         Program(image: .doosanBlackLogo),
         Program(image: .doosanWhiteLogo),
         Program(image: .doosanBlackLogo),
         Program(image: .doosanWhiteLogo),
         Program(image: .doosanBlackLogo)]
    }
}
