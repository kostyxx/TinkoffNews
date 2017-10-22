//
//  ViewController.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 07/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class NewsHeadersVC: UIViewController, AlertViewControllerProtocol  {
    
    var presenter:NewsHeaderPresenter!
    
    private var cellId:String!
    
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        update()
    }
    
    private func setupUI() {
        refreshControl.addTarget(self, action: #selector(update), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        cellId = NewsHeaderCell.reuseIdentifier
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier:cellId)
        navigationItem.title = "Tinkoff News"
    }
    
    @objc func update(_ sender: Any? = nil) {
        presenter.updateFetchNewsHeaders { [weak self] error in
            self?.refreshControl.endRefreshing()
            if let  error = error {
                self?.presentAlert(error: error)
            }
            
        }
    }
}

extension NewsHeadersVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:cellId, for: indexPath) as! NewsHeaderCell
        let (title, dateString) = presenter.newsHeader(indexPath: indexPath)
        cell.configureCell(title:title, date:dateString)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.selectElement(indexPath:indexPath)
    }
}


extension NewsHeadersVC: FetchingResultDelegate {
    func willUpdate() {
        self.tableView.beginUpdates()
    }
    func endUpdate() {
        self.tableView.endUpdates()
    }
    func insertObject(element:AnyObject, indexPath:IndexPath) {
        self.tableView.insertRows(at: [indexPath], with: .fade)
    }
}
