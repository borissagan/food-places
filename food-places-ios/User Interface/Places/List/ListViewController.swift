//
//  ListViewController.swift
//  food-places-ios
//
//  Created by Boris Sagan on 11.02.2021.
//

import UIKit
import Combine
import SwiftUI

class ListViewController: UIViewController {
  @IBOutlet private weak var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier<Place>>!
  var viewModel: PlacesViewModel?
  private var cancellables = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupCollectionView()
    bindData()
  }
  
  private func setupNavigationBar() {
    navigationItem.title = "Food Places"
  }
  
  private func bindData() {
    viewModel?.$places
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (places) in
        guard let strongSelf = self else { return }
        strongSelf.applySnapshot(with: places)
      }
      .store(in: &cancellables)
  }
  
  private func applySnapshot(with places: [Place]) {
    var snaphot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier<Place>>()
    let section = SectionIdentifier()
    snaphot.appendSections([section])
    snaphot.appendItems(places.map { ItemIdentifier(value: $0) }, toSection: section)
    self.dataSource.apply(snaphot)
  }
}

extension ListViewController {
  private func setupCollectionView() {
    collectionView.collectionViewLayout = createLayout()
    collectionView.delegate = self
    collectionView.register(ListCell.nib, forCellWithReuseIdentifier: ListCell.identifier)
    configureDataSource()
  }
  
  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier<Place>>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ListCell.identifier,
        for: indexPath) as! ListCell
      cell.configure(with: item.value)
      return cell
    })
  }
  
  func createLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
}

extension ListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = dataSource.itemIdentifier(for: indexPath)
    let detailsView = PlaceDetailsView(place: item!.value)
    present(UIHostingController(rootView: detailsView), animated: true)
  }
}
