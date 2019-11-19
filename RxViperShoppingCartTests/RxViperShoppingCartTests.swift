//
//  RxViperShoppingCartTests.swift
//  RxViperShoppingCartTests
//
//  Created by Karthik M S on 13/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import XCTest
import RxSwift
@testable import RxViperShoppingCart

class MockShopPresenter: ShopPresenterObservablesForInteractorProvider {
	let fetchShopItemsSubject = PublishSubject<Void>()
	let emptyCartSubject = PublishSubject<Void>()

	var observablesForInteractor: ShopPresenterObservablesForInteractor! {
		ShopPresenterObservablesForInteractor(
			fetchShopItemsObservable: fetchShopItemsSubject,
			emptyCartObservable: emptyCartSubject
		)
	}
}

class RxViperShoppingCartTests: XCTestCase {
	var shopInteractor: ShopInteractor!
	var cart: CartService!
	var shopDataSource: ShopDataSource!
	var mockShopPresenter: MockShopPresenter!
	var interactorObservablesForPresenter: ShopInteractorObservablesForPresenter!

	let disposeBag = DisposeBag()

    override func setUp() {
		cart = Cart()
		shopDataSource = ShopDataSourceImpl()
		shopInteractor = ShopInteractor(cart: cart, shopDataSource: shopDataSource)
		mockShopPresenter = MockShopPresenter()
		shopInteractor.presenter = mockShopPresenter
		interactorObservablesForPresenter = shopInteractor.observablesForPresenter
    }

	func test1() {
//		let observedCartItems = BehaviorSubject<[CartItem]>(value: [])
//		interactorObservablesForPresenter
//			.cartItemsObservable
//			.subscribe(observedCartItems)
//			.disposed(by: disposeBag)
//
//		XCTAssert(try! observedCartItems.value().isEmpty)
//
//		let itemInCart = try! shopDataSource.itemsObservable.value()[0]
//		cart.add(itemInCart)
//
//		XCTAssertEqual(observedCartItems.forcedValue.count, 1)
//		XCTAssertEqual(observedCartItems.forcedValue[0].shopItem.id, itemInCart.id)
//		XCTAssertEqual(observedCartItems.forcedValue[0].count, 1)
//
//		mockShopPresenter.emptyCartSubject.onNext(())
//
//		XCTAssert(observedCartItems.forcedValue.isEmpty)
	}
}

extension BehaviorSubject {
	var forcedValue: Element {
		try! self.value()
	}
}
