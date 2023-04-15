//
//  BaseTableViewCell.swift
//  Scorp-Case-Study
//
//  Created by Yiğit Erdinç on 15.04.2023.
//

import UIKit

protocol BaseTableViewCellProtocol {
  var cellViewModel: BaseCellViewModelProtocol? { get set }
  func configureCell()
}

class BaseTableViewCell: UITableViewCell, BaseTableViewCellProtocol {
  var cellViewModel: BaseCellViewModelProtocol?
  func configureCell() {
    // To be overwritten.
  }
}
