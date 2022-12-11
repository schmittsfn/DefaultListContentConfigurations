//
//  ViewController.swift
//  DefaultListContentConfigurations
//
//  Created by Stefan Schmitt on 11/12/2022.
//

import SwiftUI
import UIKit

final class AppearanceSidebarViewController: UIViewController {

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
            case sidebarCell
            case sidebarSubtitleCell
            case accompaniedSidebarCell
            case accompaniedSidebarSubtitleCell
            case sidebarHeader
        }
        
        case example(ListContentConfiguration, Contact)
        case description(String)
    }
    
    private typealias Section = ListSection
    private typealias Row = ListRow
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    private let rows: [ListRow] = [
        .example(.sidebarCell, Contact()),
        .description(".sidebarCell"),
        .example(.sidebarSubtitleCell, Contact()),
        .description(".sidebarSubtitleCell"),
        .example(.accompaniedSidebarCell, Contact()),
        .description(".accompaniedSidebarCell"),
        .example(.accompaniedSidebarSubtitleCell, Contact()),
        .description(".accompaniedSidebarSubtitleCell"),
        .example(.sidebarHeader, Contact()),
        .description(".sidebarHeader"),
    ]
    
    private weak var collectionView: UICollectionView!
    private var datasource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Appearance.sidebar"
        view.backgroundColor = .systemBackground
        configureViewHierarchy()
        configureDataSource()
        loadData()
    }

    private func configureViewHierarchy() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
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
        
        let sidebarCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Contact> { cell, _, item in
            var configuration = UIListContentConfiguration.sidebarCell()
            configuration.text = item.name
            configuration.secondaryText = item.surname
            configuration.image = item.image
            cell.contentConfiguration = configuration
            cell.backgroundConfiguration = .listSidebarCell()
        }
        
        let sidebarSubtitleCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Contact> { cell, _, item in
            var configuration = UIListContentConfiguration.sidebarSubtitleCell()
            configuration.text = item.name
            configuration.secondaryText = item.surname
            configuration.image = item.image
            cell.contentConfiguration = configuration
            cell.backgroundConfiguration = .listSidebarCell()
        }
        
        let accompaniedSidebarCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Contact> { cell, _, item in
            var configuration = UIListContentConfiguration.accompaniedSidebarCell()
            configuration.text = item.name
            configuration.secondaryText = item.surname
            configuration.image = item.image
            cell.contentConfiguration = configuration
            cell.backgroundConfiguration = .listSidebarCell()
        }
        
        let accompaniedSidebarSubtitleCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Contact> { cell, _, item in
            var configuration = UIListContentConfiguration.accompaniedSidebarSubtitleCell()
            configuration.text = item.name
            configuration.secondaryText = item.surname
            configuration.image = item.image
            cell.contentConfiguration = configuration
            cell.backgroundConfiguration = .listAccompaniedSidebarCell()
        }
        
        let sidebarHeaderRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Contact> { cell, _, item in
            var configuration = UIListContentConfiguration.sidebarHeader()
            configuration.text = item.name
            configuration.secondaryText = item.surname
            configuration.image = item.image
            cell.contentConfiguration = configuration
            cell.backgroundConfiguration = .listSidebarHeader()
        }
        
        datasource = DataSource(collectionView: collectionView) { collectionView, indexPath, identifier -> UICollectionViewCell in

            switch identifier {
            case .example(let configType, let contact):
                switch configType {
                case .sidebarCell:
                    return collectionView.dequeueConfiguredReusableCell(using: sidebarCellRegistration, for: indexPath, item: contact)
                case .sidebarSubtitleCell:
                    return collectionView.dequeueConfiguredReusableCell(using: sidebarSubtitleCellRegistration, for: indexPath, item: contact)
                case .accompaniedSidebarCell:
                    return collectionView.dequeueConfiguredReusableCell(using: accompaniedSidebarCellRegistration, for: indexPath, item: contact)
                case .accompaniedSidebarSubtitleCell:
                    return collectionView.dequeueConfiguredReusableCell(using: accompaniedSidebarSubtitleCellRegistration, for: indexPath, item: contact)
                case .sidebarHeader:
                    return collectionView.dequeueConfiguredReusableCell(using: sidebarHeaderRegistration, for: indexPath, item: contact)
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

