import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var arms: UIImageView!
    @IBOutlet weak var ears: UIImageView!
    @IBOutlet weak var eyes: UIImageView!
    @IBOutlet weak var iris: UIImageView!
    @IBOutlet weak var nose: UIImageView!
    @IBOutlet weak var pizza: UIImageView!
    
    private var animator: UIDynamicAnimator!
    private var snapping: UISnapBehavior!
    
    private var fixedCenterByPizza: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: view)
        snapping = UISnapBehavior(item: pizza, snapTo: view.center)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pannedPizza))
        pizza.addGestureRecognizer(panGesture)
        pizza.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fixedCenterByPizza = pizza.center
    }

    @objc func pannedPizza(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animator.removeBehavior(snapping)
        case .changed:
            let translation = recognizer.translation(in: view)
            
            let point = CGPoint(x: pizza.center.x + translation.x,
                                y: pizza.center.y + translation.y)
            
            pizza.center = point
            animateEyes(by: point)
            animateIris(by: point)
            animateNose(by: point)
            animateArms(by: point)
            animateEars(by: point)
            
            recognizer.setTranslation(.zero, in: view)
        case .ended, .cancelled, .failed:
            animator.addBehavior(snapping)
            
            UIView.animate(withDuration: TimeInterval(snapping.damping)) {
                self.eyes.transform = .identity
                self.iris.transform = .identity
                self.nose.transform = .identity
                self.arms.transform = .identity
                self.ears.transform = .identity
            }
        case .possible:
            break
        }
    }

    private func retrieveRelativePoint(by point: CGPoint) {
        let x = (point.x - fixedCenterByPizza.x) * 0.1
        let y = (point.y - fixedCenterByPizza.y) * 0.1
        return (x, y)
    }
    
    private func animateEyes(by point: CGPoint) {
        let (x, y) = retrieveRelativePoint(by: point)
        eyes.transform = CGAffineTransform(translationX: max(min(x * 0.5 , 10.0), -10.0),
                                           y: max(min(y, 10.0), -10.0))
    }
    
    private func animateIris(by point: CGPoint) {
        let (x, y) = retrieveRelativePoint(by: point)
        iris.transform = CGAffineTransform(translationX: max(min(x, 16.0), -16.0),
                                           y: max(min(y, 16.0), -16.0))
    }
    
    private func animateNose(by point: CGPoint) {
        let (x, y) = retrieveRelativePoint(by: point)
        nose.transform = CGAffineTransform(translationX: max(min(x, 10.0), -10.0),
                                           y: max(min(y, 10.0), -10.0))
    }
    
    private func animateArms(by point: CGPoint) {
        let (x, y) = retrieveRelativePoint(by: point)
        arms.transform = CGAffineTransform(translationX: -max(min(x, 8.0), -8.0),
                                           y: -max(min(y, 8.0), -8.0))
    }
    
    private func animateEars(by point: CGPoint) {
        let (x, y) = retrieveRelativePoint(by: point)
        ears.transform = CGAffineTransform(translationX: -max(min(x, 6.0), -6.0),
                                           y: -max(min(y, 6.0), -6.0))
    }
}

