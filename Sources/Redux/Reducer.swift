public typealias Reducer<State, Action> = (inout State, Action) -> Action?
