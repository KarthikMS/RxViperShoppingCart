//
//  ModuleRouter.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 24/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit

protocol ModuleRouter {
	static var mainStoryboard: UIStoryboard { get }
}

extension ModuleRouter {
	static var mainStoryboard: UIStoryboard {
		return UIStoryboard(name: "Main", bundle: Bundle.main)
	}
}
