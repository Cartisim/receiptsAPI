import Vapor
import Fluent

protocol ReceiptsRepository: Repository {
    func create(_ receipt: Receipts) -> EventLoopFuture<Void>
    func delete(_ id: UUID) -> EventLoopFuture<Void>
    func all() -> EventLoopFuture<[Receipts]>
    func find(id: UUID) -> EventLoopFuture<Receipts?>
 }

struct DatabaseReceiptsRepository: ReceiptsRepository, DatabaseRepository {

    let database: Database
    
    func create(_ receipt: Receipts) -> EventLoopFuture<Void> {
        return receipt.create(on: database)
    }
    
    func delete(_ id: UUID) -> EventLoopFuture<Void> {
        return Receipts.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func all() -> EventLoopFuture<[Receipts]> {
        return Receipts.query(on: database)
            .filter(\.$id == \._$id)
            .sort(\.$createdAt, .descending)
            .all()
    }
    
    func find(id: UUID) -> EventLoopFuture<Receipts?> {
        return Receipts.query(on: database)
            .filter(\.$id == id)
            .first()
    }
}


extension Application.Repositories {
    var receipts: ReceiptsRepository {
        guard let storage = storage.makeReceiptsRepository else {
            fatalError("ReceiptsRepo is not configure use app.receiptRepository.use()")
        }
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (ReceiptsRepository)) {
        storage.makeReceiptsRepository = make
    }
}

