class Store<State, Action> {
    private(set) var currentState: State
    private let reducer: (inout State, Action) -> Action?
    
    init(initialState: State, reducer: @escaping (inout State, Action) -> Action?) {
        self.currentState = initialState
        self.reducer = reducer
    }
    
    func dispatch(_ action: Action) {
        if let sideEffect = reducer(&currentState, action) {
            dispatch(sideEffect)
        }
    }
}
