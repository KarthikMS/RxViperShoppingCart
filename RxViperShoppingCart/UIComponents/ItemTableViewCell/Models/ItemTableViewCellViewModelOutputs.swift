//
//  ItemTableViewCellViewModelOutputs.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 11/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

struct ItemTableViewCellViewModelOutputs {
	let itemNameObservable: Observable<String>
	let itemCostObservable: Observable<Int>
	let numberOfItemsObservable: Observable<Int>
}
