import UIKit

class StoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var storiesImageView: UIImageView!
    @IBOutlet weak var storiesLabel: UILabel!
    
    private let gradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        print("StoriesCollectionViewCell yüklendi")
        setupUI()
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .white // Örneğin gri bir arka plan rengi
    }

    // Arayüz öğelerini yapılandırmak için bir fonksiyon
    private func setupUI() {
        // storiesImageView ayarları
        storiesImageView.contentMode = .scaleAspectFill
        storiesImageView.clipsToBounds = true
        storiesImageView.layer.cornerRadius = storiesImageView.frame.width / 2

        // Gradyan kenarlık ekleme
        addGradientBorder()

        // storiesLabel ayarları
        storiesLabel.textColor = .black
        storiesLabel.textAlignment = .center
        storiesLabel.numberOfLines = 2
        storiesLabel.lineBreakMode = .byWordWrapping
    }

    // Hücreyi yapılandırmak için bir fonksiyon
    func configure(with title: String, image: UIImage?) {
        storiesLabel.text = title
        storiesImageView.image = image
    }

    private func addGradientBorder() {
        // Gradyan renkleri ve yönünü ayarla
        gradientLayer.colors = [UIColor(hex: "#C5DB69").cgColor, UIColor(hex: "#FE8D13").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: storiesImageView.frame.width + 8, height: storiesImageView.frame.height + 8)
        gradientLayer.cornerRadius = gradientLayer.frame.width / 2
        
        // Yeni bir katman oluştur ve gradyanı bunun içine ekle
        let borderView = UIView(frame: gradientLayer.frame)
        borderView.layer.addSublayer(gradientLayer)
        borderView.layer.cornerRadius = gradientLayer.frame.width / 2
        borderView.clipsToBounds = true
        
        // Border view'i storiesImageView'in arkasına ekle
        contentView.insertSubview(borderView, belowSubview: storiesImageView)
        
        // Border view'i tam ortalamak için
        borderView.center = storiesImageView.center
    }
}

// UIColor hex renk kodunu desteklemek için uzantı
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
