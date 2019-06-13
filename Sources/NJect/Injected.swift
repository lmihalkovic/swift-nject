import Foundation

public enum Scope: Hashable {
    case global
    case named(name: String)
}

@propertyWrapper public struct InjectedService<Service> {
    let scope: Scope
    public init(from scope: Scope = .global) {
        self.scope = scope
    }
    
    public var value: Service {
        get {
            return Resolver.resolve(scope, Service.self)
        }
    }
}
