//
//  PaintingListViewController.swift
//  Things
//
//  Created by Adam Rosenberg on 2/20/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//
//TO USE ERASER:
//tap eraser in settings, and then press back. did not have time to make it fully functional.
//but i wanted to add it just as something extra.
import UIKit

//MARK: Delegate Protocol
protocol BrushSettingsControllerDelegate: class{
    func settingsUpdate(_ stroke:Stroke)
}


class BrushSettingsViewController: UIViewController, BrushDelegate{
    
    weak var settingsDelegate: BrushSettingsControllerDelegate? = nil
    
    
    //MARK:UIViewController Methods
    override func loadView() {
        
        let brushView:BrushSettingsView = BrushSettingsView()
        brushView.backgroundColor = UIColor.green
        brushView.delegate = self
        view = brushView
    }
    //after load view to customize view.
    override func viewDidLoad() {
        navigationItem.title = "Brush Settings"
        
        //line cap and joint options + bottom label
    }
    func settingsViewUpdate(_ stroke:Stroke){
        //call delegate to go to painting view.
        settingsDelegate?.settingsUpdate(stroke)

    }
}
