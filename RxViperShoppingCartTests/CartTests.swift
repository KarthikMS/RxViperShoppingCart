//
//  CartTests.swift
//  RxViperShoppingCartTests
//
//  Created by Karthik M S on 19/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import XCTest
import RxSwift
@testable import RxViperShoppingCart
import Quick
import Nimble


class CartTests: XCTestCase {
//	private var cart = Cart()
//	private let disposeBag = DisposeBag()
//
//    override func setUp() {
//		cart = Cart()
//	}
//
//	func testInitialState() {
//		let totalNumberOfItemsObservableSink = BehaviorSubject<Int>(value: -1)
//		cart.totalNumberOfItemsObservable
//			.subscribe(totalNumberOfItemsObservableSink)
//			.disposed(by: disposeBag)
//
//		let isEmptyEventCountSubject = BehaviorSubject<Int>(value: 0)
//		cart.isEmptyObservable
//			.observeOn(MainScheduler.instance)
//			.subscribe(onNext: { () in
//				isEmptyEventCountSubject.onNext(isEmptyEventCountSubject.forcedValue + 1)
//			})
//			.disposed(by: disposeBag)
//
//		XCTAssert(cart.items.isEmpty)
//		XCTAssertEqual(totalNumberOfItemsObservableSink.forcedValue, 0)
//		XCTAssertEqual(isEmptyEventCountSubject.forcedValue, 1)
//	}
}

class CartSpec: QuickSpec {
	override func spec() {
		var cart = Cart()
		var disposeBag = DisposeBag()
		let shopItem1 = ShopItem(id: "1", name: "Apple", cost: 10)

		var cartItemsObservableSink = BehaviorSubject<[CartItem]>(value: [])
		var totalNumberOfItemsObservableSink = BehaviorSubject<Int>(value: -1)
		var isCartEmptyObservableSink = BehaviorSubject<Bool>(value: true)

		describe("Cart") {
			beforeEach {
				cart = Cart()

				cartItemsObservableSink = BehaviorSubject<[CartItem]>(value: [])
				totalNumberOfItemsObservableSink = BehaviorSubject<Int>(value: -1)
				isCartEmptyObservableSink = BehaviorSubject<Bool>(value: true)

				cart.itemsObservable
					.subscribe(cartItemsObservableSink)
					.disposed(by: disposeBag)

				cart.totalNumberOfItemsObservable
					.subscribe(totalNumberOfItemsObservableSink)
					.disposed(by: disposeBag)

				cart.isEmptyObservable
					.subscribe(isCartEmptyObservableSink)
					.disposed(by: disposeBag)
			}

			afterEach {
				disposeBag = DisposeBag()
			}

			context("initially") {
				it("is empty") {
					expect(cartItemsObservableSink.forcedValue).to(beEmpty())
					expect(totalNumberOfItemsObservableSink.forcedValue).to(equal(0))
					expect(isCartEmptyObservableSink.forcedValue).to(equal(true))
				}
			}

			context("adding an item") {
				beforeEach {
					cart.add(shopItem1)
				}

				it("is successful") {
					expect(totalNumberOfItemsObservableSink.forcedValue).to(equal(1))
					let cartItems = cartItemsObservableSink.forcedValue
					expect(cartItems.count).to(equal(1))
					guard cartItems.count == 1 else { fail(); return }
					expect(cartItems[0].count).to(equal(1))
					expect(cartItems[0].shopItem.id).to(equal(shopItem1.id))
					expect(isCartEmptyObservableSink.forcedValue).to(equal(false))
				}

				context("and adding the same item again") {
					beforeEach {
						cart.add(shopItem1)
					}

					it("is successful") {
						expect(totalNumberOfItemsObservableSink.forcedValue).to(equal(2))
						let cartItems = cartItemsObservableSink.forcedValue
						expect(cartItems.count).to(equal(1))
						guard cartItems.count == 1 else { fail(); return }
						expect(cartItems[0].count).to(equal(2))
						expect(cartItems[0].shopItem.id).to(equal(shopItem1.id))
						expect(isCartEmptyObservableSink.forcedValue).to(equal(false))
					}

					context("and removing 1 item") {
						beforeEach {
							cart.remove(shopItem1)
						}

						it("is successful") {
							expect(totalNumberOfItemsObservableSink.forcedValue).to(equal(1))
							let cartItems = cartItemsObservableSink.forcedValue
							expect(cartItems.count).to(equal(1))
							guard cartItems.count == 1 else { fail(); return }
							expect(cartItems[0].count).to(equal(1))
							expect(cartItems[0].shopItem.id).to(equal(shopItem1.id))
							expect(isCartEmptyObservableSink.forcedValue).to(equal(false))
						}
					}

					it("and emptying is successful") {
						cart.empty()

						expect(cartItemsObservableSink.forcedValue).to(beEmpty())
						expect(totalNumberOfItemsObservableSink.forcedValue).to(equal(0))
						expect(isCartEmptyObservableSink.forcedValue).to(equal(true))
					}
				}
			}
		}
	}
}

