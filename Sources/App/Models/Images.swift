import Vapor
import Fluent

final class Images: Model {
    
    typealias Input = _Input
    typealias Output = _Output
    
    static let schema = "images"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "image")
    var image: Data
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() {}
    init(id: UUID? = nil, image: Data, createdAt: Date? = nil) {
        self.id = id
        self.image = image
    }
}

extension Images {
    struct _Input: Content {
        var image: Data
        
        init(image: Data) {
            self.image = image
        }
        
        init(from image: Images) {
            self.init(image: image.image)
        }
    }
}


extension Images {
    struct _Output: Content {
        var id: String
        var image: Data
        var createdAt: Date
        
        init(id: String, image: Data, createdAt: Date) {
            self.id = id
            self.image = image
            self.createdAt = createdAt
        }
        
        init(from image: Images) {
            self.init(id: image.id!.uuidString, image: image.image, createdAt: image.createdAt ?? Date())
        }
    }
}

extension Images.Input: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("image", as: Data.self, is: !.empty)
    }
}


extension Images {
    convenience init(from images: Images.Input) throws {
        self.init(image: images.image)
    }
}
