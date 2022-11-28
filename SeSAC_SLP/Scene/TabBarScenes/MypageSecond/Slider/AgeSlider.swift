//
//  AgeSlider.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/15.
//

import UIKit
import SnapKit

final class AgeSlider: UIControl {
    private enum Constant {
        static let barRatio = 1.0/10.0
    }
    
    private let leftThumbButton: ThumbButton = {
        let button = ThumbButton()
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let rightThumButton: ThumbButton = {
        let button = ThumbButton()
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let trackBaseBar: UIView = {
        let view = UIView()
        view.backgroundColor = .setGray(color: .gray2)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let trackTintBar: UIView = {
        let view = UIView()
        view.backgroundColor = .setBrandColor(color: .green)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    //MARK: Properties
    
    var minValue = 0.0 {
        didSet { self.lower = self.minValue }
    }
    
    var maxValue = 10.0 {
        didSet { self.upper = self.maxValue }
    }
    
    var lower = 0.0 {
        didSet { self.updateLayout(self.lower, true) }
    }
    
    var upper = 0.0 {
        didSet { self.updateLayout(self.upper, false) }
    }
    
    var trackColor = UIColor.setGray(color: .gray2) {
        didSet { self.trackBaseBar.backgroundColor = self.trackColor }
    }
    
    var trackTintColor = UIColor.setBrandColor(color: .green) {
        didSet { self.trackTintBar.backgroundColor = self.trackTintColor }
    }
    
    private var previousTouchPoint = CGPoint.zero
    private var isLowerThumbViewTouched = false
    private var isUpperThumbViewTouched = false
    private var leftConstraint: Constraint?
    private var rightConstraint: Constraint?
    private var thumbViewLength: Double {
      Double(self.bounds.height)
    }
    
    // MARK: Init
    required init?(coder: NSCoder) {
      fatalError("xib is not implemented")
    }
    override init(frame: CGRect) {
      super.init(frame: frame)

      self.addSubview(self.trackBaseBar)
      self.addSubview(self.trackTintBar)
      self.addSubview(self.leftThumbButton)
      self.addSubview(self.rightThumButton)
      
        self.leftThumbButton.snp.makeConstraints {
        $0.top.bottom.equalToSuperview()
        $0.right.lessThanOrEqualTo(self.rightThumButton.snp.left)
        $0.left.greaterThanOrEqualToSuperview()
        $0.width.equalTo(self.snp.height)
        self.leftConstraint = $0.left.equalTo(self.snp.left).priority(999).constraint // .constraint로 값 가져오기 테크닉
      }
      self.rightThumButton.snp.makeConstraints {
        $0.top.bottom.equalToSuperview()
        $0.left.greaterThanOrEqualTo(self.leftThumbButton.snp.right)
        $0.right.lessThanOrEqualToSuperview()
        $0.width.equalTo(self.snp.height)
        self.rightConstraint = $0.left.equalTo(self.snp.left).priority(999).constraint
      }
      self.trackBaseBar.snp.makeConstraints {
        $0.left.right.centerY.equalToSuperview()
        $0.height.equalTo(self).multipliedBy(Constant.barRatio)
      }
      self.trackTintBar.snp.makeConstraints {
        $0.left.equalTo(self.leftThumbButton.snp.right)
        $0.right.equalTo(self.rightThumButton.snp.left)
        $0.top.bottom.equalTo(self.trackBaseBar)
      }
    }
    
    // MARK: Touch
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
      super.point(inside: point, with: event)
      return self.leftThumbButton.frame.contains(point) || self.rightThumButton.frame.contains(point)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
      super.beginTracking(touch, with: event)
      
      self.previousTouchPoint = touch.location(in: self)
        self.isLowerThumbViewTouched = self.leftThumbButton.frame.contains(self.previousTouchPoint)
      self.isUpperThumbViewTouched = self.rightThumButton.frame.contains(self.previousTouchPoint)
      
      if self.isLowerThumbViewTouched {
        self.leftThumbButton.isSelected = true
      } else {
        self.rightThumButton.isSelected = true
      }
      
      return self.isLowerThumbViewTouched || self.isUpperThumbViewTouched
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
      super.continueTracking(touch, with: event)
      
      let touchPoint = touch.location(in: self)
      defer {
        self.previousTouchPoint = touchPoint
        self.sendActions(for: .valueChanged)
      }
      
      let drag = Double(touchPoint.x - self.previousTouchPoint.x)
      let scale = self.maxValue - self.minValue
      let scaledDrag = scale * drag / Double(self.bounds.width - self.thumbViewLength)
      
      if self.isLowerThumbViewTouched {
        self.lower = (self.lower + scaledDrag)
          .clamped(to: (self.minValue...self.upper))
      } else {
        self.upper = (self.upper + scaledDrag)
          .clamped(to: (self.lower...self.maxValue))
      }
      return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
      super.endTracking(touch, with: event)
      self.sendActions(for: .valueChanged)
      
      self.leftThumbButton.isSelected = false
      self.rightThumButton.isSelected = false
    }
    
    // MARK: Method
    private func updateLayout(_ value: Double, _ isLowerThumb: Bool) {
      DispatchQueue.main.async {
        let startValue = value - self.minValue
        let length = self.bounds.width - self.thumbViewLength
        let offset = startValue * length / (self.maxValue - self.minValue)
        
        if isLowerThumb {
          self.leftConstraint?.update(offset: offset)
        } else {
          self.rightConstraint?.update(offset: offset)
        }
      }
    }
  }
    
  

