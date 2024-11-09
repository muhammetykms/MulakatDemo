import UIKit

class HeaderView: UIView {

    // MARK: - Bağlantılar
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var notificationImageView: UIImageView!
    
    // MARK: - Özellikler
    private var contentView: UIView!

    // MARK: - Başlatıcılar
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Genel Başlatıcı
    /// XIB dosyasını yükler ve contentView olarak ayarlar.
    private func commonInit() {
        if let nibView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as? UIView {
            contentView = nibView
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        } else {
            print("Content View Yüklenemedi")
        }
    }
    
    // MARK: - Yapılandırma Fonksiyonu
    /// Başlık, logo, bildirim ve profil görsellerini ayarlar ve görsel düzenlemeleri yapar.
    /// - Parameters:
    ///   - title: Başlık metni
    ///   - logoImage: Logo için UIImage
    ///   - notificationImage: Bildirim simgesi için UIImage
    ///   - profileImage: Profil simgesi için UIImage
    func configure(title: String, logoImage: UIImage, notificationImage: UIImage, profileImage: UIImage) {
        titleLabel.text = title
        logoImageView.image = logoImage
        notificationImageView.image = notificationImage
        profileImageView.image = profileImage
        
        // Sınır rengi ve diğer görsel ayarlar
        let borderColor = UIColor(red: 0.733, green: 0.859, blue: 0.412, alpha: 1.0)
        
        configureImageView(notificationImageView, borderColor: borderColor)
        configureImageView(profileImageView, borderColor: borderColor)
    }
    
    // MARK: - Yardımcı Fonksiyon
    /// Bir UIImageView öğesinin köşelerini yuvarlar, sınır rengi ve genişliği ayarlar.
    /// - Parameters:
    ///   - imageView: Ayarlanacak UIImageView nesnesi
    ///   - borderColor: Kenarlık rengi
    private func configureImageView(_ imageView: UIImageView, borderColor: UIColor) {
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = borderColor.cgColor
        imageView.clipsToBounds = true
    }
}
