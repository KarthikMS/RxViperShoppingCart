//
//  ShopViewController.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 13/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShopViewController: UIViewController, ShopViewProtocol {
	// MARK: - Properties
	var presenter: ShopViewToPresenterProtocol!

	// MARK: - Subjects for observables for presenter
	private let cartButtonTapSubject = PublishSubject<Void>()

	// MARK: - IBOutlets
	@IBOutlet private weak var cartButton: UIBarButtonItem!
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var totalCostLabel: UILabel!

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

// MARK: - View Life Cycle
extension ShopViewController {
	override func viewDidLoad() {
        super.viewDidLoad()

		provideInputsToPresenter()
    }
}

// MARK: - Setup
private extension ShopViewController {
	func provideInputsToPresenter() {
		cartButton.rx.tap
			.subscribe(cartButtonTapSubject)
			.disposed(by: disposeBag)
	}
}

// MARK: - ShopViewObservablesForPresenterProvider
extension ShopViewController {
	var observablesForPresenter: ShopViewObservablesForPresenter! {
		ShopViewObservablesForPresenter(
			cartButtonObservable: cartButtonTapSubject
		)
	}
}
