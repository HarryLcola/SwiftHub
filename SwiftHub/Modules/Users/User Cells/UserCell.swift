//
//  UserCell.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class UserCell: DetailedTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.cornerRadius = 25
    }

    func bind(to viewModel: UserCellViewModel) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.detail.drive(detailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.imageUrl.drive(leftImageView.rx.imageURL).disposed(by: rx.disposeBag)
        viewModel.imageUrl.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.leftImageView.hero.id = url.absoluteString
            }
        }).disposed(by: rx.disposeBag)
    }
}
