//
//  ViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/10.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel.init(frame: CGRect(x: 10, y: 10, width: 200, height: 40))
        label.text = "hahha"
        view.addSubview(label)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

