import Vapor

protocol RequestService {
    func `for`(_ req: Request) -> Self
}

extension Request {
    //MARK: Respositories
    var images: ImagesRepository {
        application.repositories.images.for(self)
    }
    var receipts: ReceiptsRepository {
        application.repositories.receipts.for(self)
    }
}
