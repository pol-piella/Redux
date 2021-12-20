import XCTest
@testable import Redux

// Can pass it an initial state
// Can have a reducer that modifies the state

final class ReduxTests: XCTestCase {
    func test_WhenStoreIsInitialised_ThenStoreCanBeGivenAnInitialState() {
        let state = StubState()
        let reducer: (inout StubState, StubAction) -> Void = { _, _ in }
        let store = Store(initialState: state, reducer: reducer)
        
        XCTAssertEqual(store.currentState, state)
    }
    
    func test_WhenDispatchIsCalled_ThenStateIsUpdatedViaTheReducer() {
        let state = StubState()
        let reducer: (inout StubState, StubAction) -> Void = { currentState, _ in
            currentState.testProperty = "updated"
        }
        let store = Store(initialState: state, reducer: reducer)
        
        store.dispatch(.first)
        
        XCTAssertEqual(store.currentState.testProperty, "updated")
    }
    
    func test_WhenDispatchIsCalled_ThenReducerCanHandleMultipleActions() {
        let state = StubState()
        let reducer: (inout StubState, StubAction) -> Void = { currentState, _ in
            currentState.testProperty = "updated"
        }
        
        let store = Store(initialState: state, reducer: reducer)
        
        store.dispatch(.first)
        
        XCTAssertEqual(store.currentState.testProperty, "updated")
    }
    
    private enum StubAction {
        case first
        case second
    }
    
    private struct StubState: Equatable {
        var testProperty: String = ""
    }
}
