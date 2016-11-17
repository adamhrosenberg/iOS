//
//  PaintingListViewController.swift
//  Things
//
//  Created by Adam Rosenberg on 2/20/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

class PaintingListViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, PaintingControllerDelegate{
    
    let paintingCollection:PaintingCollection = PaintingCollection()
    let paintingView: PaintingView = PaintingView()
//    let cellView: CellView = CellView()
    
    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout?
    
    func updatePaintingHere(_ painting: Painting, index: Int) {
        paintingCollection.updatePainting(painting, index: index)
    }

//    //accessing view the controller is working with
//    private var collectionView: UICollectionView!{
//        return (view as! UICollectionView)
//    }
    
    //MARK:UIViewController Methods
//    override func loadView() {
//        
//    }
    
    //after load view to customize view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout = UICollectionViewFlowLayout()
        layout?.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout?.itemSize = CGSize(width: self.view.frame.width/4, height: self.view.frame.height/4)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout!)
        collectionView.allowsSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CellView.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionView.self))
        
        navigationItem.title = "Gallery"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(PaintingListViewController.addTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(PaintingListViewController.removeTapped))
        
        self.view.addSubview(collectionView)

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.collectionView.reloadData()
    }
    
    //MARK: nav button targets
    func addTapped(){
        let strokes:[Stroke]=[]
        let newPainting:Painting = Painting(_strokes: strokes)

        newPainting.index = paintingCollection.paintingCount
        paintingCollection.addPainting(newPainting)
        self.collectionView.reloadData()
    }
    
    func removeTapped(){
        paintingCollection.removePainting()
        self.collectionView.reloadData()
    }
    
    //MARK:UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paintingCollection.paintingCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: CellView = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionView.self), for: indexPath) as! CellView
        
        cell.paintingView!.setPainting(paintingCollection.paintingAtIndex(indexPath.item))
        
        return cell
        
    }
    
//    //MARK: UICollectionViewDelegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//        var cell: CellView = collectionView.cellForItemAtIndexPath(indexPath)
        
        let paintingViewController: PaintingViewController = PaintingViewController()
        paintingViewController.controllerDelegate = self
        paintingViewController.index = indexPath.item
//        print("index vs count \(indexPath.item) , \(paintingCollection.paintingCount)")
        paintingViewController.painting = paintingCollection.painting(indexPath.item)
        navigationController?.pushViewController(paintingViewController, animated: true)
        
        
    }
    
//    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
//        if gestureReconizer.state != UIGestureRecognizerState.Ended {
//            return
//        }
//        
//        let p = gestureReconizer.locationInView(self.collectionView)
//        let indexPath = self.collectionView.indexPathForItemAtPoint(p)
//        
//        if let index = indexPath {
//            var cell = self.collectionView.cellForItemAtIndexPath(index)
//            // do stuff with your cell, for example print the indexPath
//        } else {
//        }
//    }
    
}
