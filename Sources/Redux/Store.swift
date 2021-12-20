import Foundation

public class Store<State, Action> {
    public private(set) var currentState: State
    
    private let reducer: (inout State, Action) -> Action?
    private let queue: DispatchQueueType
    private let returnsOn: DispatchQueueType
    
    init(
        initialState: State,
        queue: DispatchQueueType = DispatchQueue(label: "com.polpiellacode.redux.store", qos: .userInitiated),
        returnsOn: DispatchQueueType = DispatchQueue.main,
        reducer: @escaping (inout State, Action) -> Action?
    ) {
        self.currentState = initialState
        self.reducer = reducer
        self.queue = queue
        self.returnsOn = returnsOn
    }
    
    func dispatch(_ action: Action) {
        queue.sync {
            if let sideEffect = reducer(&currentState, action) {
                returnsOn.async(group: nil, qos: .unspecified, flags: []) { self.dispatch(sideEffect) }
            }
        }
    }
}
