//
//  CartService.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 11/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

protocol CartService {
	var itemsObservable: Observable<[CartItem]> { get }
	var isEmptyObservable: Observable<Bool> { get }
	func count(of item: ShopItem) -> Int
	func countObservable(of item: ShopItem) -> Observable<Int>
	var totalCostObservable: Observable<Int> { get }
	var totalNumberOfItemsObservable: Observable<Int> { get }

	var items: [CartItem] { get }
	func add(_ item: ShopItem)
	func remove(_ item: ShopItem)
	func empty()
}
