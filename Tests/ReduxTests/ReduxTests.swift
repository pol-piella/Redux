import XCTest
@testable import Redux

// Can pass it an initial state
// Can have a reducer that modifies the state

final class ReduxTests: XCTestCase {
    func test_WhenStoreIsInitialised_ThenStoreCanBeGivenAnInitialState() {
        let state = StubState()
        let store = Store(initialState: state) { _ in }
        
        XCTAssertEqual(store.currentState, state)
    }
    
    func test_WhenDispatchIsCalled_ThenStateIsUpdatedViaTheReducer() {
        let state = StubState()
        let store = Store(initialState: state) { currentState in
            currentState.testProperty = "updated"
        }
        
        store.dispatch()
        
        XCTAssertEqual(store.currentState.testProperty, "updated")
    }
    
    private struct StubState: Equatable {
        var testProperty: String = ""
    }
}
