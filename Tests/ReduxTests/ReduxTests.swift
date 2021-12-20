import XCTest
@testable import Redux

// Can pass it an initial state
// Can have a reducer that modifies the state

final class ReduxTests: XCTestCase {
    func test_WhenStoreIsInitialised_ThenStoreCanBeGivenAnInitialState() {
        let state = StubState()
        let store = Store<StubState, StubAction>(initialState: state)
        
        XCTAssertEqual(store.currentState, state)
    }
    
    func test_WhenActionIsDispatched_ThenStateIsUpdatedViaTheReducer() {
        let state = StubState()
        let store = Store<StubState, StubAction>(initialState: state)
        let expectedResult = "updated"
        
        store.dispatch(.first)
        
        XCTAssertEqual(store.currentState.testProperty, expectedResult)
    }
    
    private enum StubAction {
        case first
    }
    
    private struct StubState: Equatable {
        var testProperty: String = ""
    }
}
