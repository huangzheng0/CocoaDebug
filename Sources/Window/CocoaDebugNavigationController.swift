//
//  Example
//  man.li
//
//  Created by man.li on 11/11/2018.
//  Copyright © 2020 man.li. All rights reserved.
//

import UIKit

class CocoaDebugNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false //liman
        
        navigationBar.tintColor = UIColor.white
        if #available(iOS 13.0, *) {
            let appearence =  navigationBar.standardAppearance.copy()
            appearence.backgroundColor = Color.mainGreen
            navigationBar.standardAppearance = appearence
        }
        navigationBar.backgroundColor = Color.mainGreen
        navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20),
                                             .foregroundColor: UIColor.white]
        
        let selector = #selector(CocoaDebugNavigationController.exit)
        
        let image = UIImage(named: "_icon_file_type_close", in: Bundle(for: CocoaDebugNavigationController.self), compatibleWith: nil)
        let leftItem = UIBarButtonItem(image: image,
                                       style: .done, target: self, action: selector)
        leftItem.tintColor = UIColor.white
        topViewController?.navigationItem.leftBarButtonItem = leftItem
    }
    
    
    @objc func exit() {
        dismiss(animated: true, completion: nil)
    }
}
