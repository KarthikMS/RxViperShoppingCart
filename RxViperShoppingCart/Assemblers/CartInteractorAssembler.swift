//
//  CartInteractorAssembler.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 18/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

class CartInteractorAssembler {
	private static var _shared: CartInteractor?

	// TODO: Use Swinject containers and remove these args
	static func createInstance() -> CartInteractor {
		if let shared = self._shared {
			return shared
		} else {
			self._shared = CartInteractor(
				shopDataSource: ShopDataSourceAssembler.shared,
				cart: CartServiceAssembler.shared,
				purchaseService: PurchaseServiceImpl()
			)
			return self._shared!
		}
	}
}
