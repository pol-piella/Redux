class Store<State, Action> {
    private(set) var currentState: State
    
    init(initialState: State) {
        self.currentState = initialState
    }
    
    func dispatch(_ action: Action) {
        
    }
}
