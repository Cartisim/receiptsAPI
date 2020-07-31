import Vapor
import Fluent

struct ReceiptController {
    
    func createReceipt(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try Receipts.Input.validate(content: req)
        let receipt = try req.content.decode(Receipts.Input.self)
        let model = try Receipts(from: receipt)
        return req.receipts
            .create(model)
            .transform(to: HTTPStatus.created)
    }
    
    func deleteReceipt(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("receiptID", as: UUID.self) else {throw Abort(.badRequest)}
        return req.receipts
            .delete(id)
            .transform(to: .ok)
    }
    
    func fetchReceipts(_ req: Request) throws -> EventLoopFuture<[Receipts.Output]> {
        return req.receipts
            .all()
            .map{$0.map{Receipts.Output(from: $0)}}
    }
    
    func fetchReceipt(_ req: Request) throws -> EventLoopFuture<Receipts.Output> {
        guard let id = req.parameters.get("receiptID", as: UUID.self) else {throw Abort(.badRequest)}
        return req.receipts
            .find(id: id)
            .unwrap(or: Abort(.notFound))
            .map{Receipts.Output(from: $0)}
    }
    
}
