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
}
#endif
