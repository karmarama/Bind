#if !os(macOS) && !os(watchOS)
import UIKit

import XCTest
@testable import Bind

final class BindableTestsUIKit: XCTestCase {
    func testLabel() {
        let label = UILabel()
        let attributedLabel = UILabel()

        let textOutput = Output<String>()
        let textColorOutput = Output<UIColor>()
        let attributedTextOutput = Output<NSAttributedString?>()

        textOutput.bind(to: label.binding.text)
        textColorOutput.bind(to: label.binding.textColor)
        attributedTextOutput.bind(to: attributedLabel.binding.attributedText)

        XCTAssertNil(label.text)
        textOutput.update(withValue: "text")
        XCTAssertEqual(label.text, "text")

        XCTAssertEqual(label.textColor, .black)
        textColorOutput.update(withValue: .red)
        XCTAssertEqual(label.textColor, .red)

        XCTAssertNil(attributedLabel.attributedText)
        attributedTextOutput.update(withValue: NSAttributedString(string: "text"))
        XCTAssertEqual(attributedLabel.attributedText, NSAttributedString(string: "text"))
    }

    func testViewBools() {
        let view = UIView()

        let hiddenOutput = Output<Bool>()
        let visibleOutput = Output<Bool>()
        let visibleAlpha = Output<Bool>()
        let visibleAlphaAnimated = Output<Bool>()
        let userInteractionEnabledOutput = Output<Bool>()
        let constraintsActive = Output<Bool>()

        hiddenOutput.bind(to: view.binding.isHidden)
        visibleOutput.bind(to: view.binding.isVisible)
        visibleAlpha.bind(to: view.binding.isVisibleAlpha(animated: false))
        visibleAlphaAnimated.bind(to: view.binding.isVisibleAlpha(animated: true))
        userInteractionEnabledOutput.bind(to: view.binding.isUserInteractionEnabled)
        constraintsActive.bind(to: view.binding.areConstraintsActive)

        hiddenOutput.update(withValue: true)
        XCTAssertEqual(view.isHidden, true)

        visibleOutput.update(withValue: true)
        XCTAssertEqual(view.isHidden, false)

        visibleAlpha.update(withValue: false)
        XCTAssertEqual(view.alpha, 0)

        visibleAlpha.update(withValue: true)
        XCTAssertEqual(view.alpha, 1)

        visibleAlphaAnimated.update(withValue: false)
        XCTAssertEqual(view.alpha, 0)

        visibleAlphaAnimated.update(withValue: true)
        XCTAssertEqual(view.alpha, 1)

        userInteractionEnabledOutput.update(withValue: false)
        XCTAssertEqual(view.isUserInteractionEnabled, false)

        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        XCTAssertEqual(view.constraints.count, 1)
        constraintsActive.update(withValue: false)
        XCTAssertEqual(view.constraints.count, 0)
    }

    func testViewUIColors() {
        let view = UIView()

        let backgroundColorOutput = Output<UIColor>()
        let borderColorOutput = Output<UIColor>()
        let tintColorOutput = Output<UIColor>()

        backgroundColorOutput.bind(to: view.binding.backgroundColor)
        borderColorOutput.bind(to: view.binding.borderColor)
        tintColorOutput.bind(to: view.binding.tintColor)

        backgroundColorOutput.update(withValue: .red)
        XCTAssertEqual(view.backgroundColor, .red)

        borderColorOutput.update(withValue: .green)
        XCTAssertEqual(view.layer.borderColor, UIColor.green.cgColor)

        tintColorOutput.update(withValue: .blue)
        XCTAssertEqual(view.tintColor, .blue)
    }

    func testViewCGFloat() {
        let view = UIView()

        let borderWidthOutput = Output<CGFloat>()
        let cornerRadiusOutput = Output<CGFloat>()

        borderWidthOutput.bind(to: view.binding.borderWidth)
        cornerRadiusOutput.bind(to: view.binding.cornerRadius)

        borderWidthOutput.update(withValue: 30)
        XCTAssertEqual(view.layer.borderWidth, 30)

        cornerRadiusOutput.update(withValue: 40)
        XCTAssertEqual(view.layer.cornerRadius, 40)
    }

    func testViewString() {
        let view = UIView()

        let accessibilityOutput = Output<String>()

        accessibilityOutput.bind(to: view.binding.accessibilityIdentifier)

        accessibilityOutput.update(withValue: "test-identifier")
        XCTAssertEqual(view.accessibilityIdentifier, "test-identifier")
    }
}
#endif
