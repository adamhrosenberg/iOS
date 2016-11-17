//
//  GameView.swift
//  Things
//
//  Created by Adam Rosenberg on 2/20/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

protocol GameViewDelegate: class{
    func sendIndex(_ index:IndexPath, isTopBoard:Bool)
}

class GameView: UIView, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var collectionView: UICollectionView!
    var collectionView2: UICollectionView!
    var layout: UICollectionViewFlowLayout?
    var newGameButton:UIButton = UIButton()
    var data: [String] = []
    weak var gameViewDelegate:GameViewDelegate? = nil
    
    override init(frame:CGRect){
        super.init(frame:frame)//add subviews

        go()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendingCellLabel(_ cellLabel:String, index:IndexPath, isTopBoard:Bool){
        let title = UILabel(frame: CGRect(x: 3.0, y: 0, width: 20, height: 20))
        
        
        if(cellLabel == "clear"){
            //clear both board..
            title.backgroundColor = UIColor.white
        }
        else{
            title.text = cellLabel
            
        }
        if(isTopBoard){
            self.collectionView.cellForItem(at: index)?.addSubview(title)
        }else{
            self.collectionView2.cellForItem(at: index)?.addSubview(title)
        }
    }
    
    func go() {
        
        layout = UICollectionViewFlowLayout()
        layout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout?.itemSize = CGSize(width: 20, height: 20)
        layout?.minimumInteritemSpacing = 0
        layout?.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: CGRect (x: 50,y: 20,width: 210,height: 280), collectionViewLayout: layout!)
        //        print("height.. \(view.frame.height) ... width.. \(view.frame.width)")
        collectionView.allowsSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CellView.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionView.self))
        collectionView.allowsSelection = false
        self.addSubview(collectionView)
        
        //other player
        collectionView2 = UICollectionView(frame: CGRect (x: 50,y: 320,width: 210,height: 280), collectionViewLayout: layout!)
        //        print("height.. \(view.frame.height) ... width.. \(view.frame.width)")
        collectionView2.allowsSelection = true
        collectionView2.dataSource = self
        collectionView2.delegate = self
        collectionView2.backgroundColor = UIColor.white
        collectionView2.register(CellView.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionView.self))
        collectionView2.allowsSelection = false
        self.addSubview(collectionView2)
        
    }

    
    //MARK:UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CellView = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionView.self), for: indexPath) as! CellView
        return cell
        
    }
    
    //    //MARK: UICollectionViewDelegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.allowsSelection = false
        var isTopBoard:Bool = true
        if(collectionView == self.collectionView2){
            isTopBoard = false
        }
        gameViewDelegate?.sendIndex(indexPath, isTopBoard: isTopBoard)
    }
    
    func modifyAllowsSelection(_ turnOn:Bool){
        self.collectionView.allowsSelection = turnOn
    }
    
    func modifyVisibility(_ isVisible:Bool){
        self.collectionView.isHidden = !isVisible
        self.collectionView2.isHidden = !isVisible

    }
    
    
}
