import UIKit

class ProductLabelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        productLabel.numberOfLines = 0 // Sınırsız satır sayısı
        productLabel.lineBreakMode = .byWordWrapping // Kelime ile satır sonlandırma
        
        // Hücre kenarları için köşe yuvarlatma
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true

        
        // İç kenar boşlukları için `productLabel` padding ekleme
        productLabel.layer.cornerRadius = 5
        
    }
    
    func configure(with text: String) {
        productLabel.text = text
        productLabel.sizeToFit() // Label boyutunu içeriğe göre ayarla
    }
}
