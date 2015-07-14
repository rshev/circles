//
//  ViewController.swift
//  DynamicColorExample
//
//  Created by Yannick LORIOT on 01/06/15.
//  Copyright (c) 2015 Yannick LORIOT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
  private let ColorCellIdentifier = "ColorCell"

  private let mainColor = UIColor(hex: 0xc0392b)

  @IBOutlet weak var colorCollectionView: UICollectionView!

  private var colors: [(String, UIColor)] = [] {
    didSet {
      colorCollectionView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    var _colors: [(String, UIColor)] = []

    let original = ("Original", mainColor)
    _colors.append(original)

    let lighter = ("Lighter", mainColor.lighterColor())
    _colors.append(lighter)

    let darker = ("Darker", mainColor.darkerColor())
    _colors.append(darker)

    let saturated = ("Saturated", mainColor.saturatedColor())
    _colors.append(saturated)

    let desaturated = ("Desaturated", mainColor.desaturatedColor())
    _colors.append(desaturated)

    let grayscaled = ("Grayscaled", mainColor.grayscaledColor())
    _colors.append(grayscaled)

    let adjustHue = ("Adjusted", mainColor.adjustedHueColor(45 / 360))
    _colors.append(adjustHue)

    let complement = ("Complement", mainColor.complementColor())
    _colors.append(complement)

    let invert = ("Invert", mainColor.invertColor())
    _colors.append(invert)

    let mixBlue = ("Mix Blue", mainColor.mixWithColor(UIColor.blueColor()))
    _colors.append(mixBlue)

    let mixGreen = ("Mix Green", mainColor.mixWithColor(UIColor.greenColor()))
    _colors.append(mixGreen)

    let mixYellow = ("Mix Yellow", mainColor.mixWithColor(UIColor.yellowColor()))
    _colors.append(mixYellow)

    let tintColor = ("Tint", mainColor.tintColor())
    _colors.append(tintColor)

    let shadeColor = ("Shade", mainColor.shadeColor())
    _colors.append(shadeColor)

    colors = _colors
  }

  // MARK: - UICollectionView DataSource Methods

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return colors.count
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ColorCellIdentifier, forIndexPath: indexPath) as! ColorCellView

    let (title, color) = colors[indexPath.row]

    cell.titleLabel.text           = title
    cell.colorView.backgroundColor = color

    return cell
  }
}

