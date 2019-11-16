//
//  ShopDataSource.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 11/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

protocol ShopDataSource {
	func fetchItems()
	var itemsObservable: Observable<[ShopItem]> { get }
}
