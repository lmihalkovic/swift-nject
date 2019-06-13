import XCTest
@testable import NJect

class InjectableTests: XCTestCase {
    
    override func setUp() {
        Resolver.reset()
    }
    
    func testRegistering() {
        Resolver.register(.global, Service.self, { return Service1() })
        
        let controller = MyController()
        
        XCTAssertEqual(Service1.VAR, controller.work())
    }
    
    func testRegisteringWithTypeInference() {
        let svc: Service = Service2()
        Resolver.register { return svc }
//        Resolver.register { return Service2() as Service }

        let controller = MyController()

        XCTAssertEqual(Service2.VAR, controller.work())
    }
    
    func testRegisteringSingleton() {
        let svc: Service = Service2()
        Resolver.registerSingleton(Service.self, svc)
        
        let controller = MyController()
        
        XCTAssertEqual(Service2.VAR, controller.work())
    }

    func testRegisteringWithAutoClosure() {
        Resolver.register(.global, Service.self, Service2())
        
        let controller = MyController()
        
        XCTAssertEqual(Service2.VAR, controller.work())
    }
    
    func testRegisteringInScope() {
        Resolver.register(.named(name: "VIEW"), Service.self, { return Service2() })
        Resolver.register(.global, Service.self, { return Service1() })
        
        let controller = ViewController()
        
        XCTAssertEqual(Service2.VAR, controller.work())
    }
    
}
