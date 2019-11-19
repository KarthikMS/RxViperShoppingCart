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


class CartTests: XCTestCase {
	private var cart = Cart()
	private let disposeBag = DisposeBag()

    override func setUp() {
		cart = Cart()
	}

	func testInitialState() {
		let totalNumberOfItemsObservableSink = BehaviorSubject<Int>(value: -1)
		cart.totalNumberOfItemsObservable
			.subscribe(totalNumberOfItemsObservableSink)
			.disposed(by: disposeBag)

		let isEmptyEventCountSubject = BehaviorSubject<Int>(value: 0)
		cart.isEmptyObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { () in
				isEmptyEventCountSubject.onNext(isEmptyEventCountSubject.forcedValue + 1)
			})
			.disposed(by: disposeBag)

		XCTAssert(cart.items.isEmpty)
		XCTAssertEqual(totalNumberOfItemsObservableSink.forcedValue, 0)
		XCTAssertEqual(isEmptyEventCountSubject.forcedValue, 1)
	}
}
