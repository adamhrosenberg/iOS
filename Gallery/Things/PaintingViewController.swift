//
//  PaintingViewController.swift
//  Things
//
//  Created by Adam Rosenberg on 2/20/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

//MARK: PaintingControllerDelegate Protocol
protocol PaintingControllerDelegate: class{
    func updatePaintingHere(_ painting:Painting, index:Int)
}

class PaintingViewController: UIViewController, BrushSettingsControllerDelegate, PaintingDelegate{
    
    
    //MARK: class variables
    var brushPanel: PaintingView? = PaintingView()
    weak var controllerDelegate: PaintingControllerDelegate? = nil
    weak var delegate: BrushSettingsControllerDelegate? = nil
    let brushSettingsViewController: BrushSettingsViewController = BrushSettingsViewController()
    var index:Int = 0

    //uses throwaway painting const. So I did not have to use a stroke array that was just initizalied
    var painting:Painting = Painting()

    //MARK: delegate functions
    func settingsUpdate(_ stroke:Stroke) {
        
        brushPanel?.redColor = stroke.color.r
        brushPanel?.greenColor = stroke.color.g
        brushPanel?.blueColor = stroke.color.b
        brushPanel?.lineWidth = stroke.lineWidth
        brushPanel?.lineCap = stroke.lineCap
        brushPanel?.lineJoin = stroke.lineJoin
        
    }
    
    func updatePainting(_ painting: Painting, index: Int) {
        controllerDelegate?.updatePaintingHere(painting, index: index)
    }

    //MARK:UIViewController Methods
    override func loadView() {
        brushSettingsViewController.settingsDelegate = self
        brushPanel?.delegate = self
        brushPanel?.painting = painting
        view = brushPanel
        
    }
    //after load view to customize view.
    override func viewDidLoad() {
        
        navigationItem.title = "Brush Settings"
        navigationItem.title="Painting"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(PaintingViewController.settingsTapped))
    }
    
    //MARK: settings Target
    func settingsTapped(){
        navigationController?.pushViewController(brushSettingsViewController, animated: true)
    }
    
}
