import Vapor
import Fluent

func routes(_ app: Application) throws {
    app.group("api") { api in
        
    let imagesController = ImagesController()
//        api.post("createImage", use: imagesController.createImage)
//        api.delete("deleteImage", use: imagesController.deleteImage)
//        api.get("fetchImages", use: imagesController.fetchImages)
//        api.get("fetchImage", use: imagesController.fetchImage)
        
        api.post("createImageDataLink", ":receiptID", use: imagesController.addReceipt)
        api.get("getImageURL", ":receiptID", use: imagesController.fetchImageURL)
        api.delete("deleteImage", ":receiptID", use: imagesController.deleteReceipt)
        
        let receiptController = ReceiptController()
            api.post("createReceipt", use: receiptController.createReceipt)
            api.delete("deleteReceipt", ":receiptID", use: receiptController.deleteReceipt)
            api.get("fetchReceipts", use: receiptController.fetchReceipts)
            api.get("fetchReceipt", ":receiptID", use: receiptController.fetchReceipt)

    }
}

