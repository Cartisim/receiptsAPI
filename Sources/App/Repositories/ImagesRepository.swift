import Vapor
import Fluent

protocol ImagesRepository: Repository {
    func create(_ image: Images) -> EventLoopFuture<Void>
    func delete(_ id: UUID) -> EventLoopFuture<Void>
    func all() -> EventLoopFuture<[Images]>
    func find(id: UUID) -> EventLoopFuture<Images?>
    
    func findReceiptByID(id: UUID, req: Request) -> EventLoopFuture<HTTPStatus>
    func findImageForData(id: UUID, req: Request) -> EventLoopFuture<HTTPStatus>
    func deleteImageData(id: UUID, req: Request) -> EventLoopFuture<HTTPStatus>
}

struct DatabaseImagesRepository: ImagesRepository, DatabaseRepository {
    
    
    let database: Database
    let imageFolder = "ReceiptImages/"
    func findReceiptByID(id: UUID, req: Request) -> EventLoopFuture<HTTPStatus> {
        return Receipts.query(on: database)
            .filter(\.$id == id)
            .first()
            .unwrap(or: Abort(.badRequest))
            .map { (receipt) -> (Response) in
                let filename = receipt.imageString
                let path = req.application.directory.workingDirectory + self.imageFolder + filename
                return req.fileio.streamFile(at: path)
        }
        .transform(to: HTTPStatus.ok)
    }
    
    func findImageForData(id: UUID, req: Request) -> EventLoopFuture<HTTPStatus> {
        return Receipts.query(on: database)
            .filter(\.$id == id)
            .first()
            .unwrap(or: Abort(.badRequest))
            .flatMap { (receipt) -> EventLoopFuture<Void> in
                do {
                    let image = try req.content.decode(Images.Input.self)
                    let model = try Images(from: image)
                    
                    let workPath =  req.application.directory.workingDirectory
                    let stringName = try "\(receipt.requireID())-\(UUID().uuidString).png"
                    let path = workPath + self.imageFolder + stringName
                    FileManager().createFile(atPath: path, contents: model.image, attributes: nil)
                    
                    receipt.imageString = stringName
                    return receipt.save(on: self.database)
                } catch {
                    return req.eventLoop.makeFailedFuture(error)
                }
                
        }
        .transform(to: HTTPStatus.ok)
    }
    
    func deleteImageData(id: UUID, req: Request) -> EventLoopFuture<HTTPStatus> {
        return Receipts.query(on: database)
            .filter(\.$id == id)
            .first()
            .unwrap(or: Abort(.badRequest))
            .flatMap { (receipt) -> EventLoopFuture<HTTPStatus> in
                do {
                    let filename = receipt.imageString
                    let path = req.application.directory.workingDirectory + self.imageFolder + filename
                    try FileManager().removeItem(atPath: path)
                    return receipt.delete(on: self.database)
                        .transform(to: HTTPStatus.noContent)
                } catch {
                    return req.eventLoop.makeFailedFuture(error)
                }
                
        }
    }
    
    func create(_ image: Images) -> EventLoopFuture<Void> {
        return image.create(on: database)
    }
    
    func delete(_ id: UUID) -> EventLoopFuture<Void> {
        return Images.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func all() -> EventLoopFuture<[Images]> {
        return Images.query(on: database)
            .filter(\.$id == \._$id)
            .sort(\.$createdAt, .descending)
            .all()
    }
    
    func find(id: UUID) -> EventLoopFuture<Images?> {
        return Images.query(on: database)
            .filter(\.$id == id)
            .first()
    }
    
    
    
}


extension Application.Repositories {
    var images: ImagesRepository {
        guard let storage = storage.makeImagesRepository else {
            fatalError("ImagesRepo is not configure user app.imagesRepository.use()")
        }
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (ImagesRepository)) {
        storage.makeImagesRepository = make
    }
}
