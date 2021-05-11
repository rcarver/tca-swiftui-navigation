import XCTest
@testable import ComposableNavigation

final class ReplayNonNilTests: XCTestCase {
	func testReplayNonNil() {
		XCTAssertEqual(
			[nil, "A", nil, "B", "C", nil, nil].map(replayNonNil()),
			[nil, "A", "A", "B", "C", "C", "C"]
		)
	}
}
