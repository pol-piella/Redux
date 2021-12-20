class Store<State, Action> {
    private(set) var currentState: State
    let reducer: (inout State, Action) -> Void
    
    init(initialState: State, reducer: @escaping (inout State, Action) -> Void) {
        self.currentState = initialState
        self.reducer = reducer
    }
    
    func dispatch(_ action: Action) {
        reducer(&currentState, action)
    }
}
