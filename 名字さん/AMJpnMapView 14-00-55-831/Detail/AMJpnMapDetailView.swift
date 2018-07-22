//
//  AMJpnMapDetailView.swift
//  SampleAMJpnMap
//
//  Created by am10 on 2018/01/18.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

public enum AMJMPrefecture: Int  {
    case none = -1

    case hokkaido
    case aomori
    case iwate
    case akita
    case miyagi
    case yamagata
    case fukushima
    case ibaraki
    case chiba
    case tochigi
    case gunma
    case saitama
    case tokyo
    case kanagawa
    case niigata
    case nagano
    case yamanashi
    case shizuoka
    case aichi
    case mie
    case gifu
    case fukui
    case ishikawa
    case toyama    
    case shiga
    case kyoto
    case hyogo
    case nara
    case wakayama
    case osaka
    case tottori
    case okayama
    case hiroshima
    case yamaguchi
    case shimane
    case kagawa
    case tokushima
    case kochi
    case ehime
    case fukuoka
    case oita
    case miyazaki
    case kagoshima
    case kumamoto
    case saga
    case nagasaki
    case okinawa
    

}

@IBDesignable public class AMJpnMapDetailView: UIView {
    
    enum AMDRegion {
        
        case hokkaido
        case tohoku
        case kanto
        case chubu
        case kinki
        case chugoku
        case shikoku
        case kyushu
    }
    
    override public var bounds: CGRect {
        
        didSet {
            
            mapSize = (frame.width < frame.height) ? frame.width : frame.height
            clear()
            drawMap()
        }
    }
    
    @IBInspectable public var strokeColor:UIColor = UIColor.green
    
    @IBInspectable public var fillColor:UIColor = UIColor.green
    
    @IBInspectable public var strokeColorOkinawaLine:UIColor = UIColor.black
    
    ////////////////
    weak public var delegate:AMJpnMapViewDetailDelegate?
    private var regionLayers = [CAShapeLayer]()
    
    ///////////////
    private var mapSize:CGFloat = 0
    
    private var layerHokkaido:AMJMHokkaidoLayer?
    
    private var layerTohoku:AMJMTohokuLayer?
    
    private var layerKanto:AMJMKantoLayer?
    
    private var layerChubu:AMJMChubuLayer?
    
    private var layerKinki:AMJMKinkiLayer?
    
    private var layerChugoku:AMJMChugokuLayer?
    
    private var layerShikoku:AMJMShikokuLayer?
    
    private var layerKyushu:AMJMKyushuLayer?
    

    private var preSelectRegion:AMJMPrefecture = .none

    //MARK:Initialize
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder:aDecoder)
        initView()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        initView()
    }
    
    convenience init() {
        
        self.init(frame: CGRect.zero)
    }
    
    private func initView() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(gesture:)))
        addGestureRecognizer(tap)
    }
    override public func draw(_ rect: CGRect) {
        
        mapSize = (rect.width < rect.height) ? rect.width : rect.height
        clear()
        drawMap()
        layerHokkaido?.prefectureLayers.map {self.regionLayers.append($0)}
        layerTohoku?.prefectureLayers.map {self.regionLayers.append($0)}
        layerKanto?.prefectureLayers.map {self.regionLayers.append($0)}
        layerChubu?.prefectureLayers.map {self.regionLayers.append($0)}
        layerKinki?.prefectureLayers.map {self.regionLayers.append($0)}
        layerChugoku?.prefectureLayers.map {self.regionLayers.append($0)}
        layerShikoku?.prefectureLayers.map {self.regionLayers.append($0)}
        layerKyushu?.prefectureLayers.map {self.regionLayers.append($0)}
   }
    
    
    private func reloadMap() {
        
        clear()
        drawMap()
    }
    
    //MARK:Draw
    private func drawMap() {
        
        drawHokkaido()
        drawTohoku()
        drawKanto()
        drawChubu()
        drawKinki()
        drawChugoku()
        drawShikoku()
        drawKyushu()
        
        for layer in regionLayers {
            
            layer.strokeColor = strokeColor.cgColor
            layer.fillColor = fillColor.cgColor
            layer.zPosition = -1
        }
    }
    
    private func drawHokkaido() {
        
        layerHokkaido = AMJMHokkaidoLayer()
        layerHokkaido?.mapFillColor = fillColor
        layerHokkaido?.mapStrokeColor = strokeColor
        layerHokkaido?.drawMap(rect: bounds)

        layer.addSublayer(layerHokkaido!)

    }
    
    private func drawTohoku() {
        
        layerTohoku = AMJMTohokuLayer()
        layerTohoku?.mapFillColor = fillColor
        layerTohoku?.mapStrokeColor = strokeColor
        layerTohoku?.drawMap(rect: bounds)
        layer.addSublayer(layerTohoku!)
    }
    
    private func drawKanto() {
        
        layerKanto = AMJMKantoLayer()
        layerKanto?.mapFillColor = fillColor
        layerKanto?.mapStrokeColor = strokeColor
        layerKanto?.drawMap(rect: bounds)
        layer.addSublayer(layerKanto!)
    }
    
    private func drawChubu() {
        
        layerChubu = AMJMChubuLayer()
        layerChubu?.mapFillColor = fillColor
        layerChubu?.mapStrokeColor = strokeColor
        layerChubu?.drawMap(rect: bounds)

        layer.addSublayer(layerChubu!)
    }
    
    private func drawKinki() {
        
        layerKinki = AMJMKinkiLayer()
        layerKinki?.mapFillColor = fillColor
        layerKinki?.mapStrokeColor = strokeColor
        layerKinki?.drawMap(rect: bounds)
        layer.addSublayer(layerKinki!)
    }
    
    private func drawChugoku() {
        
        layerChugoku = AMJMChugokuLayer()
        layerChugoku?.mapFillColor = fillColor
        layerChugoku?.mapStrokeColor = strokeColor
        layerChugoku?.drawMap(rect: bounds)

        layer.addSublayer(layerChugoku!)
    }
    
    private func drawShikoku() {
        
        layerShikoku = AMJMShikokuLayer()
        layerShikoku?.mapFillColor = fillColor
        layerShikoku?.mapStrokeColor = strokeColor
        layerShikoku?.drawMap(rect: bounds)

        layer.addSublayer(layerShikoku!)
    }
    
    private func drawKyushu() {
        
        layerKyushu = AMJMKyushuLayer()
        layerKyushu?.mapFillColor = fillColor
        layerKyushu?.mapStrokeColor = strokeColor
        layerKyushu?.strokeColorOkinawaLine = strokeColorOkinawaLine
        layerKyushu?.drawMap(rect: bounds)

        layer.addSublayer(layerKyushu!)
    }
    
    private func clear() {
        
        layerHokkaido?.removeFromSuperlayer()
        layerTohoku?.removeFromSuperlayer()
        layerKanto?.removeFromSuperlayer()
        layerChubu?.removeFromSuperlayer()
        layerKinki?.removeFromSuperlayer()
        layerChugoku?.removeFromSuperlayer()
        layerShikoku?.removeFromSuperlayer()
        layerKyushu?.removeFromSuperlayer()
        
        layerHokkaido = nil
        layerTohoku = nil
        layerKanto = nil
        layerChubu = nil
        layerKinki = nil
        layerChugoku = nil
        layerShikoku = nil
        layerKyushu = nil
    }
    
    private func convertRegion(prefecture: AMJMPrefecture) -> AMDRegion {
    
        switch prefecture {
        case .hokkaido:
            return .hokkaido
            
        case .aomori, .iwate, .akita,
             .miyagi, .yamagata, .fukushima:
            return .tohoku
            
        case .ibaraki, .chiba, .tochigi,
             .gunma, .saitama, .tokyo, .kanagawa:
            return .kanto
            
        case .niigata, .nagano, .yamanashi,
             .shizuoka, .aichi, .mie, .gifu,
             .fukui, .ishikawa, .toyama:
            return .chubu
            
        case .shiga, .kyoto, .hyogo,
             .nara, .wakayama, .osaka:
            return .kinki
            
        case .tottori, .okayama, .hiroshima,
             .yamaguchi, .shimane:
            return .chugoku
            
        case .kagawa, .tokushima, .kochi, .ehime:
            return .shikoku
        
        case .fukuoka, .oita, .miyazaki,
             .kagoshima, .kumamoto, .saga,
             .nagasaki, .okinawa:
            return .kyushu

        case .none:
            return .kyushu
        }
    }
    
    private func getRegionLayer(prefecture: AMJMPrefecture) -> AMJMRegionLayer? {
        
        switch convertRegion(prefecture: prefecture) {
            
        case .hokkaido:
            return layerHokkaido
        case .tohoku:
            return layerTohoku
        case .kanto:
            return layerKanto
        case .chubu:
            return layerChubu
        case .kinki:
            return layerKinki
        case .chugoku:
            return layerChugoku
        case .shikoku:
            return layerShikoku
        case .kyushu:
            return layerKyushu
        }
    }
    
    //MARK:Public Method
    public func setStrokeColor(color: UIColor, prefecture: AMJMPrefecture) {
        
        guard let targetLayer = getRegionLayer(prefecture: prefecture) else {
            
            return
        }
        
        targetLayer.setStrokeColor(color: color, prefecture: prefecture)
    }
    
    public func setFillColor(color: UIColor, prefecture: AMJMPrefecture) {
        
        guard let targetLayer = getRegionLayer(prefecture: prefecture) else {
            
            return
        }
        
        targetLayer.setFillColor(color: color, prefecture: prefecture)
    }
    
    
    //MARK:Gesture Action
    @objc func tapAction(gesture: UITapGestureRecognizer) {
        
        let point = gesture.location(in: self)
        var isMap = false
        for (index, layer) in regionLayers.enumerated() {
            
            let path = UIBezierPath(cgPath: layer.path!)
            if path.contains(point) {
                
                isMap = true
                deselectLayer()
                if preSelectRegion.rawValue == index {
                    
                    preSelectRegion = .none
                    
                } else {
                    
//                    preSelectRegion = preSelectRegion.convert(index: index)
                    preSelectRegion = AMJMPrefecture(rawValue: index)!
                    layer.zPosition = 1
                    if let delegate = delegate {
                        delegate.jpnMapDetailView(jpnMapDetailView: self, didSelectAtRegion: preSelectRegion, number: index)
                    }
                }
                break
            }
        }
        
        if !isMap {
            
            deselectLayer()
            preSelectRegion = .none
        }
    }
    
    private func deselectLayer() {
        
        if preSelectRegion == .none {
            
            return
        }
        
        let layer = regionLayers[preSelectRegion.rawValue]
        layer.zPosition = -1
        if let delegate = delegate {
            
            delegate.jpnMapDetailView(jpnMapDetailView: self, didDeselectAtRegion: preSelectRegion)
        }
    }
    
    public func setScale(scale: CGFloat, region: AMJMPrefecture) {
        
        if region == .none {
            
            return
        }
        
        if regionLayers.count == 0 {
            
            return
        }
        
        let layer = regionLayers[region.rawValue]
        layer.anchorPoint = (scale == 1.0) ? CGPoint(x: 0.5, y: 0.5) : CGPoint(x: 2, y: 2) 
        layer.setAffineTransform(CGAffineTransform(scaleX: scale, y: scale))
    }
}

public protocol AMJpnMapViewDetailDelegate: class {
    
    func jpnMapDetailView(jpnMapDetailView: AMJpnMapDetailView, didSelectAtRegion region: AMJMPrefecture, number: Int)
    func jpnMapDetailView(jpnMapDetailView: AMJpnMapDetailView, didDeselectAtRegion region: AMJMPrefecture)
}

