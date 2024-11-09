import UIKit

class ImagePopupViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupPageControl()
        loadImagesIntoScrollView()
        
        // Pan gesture recognizer ekleyelim
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }

    private func setupScrollView() {
        scrollView.frame = view.bounds
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }

    private func setupPageControl() {
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }

    private func loadImagesIntoScrollView() {
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(images.count), height: scrollView.frame.height)
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: scrollView.frame.width * CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(imageView)
        }
    }

    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    // Pan gesture hareketini işle
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if gesture.state == .changed {
            // View'i çekme hareketine göre aşağı kaydır
            view.transform = CGAffineTransform(translationX: 0, y: max(0, translation.y))
        } else if gesture.state == .ended {
            if translation.y > 100 {
                // Çekme hareketi yeterliyse pop-up'u kapat
                dismiss(animated: true, completion: nil)
            } else {
                // Hareket yeterli değilse, başlangıç pozisyonuna geri döndür
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
        }
    }
}
