import Vapor

func migrations(_ app: Application) throws {
    app.migrations.add(Images.Migration())
    app.migrations.add(Receipts.Migration())
    try app.autoMigrate().wait()
}
