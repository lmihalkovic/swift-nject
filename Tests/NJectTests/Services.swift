import Foundation

internal protocol Service {
    func execute() -> String
}

internal class Service1: Service {
    public static let VAR = "I'm performing a service1 😊"
    func execute() -> String {
        return Service1.VAR
    }
}

internal class Service2: Service {
    public static let VAR = "I'm performing a service2 😊"
    func execute() -> String {
        return Service2.VAR
    }
}

internal class MyController {
    @InjectedService()
    var service: Service

    func work() -> String {
        return self.service.execute()
    }
    
}

internal class ViewController {
    @InjectedService(from: .named(name: "VIEW"))
    var service: Service
    
    func work() -> String {
        return self.service.execute()
    }
    
}
