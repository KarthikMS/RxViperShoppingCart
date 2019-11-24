//
//  ItemDetailRouterProtocol.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 24/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit

protocol ItemDetailRouterProtocol: ModuleRouter {
	static func createInstance() -> UIViewController
}
