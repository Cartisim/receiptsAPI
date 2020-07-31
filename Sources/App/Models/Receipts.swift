import Vapor
import Fluent


final class Receipts: Model {
    
    typealias Input = _Input
    typealias Output = _Output
    
static let schema = "receipts"

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "details")
    var details: String
    
    @Field(key: "image_string")
    var imageString: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, details: String, imageString: String, createdAt: Date? = nil) {
        self.id = id
        self.details = details
        self.imageString = imageString
        self.createdAt = createdAt
    }
}


extension Receipts {
    struct _Input: Content {
        var details: String
         var imageString: String
        
        init(details: String, imageString: String) {
            self.details = details
            self.imageString = imageString
        }
        
        init(from receipts: Receipts) {
            self.init(details: receipts.details, imageString: receipts.imageString)
        }
    }
}


extension Receipts {
    struct _Output: Content {
        var id: String
        var details: String
        var imageString: String
        var createdAt: Date
        
        init(id: String, details: String, imageString: String, createdAt: Date) {
            self.id = id
            self.details = details
            self.imageString = imageString
            self.createdAt = createdAt
        }
        
        init(from receipts: Receipts) {
            self.init(id: receipts.id!.uuidString, details: receipts.details, imageString: receipts.imageString, createdAt: receipts.createdAt ?? Date())
        }
    }
}

extension Receipts._Input: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("imageString", as: String.self, is: !.empty)
        validations.add("details", as: String.self, is: !.empty)
    }
}


extension Receipts {
    convenience init(from receipts: Receipts.Input) throws {
        self.init(details: receipts.details, imageString: receipts.imageString)
    }
}
