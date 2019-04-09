//
//  SettingsViewController.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/28.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var tableView: UITableView = UITableView.tableView()
    
    private let footerContainer = UIView()
    
    public var footer: UIView? {
        didSet {
            updateFooter(footer)
        }
    }
    
    final fileprivate class IntrinsicSizeTableView: UITableView {
        override var intrinsicContentSize: CGSize {
            return CGSize(width: UIView.noIntrinsicMetric,
                          height: self.contentSize.height)
        }
    }
    
    init(style: UITableView.Style) {
        tableView = IntrinsicSizeTableView(frame: .zero, style: style)
        super.init(nibName: nil, bundle: nil)
        self.edgesForExtendedLayout = UIRectEdge()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }

    override func viewDidLoad() {
        self.createTableView()
        self.createConstraints()
        self.view.backgroundColor = UIColor.clear
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    private func createTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56
        tableView.bounces = false
        view.addSubview(tableView)
        view.addSubview(footerContainer)
    }
    
    private func createConstraints() {
        tableView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        tableView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        tableView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        
        footerContainer.autoPinEdge(.top, to: .bottom, of: tableView)
        footerContainer.autoPinEdge(.left, to: .left, of: tableView)
        footerContainer.autoPinEdge(.right, to: .right, of: tableView)
        
    }
    
    private func updateFooter(_ newFooter: UIView?) {
        footer?.removeFromSuperview()
        guard let newFooter = newFooter else { return }
        footerContainer.addSubview(newFooter)
        footerContainer.autoPinEdge(.top, to: .top, of: newFooter)
        footerContainer.autoPinEdge(.left, to: .left, of: newFooter)
        footerContainer.autoPinEdge(.right, to: .right, of: newFooter)
        footerContainer.autoPinEdge(.bottom, to: .bottom, of: newFooter)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - UITableViewDelegate & UITableViewDelegate
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        fatalError("Subclasses need to implement this method")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fatalError("Subclasses need to implement this method")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Subclasses need to implement this method")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
}

class SettingsTableViewController: SettingsViewController {
    let group: SettingsInternalGroupCellDescriptorType
    
    required init(group: SettingsInternalGroupCellDescriptorType) {
        self.group = group
        super.init(style: group.style == .plain ? .plain : .grouped)
        self.title = group.title.localizedUppercase
        
        self.group.items.flatMap { return $0.cellDescriptors }.forEach {
            if let groupDescriptor = $0 as? SettingsGroupCellDescriptorType {
                groupDescriptor.viewController = self
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.view.backgroundColor = UIColor.white
    }
    
    func setupTableView() {
        let rect = CGRect.init(x: 0, y: 0, width: 0, height: 0.1)
        let headerView = UIView.init(frame: rect)
        self.tableView.tableHeaderView = headerView
        let allCellTypes: [SettingsTableCell.Type] = [SettingsTableCell.self,
                                                      SettingsStaticTextTableCell.self,
                                                      SettingsGroupCell.self,
                                                      SettingsToggleCell.self,
                                                      SettingsValueCell.self,
                                                      SettingsTextCell.self,
                                                      SettingsButtonCell.self]
        
        for aClass in allCellTypes {
            tableView.register(aClass, forCellReuseIdentifier: aClass.reuseIdentifier)
        }
    }
    
    // MARK: - UITableViewDelegate & UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.group.visibleItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDescriptor = self.group.visibleItems[section]
        return sectionDescriptor.visibleCellDescriptors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionDescriptor = self.group.visibleItems[(indexPath as NSIndexPath).section]
        let cellDescriptor = sectionDescriptor.visibleCellDescriptors[(indexPath as NSIndexPath).row]
        let identifier = type(of: cellDescriptor).cellType.reuseIdentifier
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                    for: indexPath) as? SettingsTableCell {
            cell.descriptor = cellDescriptor
            cellDescriptor.featureCell(cell)
            cell.isFirst = indexPath.row == 0
            return cell
        }
        
        fatalError("Cannot dequeue cell for index path \(indexPath) and cellDescriptor \(cellDescriptor)")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionDescriptor = self.group.visibleItems[(indexPath as NSIndexPath).section]
        let property = sectionDescriptor.visibleCellDescriptors[(indexPath as NSIndexPath).row]
        property.select(.none)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionDescriptor = self.group.visibleItems[section]
        return sectionDescriptor.header
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let sectionDescriptor = self.group.visibleItems[section]
        return sectionDescriptor.footer
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerFooterView = view as? UITableViewHeaderFooterView {
            headerFooterView.textLabel?.textColor = UIColor(white: 0.5, alpha: 0.4)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let headerFooterView = view as? UITableViewHeaderFooterView {
            headerFooterView.textLabel?.textColor = UIColor(white: 0.5, alpha: 0.4)
        }
    }
    
}
