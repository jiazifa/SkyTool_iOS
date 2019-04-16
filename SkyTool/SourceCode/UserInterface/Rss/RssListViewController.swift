//
//  RssListViewController.swift
//  SkyTool
//
//  Created by tree on 2019/4/13.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

class RssListViewController: UIViewController {
    
    var controller: RssController = RssController()
    
    let tableView: UITableView = UITableView.tableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.background
        self.createSubViews()
        self.createConstraints()
        self.controller.onReload.delegate(on: self) { (weakSelf, Void) in
            DispatchQueue.main.async { weakSelf.tableView.reloadData() }
        }
        self.controller.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    func createSubViews() {
        let rightItem = UIBarButtonItem.init(barButtonSystemItem: .add,
                                             target: self,
                                             action: #selector(addNewRssLinnk))
        self.navigationItem.rightBarButtonItem = rightItem
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func createConstraints() {
        self.tableView.autoPinEdgesToSuperviewEdges()
    }
    
    @objc(addNewRssLink)
    func addNewRssLinnk() {
        let alert = UIAlertController(title: "alert.rss.add.title".localized, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in }
        alert.addAction(UIAlertAction(title: "alert.comfirm.action".localized, style: .default, handler: { (_) -> Void in
            if let textField = alert.textFields?.first {
                self.controller.addRssLink(textField.text)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension RssListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controller.rsses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        let rss = self.controller.rsses[indexPath.row]
        cell.textLabel?.text = rss.title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = UIColor.textBlack
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let rss = self.controller.rsses[indexPath.row]
        let task = WebControllerTask.init(rss.title,
                                          url: rss.link)
        task.viewController = self
        task.execute()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.controller.rsses.count  - 4 {
            self.controller.next()
        }
    }
}
