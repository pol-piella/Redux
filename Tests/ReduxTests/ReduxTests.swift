import XCTest
@testable import Redux

// Can pass it an initial state
// Can have a reducer that modifies the state

final class ReduxTests: XCTestCase {
    func test_WhenStoreIsInitialised_ThenStoreCanBeGivenAnInitialState() {
        let state = StubState()
        let reducer: (inout StubState, StubAction) -> StubAction? = { _, _ in return nil }
        let store = Store(initialState: state, reducer: reducer)
        
        XCTAssertEqual(store.currentState, state)
    }
    
    func test_WhenDispatchIsCalled_ThenStateIsUpdatedViaTheReducer() {
        let state = StubState()
        let reducer: (inout StubState, StubAction) -> StubAction? = { currentState, _ in
            currentState.testProperty = "updated"
            return nil
        }
        let store = Store(initialState: state, reducer: reducer)
        
        store.dispatch(.first)
        
        XCTAssertEqual(store.currentState.testProperty, "updated")
    }
    
    func test_WhenDispatchIsCalled_ThenReducerCanHandleMultipleActions() {
        let state = StubState()
        let reducer: (inout StubState, StubAction) -> StubAction? = { currentState, action in
            switch action {
            case .first: currentState.testProperty = "updated"
            case .second: break
            }
            return nil
        }
        let store = Store(initialState: state, reducer: reducer)
        
        store.dispatch(.first)
        
        XCTAssertEqual(store.currentState.testProperty, "updated")
    }
    
    func test_WhenDispatchIsCalledWithAnAction_ThenReducerCanReturnAnotherActionAsASideEffect() {
        let state = StubState()
        var actionCallees = [StubAction]()
        let reducer: (inout StubState, StubAction) -> StubAction? = { _, action in
            actionCallees.append(action)
            switch action {
            case .first: return .second
            case .second: return nil
            }
        }
        let store = Store(initialState: state, reducer: reducer)
        
        store.dispatch(.first)
        
        XCTAssertEqual(actionCallees, [.first, .second])
    }
    
    
    
    private enum StubAction {
        case first
        case second
    }
    
    private struct StubState: Equatable {
        var testProperty: String = ""
    }
}
