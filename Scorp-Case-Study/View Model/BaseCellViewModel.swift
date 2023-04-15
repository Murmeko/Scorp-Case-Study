//
//  BaseCellViewModel.swift
//  Scorp-Case-Study
//
//  Created by Yiğit Erdinç on 15.04.2023.
//

import UIKit

protocol BaseCellViewModelProtocol {
  var cellType: UITableViewCell.Type { get }
}

class BaseCellViewModel: BaseCellViewModelProtocol {
  var cellType: UITableViewCell.Type = UITableViewCell.self
}
