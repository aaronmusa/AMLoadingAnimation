//
//  ViewController.swift
//  AMLoadingAnimation
//
//  Created by Aaron Musa on 01/16/2022.
//  Copyright (c) 2022 Aaron Musa. All rights reserved.
//

import UIKit
import AMLoadingAnimation

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        (cell.subviews[1].subviews.first as? AMLoadingAnimation)?.reload()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            (cell.subviews[1].subviews.first as? AMLoadingAnimation)?.isGradientVisible = true
            (cell.subviews[1].subviews.first as? AMLoadingAnimation)?.isAnimating = true
            (cell.subviews[1].subviews.first as? AMLoadingAnimation)?.trackColor = .systemGreen
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath),
              let loadingAnimationView = cell.subviews[1].subviews.first as? AMLoadingAnimation else { return }
    }
}

