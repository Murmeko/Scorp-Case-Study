//
//  PeopleListerEmptyView.swift
//  Scorp-Case-Study
//
//  Created by Yiğit Erdinç on 15.04.2023.
//

import UIKit

class PeopleListerEmptyView: UIView {
  lazy var titleLabel = UILabel()

  init() {
    super.init(frame: .zero)
    setupTitleLabel()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupTitleLabel() {
    titleLabel.text = "No one here :)"

    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
}
