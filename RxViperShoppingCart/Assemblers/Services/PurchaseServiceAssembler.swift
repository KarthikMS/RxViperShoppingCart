//
//  PurchaseServiceAssembler.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 12/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

class PurchaseServiceAssembler {
	static func createInstance() -> PurchaseService {
		PurchaseServiceImpl()
	}
}
