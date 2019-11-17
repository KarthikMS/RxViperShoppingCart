//
//  ItemTableViewCellPresenter.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 15/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift
import RxCocoa

class ItemTableViewCellPresenter: ItemTableViewCellPresenterObservablesForViewProvider, ItemTableViewCellPresenterObservablesForInteractorProvider {
	// MARK: - Dependencies
	var view: ItemTableViewCellObservablesForPresenterProvider! {
		didSet {
			observeView()
		}
	}

	var interactor: ItemTableViewCellInteractor! {
		didSet {
			observeInteractor()
		}
	}

	// MARK: - Subjects for drivers for view
	private let nameLabelSubject = PublishSubject<String>()
	private let costLabelSubject = PublishSubject<String>()
	private let addToCartButtonIsEnabledSubject = PublishSubject<Bool>()
	private let removeFromCartButtonIsEnabledSubject = PublishSubject<Bool>()
	private let itemCountLabelSubject = PublishSubject<String>()

	// MARK: - Subject for observables for interactor
	private let addItemToCartSubject = PublishSubject<Void>()
	private let removeItemFromCartSubject = PublishSubject<Void>()

	// MARK: - Util
	private let disposeBag = DisposeBag()

	func observeView() {
		let viewObservables = view.observablesForPresenter!

		viewObservables
			.addToCartButtonTapObservable
			.subscribe(addItemToCartSubject)
			.disposed(by: disposeBag)

		viewObservables
			.removeFromCartButtonTapObservable
			.subscribe(removeItemFromCartSubject)
			.disposed(by: disposeBag)
	}

	func observeInteractor() {
		// TODO: Use RxSwift share()
		let interactorObservables = interactor.observablesForPresenter!

		interactorObservables
			.shopItemObservable
			.map { $0.name }
			.subscribe(nameLabelSubject)
			.disposed(by: disposeBag)

		interactorObservables
			.shopItemObservable
			.map { "Rs. \($0.cost)" }
			.subscribe(costLabelSubject)
			.disposed(by: disposeBag)

		interactorObservables
			.numberOfItemsInCartObservable
			.map { $0 < MaxNumberOfCartItemsOfAKind }
			.subscribe(addToCartButtonIsEnabledSubject)
			.disposed(by: disposeBag)

		interactorObservables
			.numberOfItemsInCartObservable
			.map { $0 != 0 }
			.subscribe(removeFromCartButtonIsEnabledSubject)
			.disposed(by: disposeBag)

		interactorObservables
			.numberOfItemsInCartObservable
			.map { String($0) }
			.subscribe(itemCountLabelSubject)
			.disposed(by: disposeBag)
	}
}

// MARK: - ItemTableViewCellPresenterObservablesForViewProvider
extension ItemTableViewCellPresenter {
	var observablesForView: ItemTableViewCellPresenterObservablesForView! {
		ItemTableViewCellPresenterObservablesForView(
			nameLabelDriver: nameLabelSubject.asDriver(onErrorJustReturn: "Item"),
			costLabelDriver: costLabelSubject.asDriver(onErrorJustReturn: "0.0"),
			addToCartButtonIsEnabledDriver: addToCartButtonIsEnabledSubject.asDriver(onErrorJustReturn: false),
			removeFromCartButtonIsEnabledDriver: removeFromCartButtonIsEnabledSubject.asDriver(onErrorJustReturn: false),
			itemCountLabelDriver: itemCountLabelSubject.asDriver(onErrorJustReturn: "0")
		)
	}
}

// MARK: - ItemTableViewCellPresenterObservablesForInteractorProvider
extension ItemTableViewCellPresenter {
	var observablesForInteractor: ItemTableViewCellPresenterObservablesForInteractor! {
		ItemTableViewCellPresenterObservablesForInteractor(
			dequedObservable: view.observablesForPresenter.dequedObservable,
			addItemToCartObservable: addItemToCartSubject,
			removeItemToCartObservable: removeItemFromCartSubject
		)
	}
}
