//
//  MainViewController.swift
//  ios_akakce_cs
//
//  Created by İhsan Akbay on 11.03.2025.
//

import Combine
import UIKit

class MainViewController: UIViewController {
    // MARK: - Properties

    private let viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No products available"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HorizontalProductCell.self, forCellWithReuseIdentifier: HorizontalProductCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .secondaryLabel
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private lazy var verticalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(VerticalProductCell.self, forCellWithReuseIdentifier: VerticalProductCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModelToUI()
        viewModel.fetchProducts()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupVerticalCollectionViewLayout()
        setupHorizontalCollectionViewLayout()
    }

    // MARK: - Setup

    private func setupVerticalCollectionViewLayout() {
        if let layout = verticalCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = (view.frame.width - 16 * 3) / 2
            layout.itemSize = CGSize(width: width, height: width * 1.5)
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            verticalCollectionView.collectionViewLayout.invalidateLayout()
        }
    }

    private func updateVerticalCollectionViewLayout() {
        setupVerticalCollectionViewLayout()

        let numberOfItems = viewModel.verticalProducts.count
        let numberOfColumns = 2 // Based on your layout
        let numberOfRows = ceil(Double(numberOfItems) / Double(numberOfColumns))
        let width = (view.frame.width - 16 * 3) / 2
        let itemHeight = width * 1.5

        let flowLayout = verticalCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let totalHeight = CGFloat(numberOfRows) * itemHeight +
            CGFloat(max(0, numberOfRows - 1)) * flowLayout.minimumLineSpacing +
            flowLayout.sectionInset.top + flowLayout.sectionInset.bottom

        verticalCollectionView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.isActive = false
            }
        }

        verticalCollectionView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        view.layoutIfNeeded()
    }

    private func setupHorizontalCollectionViewLayout() {
        if let layout = horizontalCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: view.frame.width, height: 140)
            horizontalCollectionView.collectionViewLayout.invalidateLayout()
        }
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Products"

        view.addSubviews(scrollView, emptyStateLabel, activityIndicator)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubviews(horizontalCollectionView, pageControl, verticalCollectionView)

        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            horizontalCollectionView.heightAnchor.constraint(equalToConstant: 140),

            pageControl.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30),

            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bindViewModelToUI() {
        viewModel.$horizontalProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                guard let self else { return }
                self.horizontalCollectionView.reloadData()
                self.pageControl.numberOfPages = products.count
                self.pageControl.currentPage = 0
                self.handleEmptyState()
            }
            .store(in: &cancellables)

        viewModel.$verticalProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.verticalCollectionView.reloadData()
                self.updateVerticalCollectionViewLayout()
                self.handleEmptyState()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.emptyStateLabel.isHidden = true
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.handleEmptyState()
                }
            }
            .store(in: &cancellables)

        viewModel.$error
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
    }

    private func showError(_ error: NetworkRequestError) {
        let alert = UIAlertController(title: "Error", message: "Failed to load products", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func handleEmptyState() {
        if !viewModel.isLoading && viewModel.horizontalProducts.isEmpty && viewModel.verticalProducts.isEmpty {
            emptyStateLabel.isHidden = false
            scrollView.isHidden = true
        } else {
            emptyStateLabel.isHidden = true
            scrollView.isHidden = false
        }
    }
}

// MARK: - Extensions

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case horizontalCollectionView:
            return viewModel.horizontalProducts.count
        case verticalCollectionView:
            return viewModel.verticalProducts.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case horizontalCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalProductCell.identifier, for: indexPath) as? HorizontalProductCell else {
                return UICollectionViewCell()
            }
            let product = viewModel.horizontalProducts[indexPath.item]
            cell.configure(with: product)
            return cell

        case verticalCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalProductCell.identifier, for: indexPath) as? VerticalProductCell else {
                return UICollectionViewCell()
            }
            let product = viewModel.verticalProducts[indexPath.item]
            cell.configure(with: product)
            return cell

        default:
            return UICollectionViewCell()
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var product: Product

        if collectionView == horizontalCollectionView {
            product = viewModel.horizontalProducts[indexPath.item]
        } else {
            product = viewModel.verticalProducts[indexPath.item]
        }
        let detailVC = DetailViewController(viewModel: DetailViewModel(productId: product.id))
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === horizontalCollectionView {
            let pageWidth = scrollView.frame.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            pageControl.currentPage = currentPage
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == horizontalCollectionView {
            return CGSize(width: collectionView.frame.width, height: 140)
        } else {
            let width = (view.frame.width - 16 * 3) / 2
            return CGSize(width: width, height: width * 1.5)
        }
    }
}
