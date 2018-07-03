//
//  RepositoryViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/1/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RepositoryViewController: TableViewController {

    var viewModel: RepositoryViewModel!

    lazy var repoTitleLabel: Label = {
        let view = Label(style: .style123)
        view.textAlignment = .center
        return view
    }()

    lazy var ownerImageView: SlideImageView = {
        let view = SlideImageView()
        view.cornerRadius = 40
        return view
    }()

    lazy var headerStackView: StackView = {
        let imageView = View()
        imageView.addSubview(self.ownerImageView)
        self.ownerImageView.snp.makeConstraints({ (make) in
            make.top.centerX.centerY.equalToSuperview()
            make.size.equalTo(80)
        })
        let subviews: [UIView] = [imageView, self.repoTitleLabel]
        let view = StackView(arrangedSubviews: subviews)
        view.distribution = .equalCentering
        view.spacing = self.inset
        return view
    }()

    lazy var headerView: View = {
        let view = View(frame: CGRect(x: 0, y: 0, width: 0, height: 120))
        view.backgroundColor = .primary()
        let subviews: [UIView] = [self.headerStackView]
        let stackView = StackView(arrangedSubviews: subviews)
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().inset(self.inset)
            make.centerX.centerY.equalToSuperview()
        })
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableHeaderView = headerView
        tableView.addSubview(refreshControl)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let pullToRefresh = Observable.of(Observable.just(()),
                                          refreshControl.rx.controlEvent(.valueChanged).asObservable()).merge()
        let input = RepositoryViewModel.Input(detailsTrigger: pullToRefresh)
        let output = viewModel.transform(input: input)

        output.fetching.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)

        output.name.drive(repoTitleLabel.rx.text).disposed(by: rx.disposeBag)

        output.imageUrl.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.ownerImageView.setSources(sources: [url])
                self?.ownerImageView.hero.id = url.absoluteString
            }
        }).disposed(by: rx.disposeBag)

        output.error.drive(onNext: { (error) in
            logError("\(error)")
        }).disposed(by: rx.disposeBag)
    }
}
