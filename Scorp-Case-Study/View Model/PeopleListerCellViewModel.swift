//
//  PeopleListerCellViewModel.swift
//  Scorp-Case-Study
//
//  Created by Yiğit Erdinç on 15.04.2023.
//

import Foundation

protocol PeopleListerCellViewModelProtocol: BaseCellViewModelProtocol {
  var fullNameLabelText: String { get }
}

class PeopleListerCellViewModel: BaseCellViewModel, PeopleListerCellViewModelProtocol {
  var fullNameLabelText: String

  init(personModel: Person) {
    fullNameLabelText = personModel.fullName + " (\(personModel.id))"
    super.init()
    cellType = PeopleListerTableViewCell.self
  }
}
