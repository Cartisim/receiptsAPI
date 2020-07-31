import Vapor
import Fluent

struct ImagesController {
    
    func createImage(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try Images.Input.validate(content: req)
        let image = try req.content.decode(Images.Input.self)
        let  model = try Images(from: image)
        return req.images
            .create(model)
            .transform(to: HTTPStatus.created)
    }
    
    func deleteImage(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("imageID", as: UUID.self) else {throw Abort(.badRequest)}
        return req.images
            .delete(id)
            .transform(to: .ok)
    }
    
    func fetchImages(_ req: Request) throws -> EventLoopFuture<[Images.Output]> {
        return req.images
            .all()
            .map{$0.map{Images.Output(from: $0)}}
    }
    
    func fetchImage(_ req: Request) throws -> EventLoopFuture<Images.Output> {
        guard let id = req.parameters.get("imageID", as: UUID.self) else {throw Abort(.badRequest)}
        return req.images
            .find(id: id)
            .unwrap(or: Abort(.notFound))
            .map{Images.Output(from: $0)}
    }
    
    func addReceipt(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("imageID", as: UUID.self) else {throw Abort(.badRequest)}
        return req.images
        .findImageForData(id: id, req: req)
    }
    
    func fetchImageURL(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("imageID", as: UUID.self) else {throw Abort(.badRequest)}
        return req.images
        .findReceiptByID(id: id, req: req)
    }
    
    func deleteReceipt(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("imageID", as: UUID.self) else {throw Abort(.badRequest)}
        return req.images
        .deleteImageData(id: id, req: req)
    }
    
    
}
