import Foundation

public class Store<State, Action> {
    public private(set) var currentState: State
    
    private let reducer: Reducer<State, Action>
    private let queue: DispatchQueueType
    
    public init(initialState: State, reducer: @escaping Reducer<State, Action>) {
        self.currentState = initialState
        self.reducer = reducer
        self.queue = DispatchQueue(label: "com.polpiellacode.redux.store", qos: .userInitiated)
    }
    
    init(initialState: State, queue: DispatchQueueType, reducer: @escaping Reducer<State, Action>) {
        self.currentState = initialState
        self.reducer = reducer
        self.queue = queue
    }
    
    public func dispatch(_ action: Action) {
        queue.sync {
            if let sideEffect = reducer(&currentState, action) {
                queue.async(group: nil, qos: .unspecified, flags: []) { self.dispatch(sideEffect) }
            }
        }
    }
}
