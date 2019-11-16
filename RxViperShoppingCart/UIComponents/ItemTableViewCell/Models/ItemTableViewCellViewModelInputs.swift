//
//  ItemTableViewCellViewModelInputs.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 11/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

struct ItemTableViewCellViewModelInputs {
	let addItemToCartEventSubject: PublishSubject<Void>
	let removeItemFromCartEventSubject: PublishSubject<Void>
}
