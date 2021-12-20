import XCTest
@testable import Redux

final class ReduxTests: XCTestCase {
    func test_WhenStoreIsInitialised_ThenStoreCanBeGivenAnInitialState() {
        let state = StubState()
        let reducer: Reducer<StubState, StubAction> = { _, _ in return nil }
        let store = Store(initialState: state, reducer: reducer)
        
        XCTAssertEqual(store.currentState, state)
    }
    
    func test_WhenDispatchIsCalled_ThenStateIsUpdatedViaTheReducer() {
        let state = StubState()
        let reducer: Reducer<StubState, StubAction> = { currentState, _ in
            currentState.testProperty = "updated"
            return nil
        }
        let store = Store(initialState: state, reducer: reducer)
        
        store.dispatch(.first)
        
        XCTAssertEqual(store.currentState.testProperty, "updated")
    }
    
    func test_WhenDispatchIsCalled_ThenReducerCanHandleMultipleActions() {
        let state = StubState()
        let reducer: Reducer<StubState, StubAction> = { currentState, action in
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
        let reducer: Reducer<StubState, StubAction> = { _, action in
            actionCallees.append(action)
            switch action {
            case .first: return .second
            case .second: return nil
            }
        }
        let store = Store(initialState: state, queue: SpyQueue(), returnsOn: SpyQueue(), reducer: reducer)
        
        store.dispatch(.first)
        
        XCTAssertEqual(actionCallees, [.first, .second])
    }
    
    func test_WhenAnActionIsDispatched_ThenItIsScheduledInAProvidedQueue() {
        let state = StubState()
        let reducer: Reducer<StubState, StubAction> = { _, _ in return nil }
        let queue = SpyQueue()
        let store = Store(initialState: state, queue: queue, reducer: reducer)
        
        store.dispatch(.first)
        
        XCTAssertEqual(queue.syncCallCount, 1)
    }
    
    func test_WhenAnActionIsDispatchedWithSideEffects_ThenItIsScheduledAsynchronouslyInASeparateQeueue() {
        let state = StubState()
        let reducer: Reducer<StubState, StubAction> = { _, action in
            switch action {
            case .first: return .second
            case .second: return nil
            }
        }
        let queue = SpyQueue()
        let store = Store(initialState: state, queue: SpyQueue(), returnsOn: queue, reducer: reducer)
        
        store.dispatch(.first)
        
        XCTAssertEqual(queue.asyncCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private class SpyQueue: DispatchQueueType {
        var syncCallCount = 0
        var asyncCallCount = 0

        func sync(execute block: () -> Void) {
            syncCallCount += 1
            block()
        }
        
        func async(group: DispatchGroup?, qos: DispatchQoS, flags: DispatchWorkItemFlags, execute work: @escaping @convention(block) () -> Void) {
            asyncCallCount += 1
            work()
        }
    }
    
    private enum StubAction {
        case first
        case second
    }
    
    private struct StubState: Equatable {
        var testProperty: String = ""
    }
}
