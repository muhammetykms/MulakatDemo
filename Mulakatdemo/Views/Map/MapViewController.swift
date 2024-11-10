import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var viewModel: MapViewModel
    
    // MARK: - Initializer
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        addAnnotations()
        centerMap()
    }
    
    // MARK: - Setup Map View
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true // Kullanıcının konumunu göster
    }
    
    // MARK: - Add Annotations
    private func addAnnotations() {
        let annotations = viewModel.getAnnotations()
        mapView.addAnnotations(annotations)
    }
    
    // MARK: - Center Map
    private func centerMap() {
        if let region = viewModel.getRegion() {
            mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    /// Özel pin görünümünü yapılandırır
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Kullanıcının konum pinini özelleştirmek istemiyorsak nil döndür
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "CustomPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .systemBlue
            
            // Detay butonu ekleyin
            let detailButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = detailButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // Map üzerindeki konuma basıldığında bilgi amaçlı alert çağrılır
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotationTitle = annotationView.annotation?.title else { return }
        
        let alert = UIAlertController(title: "Detay", message: "Seçilen konum: \(annotationTitle ?? "")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
