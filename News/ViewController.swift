//
//  ViewController.swift
//  News
//
//  Created by Ella on 3/20/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topStoriesLabel: UILabel!
    @IBOutlet weak var newsTableView: UITableView!

    var newsArticles = [Article]()
    let apiManager = APIManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register all the cells
        newsTableView.register(UINib(nibName: "OneImageCell", bundle: nil), forCellReuseIdentifier: "OneImageCell")
        newsTableView.register(UINib(nibName: "TwoImageCell", bundle: nil), forCellReuseIdentifier: "TwoImageCell")
        newsTableView.register(UINib(nibName: "SidewaysCell", bundle: nil), forCellReuseIdentifier: "SidewaysCell")

        // Configure table view cell row height
        newsTableView.rowHeight = UITableViewAutomaticDimension


        apiManager.getArticles(for: "techcrunch", and: "top", completion: { newsArticles in
            self.newsArticles = newsArticles
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        })
    }

    // MARK: - IBActions
    @IBAction func pressedTopButton(_ sender: UIButton) {
        apiManager.getArticles(for: "techcrunch", and: "top", completion: { newsArticles in
            self.newsArticles = newsArticles
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        })
    }
    @IBAction func pressedLatestButton(_ sender: UIButton) {
        apiManager.getArticles(for: "techcrunch", and: "latest", completion: { newsArticles in
            self.newsArticles = newsArticles
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        })
    }
}

// MARK: - Table View Data Source

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArticles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        if row == 0 {
            guard let oneImageCell = tableView.dequeueReusableCell(withIdentifier: "OneImageCell", for: indexPath) as? OneImageCell else {
                return UITableViewCell()
            }
            oneImageCell.titleLabel.text = "\(newsArticles[row].title)"
            oneImageCell.authorLabel.text = "\(newsArticles[row].author)"
            oneImageCell.articleImageView.image = newsArticles[row].convertStringToURLToImage(from: newsArticles[row].imageURL)

            return oneImageCell
        } else {
            guard let sidewaysCell = tableView.dequeueReusableCell(withIdentifier: "SidewaysCell", for: indexPath) as? SidewaysCell else {
                return UITableViewCell()
            }
            sidewaysCell.topTitleLabel.text = "\(newsArticles[row].title)"
            sidewaysCell.authorLabel.text = "\(newsArticles[row].author)"
            sidewaysCell.topArticleImage.image = newsArticles[row].convertStringToURLToImage(from: newsArticles[row].imageURL)
            return sidewaysCell
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        go(toArticle: newsArticles[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let articleViewController = segue.destination as? ArticleViewController else { return }
        if let theArticle = sender as? Article {
            articleViewController.article = theArticle
        }
    }

    // MARK: - Helper Functions
    func go(toArticle article: Article) {
        self.performSegue(withIdentifier: "toArticle", sender: article)
    }
}
