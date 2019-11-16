//
//  ItemTableViewCellPresenter.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 15/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift
import RxCocoa

// TODO: Rename Observables to Drivers
struct ItemTableViewCellPresenterObservablesForView {
	let nameLabelDriver: Driver<String>
	let costLabelDriver: Driver<String>
	let addToCartButtonIsEnabledDriver: Driver<Bool>
	let removeFromCartButtonIsEnabledDriver: Driver<Bool>
	let itemCountLabelDriver: Driver<String>
}

struct ItemTableViewCellPresenterObservablesForInteractor {
	let addItemToCartObservable: Observable<Void>
	let removeItemToCartObservable: Observable<Void>
}

protocol ItemTableViewCellPresenterObservablesForInteractorProvider {
	var observablesForInteractor: ItemTableViewCellPresenterObservablesForInteractor! { get }
}

protocol ItemTableViewCellPresenterObservablesForViewProvider {
	var observablesForView: ItemTableViewCellPresenterObservablesForView! { get }
}

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
		view.observablesForPresenter
			.addToCartButtonTapObservable
			.subscribe(addItemToCartSubject)
			.disposed(by: disposeBag)

		view.observablesForPresenter
			.removeFromCartButtonTapObservable
			.subscribe(removeItemFromCartSubject)
			.disposed(by: disposeBag)
	}

	func observeInteractor() {
		// TODO: Use RxSwift share()
		interactor.observablesForPresenter
			.itemObservable
			.map { $0.name }
			.subscribe(nameLabelSubject)
			.disposed(by: disposeBag)

		interactor.observablesForPresenter
			.itemObservable
			.map { "Rs. \($0.cost)" }
			.subscribe(costLabelSubject)
			.disposed(by: disposeBag)

		interactor.observablesForPresenter
			.numberOfItemsInCartObservable
			.map { $0 <= MaxNumberOfCartItemsOfAKind }
			.subscribe(addToCartButtonIsEnabledSubject)
			.disposed(by: disposeBag)

		interactor.observablesForPresenter
			.numberOfItemsInCartObservable
			.map { $0 != 0 }
			.subscribe(removeFromCartButtonIsEnabledSubject)
			.disposed(by: disposeBag)

		interactor.observablesForPresenter
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
			addItemToCartObservable: addItemToCartSubject,
			removeItemToCartObservable: removeItemFromCartSubject
		)
	}
}
