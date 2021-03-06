//
//  Article.swift
//  News
//
//  Created by Ella on 3/20/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import UIKit

class Article {
    
    var author: String
    var title: String
    var articleURL: String
    var imageURL: String

    init(author: String, title: String, articleURL: String, imageURL: String) {
        self.author = author
        self.title = title
        self.articleURL = articleURL
        self.imageURL = imageURL
    }

    static func create(from dictionary: [String: Any]) -> Article? {
        // get author from json
        guard let author = dictionary["author"] as? String else { return nil }

        // get title
        guard let title = dictionary["title"] as? String else { return nil }

        // get articleURL
        guard let articleURL = dictionary["url"] as? String else { return nil }

        // get imageURL
        guard let imageURL = dictionary["urlToImage"] as? String else { return nil }

        return Article(author: author, title: title, articleURL: articleURL, imageURL: imageURL)
    }

    func convertStringToURLToImage(from string: String) -> UIImage? {
        let url = URL(string: string)
        if let data = try? Data(contentsOf: url!) {
            return UIImage(data: data)
        }
        return nil
    }
}
