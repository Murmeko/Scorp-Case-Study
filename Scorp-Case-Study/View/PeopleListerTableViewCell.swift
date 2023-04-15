//
//  PeopleListerTableViewCell.swift
//  Scorp-Case-Study
//
//  Created by Yiğit Erdinç on 15.04.2023.
//

import UIKit

class PeopleListerTableViewCell: BaseTableViewCell {
  @IBOutlet weak var fullNameLabel: UILabel!

  override func configureCell() {
    guard let cellViewModel = cellViewModel as? PeopleListerCellViewModel else { fatalError("Could not downcast cell view model.") }
    fullNameLabel.text = cellViewModel.fullNameLabelText
  }
}
