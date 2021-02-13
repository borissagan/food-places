//
//  TabBarController.swift
//  food-places-ios
//
//  Created by Boris Sagan on 11.02.2021.
//

import UIKit

class TabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  private func setup() {
    var viewControllers = [UIViewController]()
    
    let sharedViewModel = PlacesViewModel()
    
    let map: MapViewController = UIStoryboard(storyboard: .places).instantiateViewController()
    map.viewModel = sharedViewModel
    let mapItem: UITabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)
    map.tabBarItem = mapItem
    viewControllers.append(map)
    
    let list: ListViewController = UIStoryboard(storyboard: .places).instantiateViewController()
    list.viewModel = sharedViewModel
    let listItem: UITabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.bullet"), tag: 1)
    list.tabBarItem = listItem
    viewControllers.append(list)
    
    viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
    self.viewControllers = viewControllers
  }
}
