import UIKit

class KitchenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Constants
    private struct Constants {
        static let foodCardCellIdentifier = "FoodCardCollectionViewCell"
        static let storiesCellIdentifier = "StoriesCollectionViewCell"
        static let foodCardCellHeight: CGFloat = 311
        static let storyCellSize = CGSize(width: 110, height: 120)
    }
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var labelPopularTitle: UILabel!
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    
    // MARK: - Properties
    private let kitchenViewModel = KitchenViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureCollectionView(collectionView, cellType: Constants.foodCardCellIdentifier, showsScrollIndicator: false, cornerRadius: 20)
        configureCollectionView(storiesCollectionView, cellType: Constants.storiesCellIdentifier, showsScrollIndicator: false)
        loadData()
    }
    
    // MARK: - Setup UI
    
    /// Başlangıç ayarlarıyla görünümü yapılandırır.
    private func setupView() {
        view.backgroundColor = .white
        configureHeaderView()
    }
    
    /// Başlık (header) görünümünü başlık, logo, bildirim ve profil görselleri ile yapılandırır.
    private func configureHeaderView() {
        headerView.configure(
            title: "Mutfak",
            logoImage: UIImage(named: "logo") ?? UIImage(),
            notificationImage: UIImage(named: "notification") ?? UIImage(),
            profileImage: UIImage(named: "profileImage") ?? UIImage()
        )
    }
    
    /// Belirtilen collection view'i, hücre tipi, kaydırma göstergesi ve köşe yarıçapı gibi özelliklerle yapılandırır.
    private func configureCollectionView(_ collectionView: UICollectionView, cellType: String, showsScrollIndicator: Bool, cornerRadius: CGFloat = 0) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: cellType, bundle: nil), forCellWithReuseIdentifier: cellType)
        collectionView.showsVerticalScrollIndicator = showsScrollIndicator
        collectionView.showsHorizontalScrollIndicator = showsScrollIndicator
        collectionView.layer.cornerRadius = cornerRadius
        collectionView.layer.masksToBounds = true
    }
    
    // MARK: - Data Loading
    
    /// ViewModel'den verileri yükler ve collection view'leri yeniler.
    private func loadData() {
        kitchenViewModel.loadMockData()
        collectionView.reloadData()
        storiesCollectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return kitchenViewModel.dishes.count
        } else if collectionView == self.storiesCollectionView {
            return kitchenViewModel.stories.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            print("Index: \(indexPath.row), Dish Name: \(kitchenViewModel.dishes[indexPath.row].name)")
            return configureFoodCardCell(for: indexPath)
        } else if collectionView == self.storiesCollectionView {
            return configureStoriesCell(for: indexPath)
        }
        return UICollectionViewCell()
    }

    /// Yemek kartı hücresini yemek verileriyle yapılandırır.
    private func configureFoodCardCell(for indexPath: IndexPath) -> FoodCardCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.foodCardCellIdentifier, for: indexPath) as? FoodCardCollectionViewCell else {
            fatalError("\(Constants.foodCardCellIdentifier) bulunamadı")
        }
        
        let foodItem = kitchenViewModel.dishes[indexPath.row]
        cell.foodTitleLabel.text = foodItem.name
        cell.labelContentFood.text = foodItem.description
        cell.labelLocationFood.text = foodItem.location
        cell.imageViewFood.image = UIImage(named: foodItem.images.first ?? "")
        
        // Hücre başına her ayar yapıldıktan sonra yükleme durumunu kontrol et
        print("Cell Configured at Index: \(indexPath.row), Dish Name: \(foodItem.name)")
        
        return cell
    }

    
    /// Hikaye hücresini hikaye verileriyle yapılandırır.
    private func configureStoriesCell(for indexPath: IndexPath) -> StoriesCollectionViewCell {
        guard let cell = storiesCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.storiesCellIdentifier, for: indexPath) as? StoriesCollectionViewCell else {
            fatalError("\(Constants.storiesCellIdentifier) bulunamadı")
        }
        
        let story = kitchenViewModel.stories[indexPath.row]
        cell.configure(with: story.title, image: UIImage(named: story.image))
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: collectionView.frame.width, height: Constants.foodCardCellHeight)
        } else if collectionView == self.storiesCollectionView {
            return Constants.storyCellSize
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let detailVC = FoodDetailViewController()
            detailVC.dish = kitchenViewModel.dishes[indexPath.row]
            detailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
