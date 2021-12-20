import Foundation

public class Store<State, Action> {
    public private(set) var currentState: State
    
    private let reducer: Reducer<State, Action>
    private let queue: DispatchQueueType
    
    init(
        initialState: State,
        queue: DispatchQueueType = DispatchQueue(label: "com.polpiellacode.redux.store", qos: .userInitiated),
        reducer: @escaping Reducer<State, Action>
    ) {
        self.currentState = initialState
        self.reducer = reducer
        self.queue = queue
    }
    
    func dispatch(_ action: Action) {
        queue.sync {
            if let sideEffect = reducer(&currentState, action) {
                queue.async(group: nil, qos: .unspecified, flags: []) { self.dispatch(sideEffect) }
            }
        }
    }
}
