import UIKit
import MapKit

class FoodDetailViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Outlets
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var commentsCollectionView: UICollectionView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var sliderScrollView: UIScrollView!
    @IBOutlet weak var productLabelCollectionView: UICollectionView!
    @IBOutlet weak var whatsappButton: UIButton!
    @IBOutlet weak var allTheCommentsButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var ingredientsLabel: UILabel!

    // MARK: - Properties
    var dish: Dish?
    private var comments: [Comment] = []
    private var mapViewController: MapViewController!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.systemOrange
        setupUI()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("DetailViewAppeared"), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("DetailViewDisappeared"), object: nil)
    }

    // MARK: - Setup UI
    /// Ekrandaki bileşenleri yapılandırır
    private func setupUI() {
        setupMainScrollView()
        setupSliderScrollView()
        setupMapViewController()
        setupProductLabelCollectionView()
        setupCommentsCollectionView()
        configureButtons()
    }

    /// Butonlar için görsel yapılandırma ayarlarını yapar
    private func configureButtons() {
        allTheCommentsButton.layer.cornerRadius = 10
        allTheCommentsButton.layer.borderColor = UIColor.orange.cgColor
        allTheCommentsButton.layer.borderWidth = 1
    }

    // MARK: - Load Data
    // Görüntülenecek veriyi ekrana yansıtır
    private func loadData() {
        guard let dish = dish else { return }
        
        foodNameLabel.text = dish.description
        pageControl.numberOfPages = dish.images.count
        priceLabel.text = formatPrice(dish.price)
        locationLabel.text = formatLocation(dish.location)
        likesLabel.text = formatLikes(dish.likes)
        ingredientsLabel.text = formatIngredients(dish.ingredients)
        textView.text = formatDescription(dish.description)
        
        comments = dish.comments
        productLabelCollectionView.reloadData()
        commentsCollectionView.reloadData()
    }

    // MARK: - Setup Main ScrollView
    /// Ana kaydırma görünümünü yapılandırır
    private func setupMainScrollView() {
        mainScrollView.delegate = self
        mainScrollView.isScrollEnabled = true
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: 1500)
    }

    // MARK: - Setup Slider ScrollView
    /// Resimlerin yatay kaydırılabilmesi için slider scroll view'i yapılandırır
    private func setupSliderScrollView() {
        guard let dish = dish else { return }
        sliderScrollView.delegate = self
        sliderScrollView.isPagingEnabled = true
        sliderScrollView.contentSize = CGSize(width: sliderScrollView.frame.width * CGFloat(dish.images.count), height: sliderScrollView.frame.height)
        
        for (index, imageName) in dish.images.enumerated() {
            let imageView = createImageView(imageName: imageName, atIndex: index)
            sliderScrollView.addSubview(imageView)
        }
    }

    /// Resim kaydırıcısına eklenecek ImageView oluşturur
    private func createImageView(imageName: String, atIndex index: Int) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: sliderScrollView.frame.width * CGFloat(index), y: 0, width: sliderScrollView.frame.width, height: sliderScrollView.frame.height)
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }

    // MARK: - Setup MapViewController
    /// Harita görünümünü ekler ve yapılandırır
    private func setupMapViewController() {
           guard let dish = dish else { return }
           let mapViewModel = MapViewModel(dish: dish)
           mapViewController = MapViewController(viewModel: mapViewModel)
           
           addChild(mapViewController)
           mapViewController.view.frame = mapContainerView.bounds
           mapContainerView.addSubview(mapViewController.view)
           mapViewController.didMove(toParent: self)
       }

    // MARK: - Setup Product Label CollectionView
    /// Ürün etiketlerini gösteren koleksiyon görünümünü yapılandırır
    private func setupProductLabelCollectionView() {
        productLabelCollectionView.delegate = self
        productLabelCollectionView.dataSource = self
        productLabelCollectionView.register(UINib(nibName: "ProductLabelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductLabelCollectionViewCell")
        productLabelCollectionView.collectionViewLayout = createProductLabelLayout()
    }

    // MARK: - Setup Comments CollectionView
    /// Yorumları gösteren koleksiyon görünümünü yapılandırır
    private func setupCommentsCollectionView() {
        commentsCollectionView.delegate = self
        commentsCollectionView.dataSource = self
        commentsCollectionView.register(UINib(nibName: "CommentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CommentCollectionViewCell")
    }

    // MARK: - Compositional Layout for Product Labels
    /// Ürün etiketleri için kompozisyonel düzen oluşturur
    private func createProductLabelLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(30))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(5), top: .fixed(5), trailing: .fixed(5), bottom: .fixed(5))

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            return section
        }
    }

    // MARK: - UICollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionView == productLabelCollectionView ? 2 : 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dish = dish else { return 0 }
        
        if collectionView == productLabelCollectionView {
            return section == 0 ? dish.deliveryOptions.count : dish.categoryTags.count
        } else if collectionView == commentsCollectionView {
            return comments.count
        }
        
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productLabelCollectionView {
            return configureProductLabelCell(for: indexPath)
        } else if collectionView == commentsCollectionView {
            return configureCommentCell(for: indexPath)
        }
        
        return UICollectionViewCell()
    }

    private func configureProductLabelCell(for indexPath: IndexPath) -> ProductLabelCollectionViewCell {
        guard let cell = productLabelCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductLabelCollectionViewCell", for: indexPath) as? ProductLabelCollectionViewCell else {
            fatalError("Could not dequeue ProductLabelCollectionViewCell")
        }
        
        let labelText = indexPath.section == 0 ? dish?.deliveryOptions[indexPath.row] : dish?.categoryTags[indexPath.row]
        cell.configure(with: labelText ?? "")
        return cell
    }
    
    private func configureCommentCell(for indexPath: IndexPath) -> CommentCollectionViewCell {
        guard let cell = commentsCollectionView.dequeueReusableCell(withReuseIdentifier: "CommentCollectionViewCell", for: indexPath) as? CommentCollectionViewCell else {
            fatalError("Could not dequeue CommentCollectionViewCell")
        }
        
        cell.configure(with: comments[indexPath.row])
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == commentsCollectionView {
            return CGSize(width: collectionView.frame.width, height: 100)
        } else {
            let labelText = indexPath.section == 0 ? dish?.deliveryOptions[indexPath.row] : dish?.categoryTags[indexPath.row]
            let width = labelText?.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width ?? 100
            return CGSize(width: width + 20, height: 30)
        }
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == sliderScrollView {
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl.currentPage = Int(pageIndex)
        }
    }
    
    @objc private func handleImageTap(_ sender: UITapGestureRecognizer) {
        showImagePopup()
    }
    
    private func showImagePopup() {
        let imagePopupVC = ImagePopupViewController()
        imagePopupVC.modalPresentationStyle = .overFullScreen
        imagePopupVC.images = dish?.images.compactMap { UIImage(named: $0) } ?? []
        present(imagePopupVC, animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions for Formatting

    /// Fiyat bilgisini uygun formatta döndürür
    private func formatPrice(_ price: String) -> String {
        return "Adet fiyatı \(price) dir."
    }

    /// Lokasyon bilgisini uygun formatta döndürür
    private func formatLocation(_ location: String) -> String {
        return location
    }

    /// Beğeni sayısını uygun formatta döndürür
    private func formatLikes(_ likes: Int) -> String {
        return "\(likes) Beğenme"
    }

    /// Malzeme temini bilgisini uygun formatta döndürür
    private func formatIngredients(_ ingredients: String) -> String {
        return "Malzeme Temini: \(ingredients)"
    }

    /// Yemek açıklamasını uygun formatta döndürür
    private func formatDescription(_ description: String) -> String {
        return """
        Malzeme sizden İçli Köfte bizden veya malzeme ve yapım bizden olarak içli köftenizi istediğiniz tarihte teslim ediyoruz. İl dışına dondurulmuş kargo imkanımız vardır.
        """
    }
}
