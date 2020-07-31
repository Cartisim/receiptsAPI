import Vapor
import Fluent

extension Images {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("images")
            .id()
                .field("image", .data, .required)
                .field("created_at", .date, .required)
            .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("images").delete()
        }
        
        var name: String { "CreateImage" }
    }
}
