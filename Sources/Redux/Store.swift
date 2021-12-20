class Store<State> {
    private(set) var currentState: State
    let reducer: (inout State) -> Void
    
    init(initialState: State, reducer: @escaping (inout State) -> Void) {
        self.currentState = initialState
        self.reducer = reducer
    }
    
    func dispatch() {
        reducer(&currentState)
    }
}
