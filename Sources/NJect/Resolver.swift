import Foundation

typealias Provider<T> = () -> T

//protocol ServiceKey {
//    associatedtype KeyType
//}

enum ServiceKey: Hashable {
    case id(id: ObjectIdentifier)
    case named(name: String)
    indirect case and(key: ServiceKey)
}

struct Key: Hashable {
    let type: ObjectIdentifier
    let name: String?
}

class Registry {
    let scope: Scope
    init(scope: Scope) {
        self.scope = scope
    }
    var providers: [ObjectIdentifier : () -> Any] = [:]
    func add(id: ObjectIdentifier, provider: @escaping () -> Any) {
        providers[id] = provider
    }
    func resolve<T>(_ id: ObjectIdentifier) -> T {
        return self.providers[id]!() as! T
    }
}

internal struct Resolver {
    
    static var scopes: [Scope: Registry] = [ .global: Registry(scope: .global) ]
    
    
    static func _scope(scope: Scope) -> Registry {
        let has = scopes.contains { $0.key == scope }
        if (!has) { scopes[scope] = Registry(scope: scope) }
        return scopes[scope]!
    }
    
    public static func reset() {
        scopes.removeAll()
        scopes[.global] = Registry(scope: .global)
    }
    
    public static func registerSingleton<T>(_ type: T.Type = T.self, _ instance: T) {
        return registerSingleton(.global, type, instance)
    }
    
    public static func registerSingleton<T>(_ scope: Scope, _ type: T.Type = T.self, _ instance: T) {
        let reg = _scope(scope: scope)
        reg.add(id: ObjectIdentifier(type)) { () in instance }
    }
    
    public static func register<T>(_ type: T.Type = T.self, _ provider: @escaping () -> T) {
        return register(.global, type, provider)
    }
    
    public static func register<T>(_ scope: Scope, _ type: T.Type = T.self, _ provider: @escaping () -> T) {
        let reg = _scope(scope: scope)
        reg.add(id: ObjectIdentifier(type), provider: provider)
    }
    
    public static func register<T>(_ type: T.Type, _ provider: @autoclosure @escaping () -> T) {
        return register(.global, type, provider)
    }
    public static func register<T>(_ scope: Scope, _ type: T.Type, _ provider: @autoclosure @escaping () -> T) {
        let reg = _scope(scope: scope)
        reg.add(id: ObjectIdentifier(type), provider: provider)
    }
    
    
    public static func resolve<T>(_ type: T.Type) -> T {
        return resolve(.global, type)
    }
    
    public static func resolve<T>(_ scope: Scope, _ type: T.Type) -> T {
        let reg = _scope(scope: scope)
        return reg.resolve(ObjectIdentifier(type))
    }
}

