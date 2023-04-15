//
//  PeopleListerViewModel.swift
//  Scorp-Case-Study
//
//  Created by Yiğit Erdinç on 15.04.2023.
//

import Foundation

enum PeopleListerViewModelPaginationType {
  case initial, next, refresh
}

class PeopleListerViewModel {
  private var cellViewModels: [[BaseCellViewModelProtocol]] = []

  private var isDebouncing = false
  private var isFetching = false
  private var pagesToFetch: String? = nil

  private let timeToWait = 10.0

  var reloadData: (() -> Void)?
  var hideEmptyView: (() -> Void)?
  var endRefreshControl: (() -> Void)?
}

extension PeopleListerViewModel {
  func fetchPeople(for paginationType: PeopleListerViewModelPaginationType) {
    if !isDebouncing && !isFetching {
      debugPrint("Begining to fetch people list.")
      DataSource.fetch(next: pagesToFetch) { [weak self] fetchResponse, fetchError in
        guard let self = self else { self?.isFetching = false; return }
        self.isFetching = true
        guard let fetchResponse else { self.handleFetchError(fetchError); return }
        if !fetchResponse.people.isEmpty { hideEmptyView?() }
        switch paginationType {
        case .initial, .refresh:
          self.cellViewModels = [parse(people: fetchResponse.people)]; pagesToFetch = fetchResponse.next
        case .next:
          self.cellViewModels.append(parse(people: fetchResponse.people)); pagesToFetch = fetchResponse.next
        }
        self.reloadData?()
        self.endRefreshControl?()
        self.isFetching = false
        debugPrint("Done fetching people list.")
      }
    } else if isFetching {
      debugPrint("Already fetching people list.")
    } else if isDebouncing {
      debugPrint("Debouncing due to server error.")
    }
  }

  private func handleFetchError(_ fetchError: FetchError?) {
    guard let fetchError else { debugPrint("Data source broke"); return }
    debugPrint("Error fetching, cause:")
    debugPrint(fetchError.errorDescription)

    isDebouncing = true
    isFetching = false

    DispatchQueue.main.asyncAfter(deadline: .now() + timeToWait) { [weak self] in
      guard let self = self else { return }
      debugPrint("Waited for \(timeToWait) seconds.")
      self.isDebouncing = false
      self.fetchPeople(for: .next)
    }
  }
}

extension PeopleListerViewModel {
  private func parse(people: [Person]) -> [BaseCellViewModelProtocol] {
    var cellViewModelList: [BaseCellViewModelProtocol] = []
    people.forEach { personModel in
      cellViewModelList.append(PeopleListerCellViewModel(personModel: personModel))
    }
    return cellViewModelList
  }
}

extension PeopleListerViewModel {
  func numberOfSections() -> Int {
    return cellViewModels.count
  }

  func numberOfRowsIn(section: Int) -> Int {
    return cellViewModels[section].count
  }

  func getCellViewModel(for indexPath: IndexPath) -> BaseCellViewModelProtocol {
    return cellViewModels[indexPath.section][indexPath.row]
  }
}
