//
//  Copyright © 2019 Gnosis Ltd. All rights reserved.
//

import Foundation
import UIKit

public class FeeCalculationAssetLine: FeeCalculationLine {

    enum Style {
        case plain
        case balance
    }

    struct AssetInfo {
        var name: String
        var button: ButtonItem?
        var value: String
        var error: Error?

        static let empty = AssetInfo(name: "", button: nil, value: "", error: nil)
    }

    struct ButtonItem {
        var text: String
        var target: Any?
        var action: Selector?
    }

    var style: Style = .plain
    var asset: AssetInfo = .empty

    override func makeView() -> UIView {
        let textStyle = self.style == .plain ? TextStyle.plain : TextStyle.balance
        let lineStack = UIStackView(arrangedSubviews: [makeName(textStyle: textStyle),
                                                       makeValue(textStyle: textStyle)])
        lineStack.translatesAutoresizingMaskIntoConstraints = false
        lineStack.heightAnchor.constraint(equalToConstant: CGFloat(lineHeight)).isActive = true
        return lineStack
    }

    func makeName(textStyle: TextStyle) -> UIView {
        let stack = UIStackView()
        let label = UILabel()
        label.attributedText = NSAttributedString(string: asset.name, style: textStyle.name)
        stack.addArrangedSubview(label)
        if let buttonData = asset.button {
            stack.addArrangedSubview(makeInfoButton(button: buttonData, textStyle: textStyle))
        }
        return stack
    }

    func makeInfoButton(button buttonData: ButtonItem, textStyle: TextStyle) -> UIButton {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: buttonData.text, style: textStyle.info), for: .normal)
        if let action = buttonData.action {
            button.addTarget(buttonData.target, action: action, for: .touchUpInside)
        }
        return button
    }

    func makeValue(textStyle: TextStyle) -> UIView {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: asset.value, style: textStyle.value)
        let huggingPriority = UILayoutPriority(UILayoutPriority.defaultLow.rawValue - 1)
        label.setContentHuggingPriority(huggingPriority, for: .horizontal)
        return label
    }

    func set(style: Style) -> FeeCalculationAssetLine {
        self.style = style
        return self
    }

    func set(name: String) -> FeeCalculationAssetLine {
        self.asset.name = name
        return self
    }

    func set(value: String) -> FeeCalculationAssetLine {
        self.asset.value = value
        return self
    }

    func set(button: String, target: Any?, action: Selector?) -> FeeCalculationAssetLine {
        self.asset.button = ButtonItem(text: button, target: target, action: action)
        return self
    }

    func set(error: Error?) -> FeeCalculationAssetLine {
        self.asset.error = error
        return self
    }

}