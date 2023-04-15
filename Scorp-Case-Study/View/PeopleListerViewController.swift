//
//  PeopleListerViewController.swift
//  Scorp-Case-Study
//
//  Created by Yiğit Erdinç on 15.04.2023.
//

import UIKit

class PeopleListerViewController: UITableViewController {
  @IBOutlet var peopleListerTableView: UITableView!

  private lazy var emptyView = PeopleListerEmptyView()

  private let viewModel = PeopleListerViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    insertEmptyView()
    registerTableViewCells()
    bindViewModel()
    setupRefreshControl()
    viewModel.fetchPeople(for: .initial)
  }
}

extension PeopleListerViewController {
  private func insertEmptyView() {
    view.addSubview(emptyView)
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    emptyView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    emptyView.heightAnchor.constraint(equalToConstant: 150).isActive = true
  }

  private func registerTableViewCells() {
    peopleListerTableView.register(UINib(nibName: String(describing: PeopleListerTableViewCell.self), bundle: nil),
                                   forCellReuseIdentifier: String(describing: PeopleListerTableViewCell.self))
  }

  private func bindViewModel() {
    viewModel.reloadData = reloadData()
    viewModel.hideEmptyView = hideEmptyView()
    viewModel.endRefreshControl = endRefreshControl()
  }

  private func setupRefreshControl() {
    peopleListerTableView.refreshControl?.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
  }

  @objc private func refreshControlAction() {
    viewModel.fetchPeople(for: .refresh)
  }
}

extension PeopleListerViewController {
  private final func hideEmptyView() -> () -> Void {
    return { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.emptyView.isHidden = true
      }
    }
  }

  private final func reloadData() -> () -> Void {
    return { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.peopleListerTableView.reloadData()
      }
    }
  }

  private final func endRefreshControl() -> () -> Void {
    return { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.peopleListerTableView.refreshControl?.endRefreshing()
      }
    }
  }
}

extension PeopleListerViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRowsIn(section: section)
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellViewModel = viewModel.getCellViewModel(for: indexPath)
    guard let tableViewCell = peopleListerTableView.dequeueReusableCell(withIdentifier: String(describing: cellViewModel.cellType),
                                                                        for: indexPath) as? BaseTableViewCell else { fatalError("Could not dequeue reusable cell") }
    tableViewCell.cellViewModel = cellViewModel
    tableViewCell.configureCell()
    return tableViewCell
  }

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.section == (tableView.numberOfSections - 1) && indexPath.row == peopleListerTableView.numberOfRows(inSection: indexPath.section) - 1 {
      viewModel.fetchPeople(for: .next)
    }
  }
}
