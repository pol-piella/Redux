import Foundation

protocol DispatchQueueType {
    func sync(execute block: () -> Void)
    func async(group: DispatchGroup?, qos: DispatchQoS, flags: DispatchWorkItemFlags, execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: DispatchQueueType {}
