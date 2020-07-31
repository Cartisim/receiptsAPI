import Vapor
import Fluent

extension Receipts {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("receipts")
            .id()
                .field("image_string", .string, .required)
                 .field("details", .string, .required)
                .field("created_at", .date, .required)
            .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("receipts").delete()
        }
        
        var name: String { "CreateReceipt" }
    }
}

