//
//  ItemTableViewCellProtocols.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 17/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift
import RxCocoa

struct ItemTableViewCellInteractorObservablesForPresenter {
	let shopItemObservable: Observable<ShopItem>
	let numberOfItemsInCartObservable: Observable<Int>
}

protocol ItemTableViewCellInteractorObservablesForPresenterProvider {
	var observablesForPresenter: ItemTableViewCellInteractorObservablesForPresenter! { get }
}

// TODO: Rename Observables to Drivers
struct ItemTableViewCellPresenterObservablesForView {
	let nameLabelDriver: Driver<String>
	let costLabelDriver: Driver<String>
	let addToCartButtonIsEnabledDriver: Driver<Bool>
	let removeFromCartButtonIsEnabledDriver: Driver<Bool>
	let itemCountLabelDriver: Driver<String>
}

struct ItemTableViewCellPresenterObservablesForInteractor {
	let dequedObservable: Observable<ShopItem>
	let addItemToCartObservable: Observable<Void>
	let removeItemToCartObservable: Observable<Void>
}

protocol ItemTableViewCellPresenterObservablesForInteractorProvider {
	var observablesForInteractor: ItemTableViewCellPresenterObservablesForInteractor! { get }
}

protocol ItemTableViewCellPresenterObservablesForViewProvider {
	var observablesForView: ItemTableViewCellPresenterObservablesForView! { get }
}

protocol ItemTableViewCellObservablesForPresenterProvider {
	var observablesForPresenter: ItemTableViewCellObservablesForPresenter! { get }
}

struct ItemTableViewCellObservablesForPresenter {
	let dequedObservable: Observable<ShopItem>
	let addToCartButtonTapObservable: Observable<Void>
	let removeFromCartButtonTapObservable: Observable<Void>
}
