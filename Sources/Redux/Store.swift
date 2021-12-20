class Store<State> {
    let currentState: State
    
    init(initialState: State) {
        self.currentState = initialState
    }
}
