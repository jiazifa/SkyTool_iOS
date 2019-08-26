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
        self.startIndicator()
        self.controller.onReload.delegate(on: self) { (weakSelf, Void) in
            weakSelf.stopIndicator()
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
        let refreshItem = UIBarButtonItem.init(barButtonSystemItem: .refresh,
                                               target: self,
                                               action: #selector(refreshAction))
        self.navigationItem.rightBarButtonItems = [rightItem, refreshItem]
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.register(UINib.init(nibName: "RssListCell", bundle: nil),
                           forCellReuseIdentifier: RssListCell.reuseIdentifier)
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
    
    @objc func refreshAction() {
        controller.load()
        tableView.scrollToTop()
    }
}

extension RssListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controller.rsses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rss = self.controller.rsses[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RssListCell.reuseIdentifier) as? RssListCell else { fatalError() }
        cell.rssTitleLabel.text = rss.title
        if let imgUrl = rss.coverImgUrl {
            cell.coverImageView.setImageWith(imgUrl, options: [.allowInvalidSSLCertificates])
        } else {
            cell.coverImageView.image = nil
        }
        if let date = rss.publishedDate {
            let formatter = DateFormatter.init()
            formatter.locale = Locale.current
            formatter.dateFormat = "MM-dd HH:mm"
            let timeString = formatter.string(from: date)
            cell.updatelabel.text = "时间：\(timeString)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rss = controller.rsses[indexPath.row]
        if rss.coverImgUrl != nil {
            return 100
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let rss = self.controller.rsses[indexPath.row]
        controller.read(rss)
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
