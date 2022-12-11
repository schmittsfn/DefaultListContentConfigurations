//
//  ViewController.swift
//  DefaultListContentConfigurations
//
//  Created by Stefan Schmitt on 11/12/2022.
//

import SwiftUI
import UIKit

final class AppearanceGroupedViewController: UIViewController {

    struct Contact: Identifiable, Hashable {
        let id: UUID = UUID()
        let name: String = "Arthur"
        let surname: String = "Dent"
        let image: UIImage = UIImage(systemName: "person")!
    }
    
    private enum ListSection: Int {
        case main
    }
    
    private enum ListRow: Hashable {
        enum ListContentConfiguration: Hashable {
            case groupedHeader
            case groupedFooter
        }
        
        case example(ListContentConfiguration, Contact)
        case description(String)
    }
    
    private typealias Section = ListSection
    private typealias Row = ListRow
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    private let rows: [ListRow] = [
        .example(.groupedHeader, Contact()),
        .description(".groupedHeader"),
        .example(.groupedFooter, Contact()),
        .description(".groupedFooter"),
    ]
    
    private weak var collectionView: UICollectionView!
    private var datasource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Appearance.grouped"
        view.backgroundColor = .systemBackground
        configureViewHierarchy()
        configureDataSource()
        loadData()
    }

    private func configureViewHierarchy() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureDataSource() {
        let descriptionRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, _, item in
            cell.contentConfiguration = UIHostingConfiguration {
                ZStack {
                    Text(item)
                        .font(.caption2)
                        .padding(.horizontal, 2.0)
                }
                .foregroundColor(Color(UIColor.systemBackground))
                .background(Color(UIColor.label))
                .cornerRadius(2.0)
                .padding(.bottom, 2.0)
            }
            cell.backgroundConfiguration = .listPlainCell()
        }

        let groupedHeaderRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Contact> { cell, _, item in
            var configuration = UIListContentConfiguration.groupedHeader()
            configuration.text = item.name
            configuration.secondaryText = item.surname
            configuration.image = item.image
            cell.contentConfiguration = configuration
            cell.backgroundConfiguration = .listGroupedHeaderFooter()
        }
        
        let groupedFooterRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Contact> { cell, _, item in
            var configuration = UIListContentConfiguration.groupedFooter()
            configuration.text = item.name
            configuration.secondaryText = item.surname
            configuration.image = item.image
            cell.contentConfiguration = configuration
            cell.backgroundConfiguration = .listGroupedHeaderFooter()
        }

        datasource = DataSource(collectionView: collectionView) { collectionView, indexPath, identifier -> UICollectionViewCell in
            
            switch identifier {
            case .example(let configType, let contact):
                switch configType {
                case .groupedHeader:
                    return collectionView.dequeueConfiguredReusableCell(using: groupedHeaderRegistration, for: indexPath, item: contact)
                case .groupedFooter:
                    return collectionView.dequeueConfiguredReusableCell(using: groupedFooterRegistration, for: indexPath, item: contact)
                }
            case .description(let string):
                return collectionView.dequeueConfiguredReusableCell(using: descriptionRegistration, for: indexPath, item: string)
            }
        }
    }
    
    private func loadData() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(rows, toSection: .main)
        datasource.applySnapshotUsingReloadData(snapshot)
    }
}

