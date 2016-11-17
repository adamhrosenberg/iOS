//
//  PaintingCollection.swift
//  Things
//
//  Created by Adam Rosenberg on 2/20/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import Foundation

protocol PaintingCollectionDelegate:class{
    func collection(_ collection: PaintingCollection, paintingChanged paintingIndex:Int)
}

class PaintingCollection{
    
    fileprivate var _paintings: [Painting] = []
    var paintingCount:Int{
        return _paintings.count
    }

    func painting(_ paintingIndex: Int)->Painting{
        return _paintings[paintingIndex]
    }
    
    
    func addPainting(_ painting:Painting){
        _paintings.insert(painting, at: paintingCount)
    }
    
    //delegate update call.
    func updatePainting(_ painting:Painting, index:Int){
        _paintings[index] = painting
    }
    func addStroke(_ stroke:Stroke, toPainting paintingIndex: Int){
        let painting: Painting = paintingAtIndex(paintingIndex)
        painting.strokes.append(stroke)
        delegate?.collection(self, paintingChanged: paintingIndex)
    }
    func paintingAtIndex(_ paintingIndex: Int)-> Painting{
        return _paintings[paintingIndex]
    }
    //paintingIndex: Int
    func removePainting(){
        if(paintingCount>0){
            _paintings.removeLast()
        }
    }
    
    weak var delegate: PaintingCollectionDelegate? = nil
}
