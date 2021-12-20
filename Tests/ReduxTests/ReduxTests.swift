import XCTest
@testable import Redux

final class ReduxTests: XCTestCase {
    func test_WhenStoreIsInitialised_ItCanBeGivenAnInitialState() {
        let state = StubState()
        let store = Store(initialState: state)
        
        XCTAssertEqual(store.currentState, state)
    }
    
    private struct StubState: Equatable {}
}
