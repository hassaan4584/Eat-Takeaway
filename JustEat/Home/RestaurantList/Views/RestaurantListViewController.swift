//
//  RestaurantListViewController.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/22/22.
//

import UIKit

typealias RestaurantListDatasource = UITableViewDiffableDataSource<Int, Restaurant>
typealias RestaurantListSnapshot = NSDiffableDataSourceSnapshot<Int, Restaurant>

class RestaurantListViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {

    let restaurantListViewModel: RestaurantListViewModelProtocol
    private var dataSource: UITableViewDiffableDataSource<Int, Restaurant>?

    private let activityIndicator: UIActivityIndicatorView
    let searchController: UISearchController

    @IBOutlet weak var restaurantListTableview: UITableView!
    @IBOutlet weak var emptyRestultsTitleLabel: UILabel!

    // MARK: - Initializations
    static func createViewController(restaurantListVM: RestaurantListViewModelProtocol) -> RestaurantListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = storyboard.instantiateViewController(identifier: String(describing: self)) { aCoder in
            return RestaurantListViewController(restaurantListVM: restaurantListVM, coder: aCoder)
        }
        return listVC
    }

    init?(restaurantListVM: RestaurantListViewModelProtocol, coder: NSCoder) {
        self.restaurantListViewModel = restaurantListVM
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        self.searchController = UISearchController(searchResultsController: nil)
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        self.bind(to: self.restaurantListViewModel)
    }

    private func setupViews() {
        // Screen Title
        self.title = self.restaurantListViewModel.screenTitle
        // Activity Indicator
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.center = self.view.center
        // Search Controller
        self.setupSearchController()
        // Empty Results Message
        self.emptyRestultsTitleLabel.text = self.restaurantListViewModel.emptyDataTitle
        // Restaurants Tableview
        self.configureDataSource()
    }

    // MARK: - Search Controller
    /// Adding SearchController in the navigation item of this VC
    private func setupSearchController() {
        self.searchController.searchBar.delegate = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = restaurantListViewModel.searchBarPlaceholderText
        navigationItem.searchController = self.searchController
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        self.restaurantListViewModel.didSearch(query: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.restaurantListViewModel.didCancelSearch()
    }

    // MARK: - UITableview
    /// This function is to create Tableview cells as per need.
    private func configureDataSource() {
        let dataSource = RestaurantListDatasource(tableView: self.restaurantListTableview) {
            (tableview: UITableView, indexPath: IndexPath, restaurant: Restaurant) -> UITableViewCell? in
            guard let cell = tableview.dequeueReusableCell(withIdentifier: RestaurantListCell.cellIdentifier, for: indexPath) as? RestaurantListCell else { fatalError() }
            cell.setCellData(restaurant)
            return cell
        }
        self.dataSource = dataSource
        self.restaurantListTableview.delegate = self
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - ViewModel Bindings
    private func bind(to viewModel: RestaurantListViewModelProtocol) {
        viewModel.openRestaurants.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] isLoading in self?.updateLoading(isLoading) }
        viewModel.error.observe(on: self) { [weak self] errorMessage in self?.showError(errorMessage) }
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery($0) }
    }

    /// This function acts to update RestaurantList and hide error messages when needed.
    private func updateItems() {
        var snapshot = RestaurantListSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(self.restaurantListViewModel.openRestaurants.value)
        dataSource?.apply(snapshot, animatingDifferences: true)
        self.emptyRestultsTitleLabel.text = self.restaurantListViewModel.emptyDataTitle
        self.emptyRestultsTitleLabel.isHidden = !self.restaurantListViewModel.isEmpty
        self.restaurantListTableview.isHidden = self.restaurantListViewModel.isEmpty
    }

    /// Based on `shouldShowLoader`, this function will show/hide loader
    private func updateLoading(_ shouldShowLoader: Bool) {
        if shouldShowLoader {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }

    /// When user searches a query, we want to re-set  query in the searchbar
    private func updateSearchQuery(_ query: String) {
        searchController.isActive = false
        searchController.searchBar.text = query
    }

    /// When Backed returns error or restaurants are not found, show information to user
    /// - Parameter errorMessage: The message to be shown to user
    private func showError(_ errorMessage: String) {
        guard !errorMessage.isEmpty else { return }
        self.emptyRestultsTitleLabel.text = errorMessage
        self.emptyRestultsTitleLabel.isHidden = false
        self.restaurantListTableview.isHidden = true
    }

}
