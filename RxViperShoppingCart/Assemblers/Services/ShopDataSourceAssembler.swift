//
//  ShopDataSourceAssembler.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 11/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

class ShopDataSourceAssembler {
	static var shared: ShopDataSource {
		ShopDataSourceImpl()
	}
}
