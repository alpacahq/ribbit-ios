//
//  Router.swift
//  Ribbit
//
//  Created by Ahsan Ali on 07/04/2021.
//
import UIKit
protocol Router {
   func route(
      to routeID: String,
      from context: UIViewController,
      parameters: Any?, animated: Bool
   )
}
