import Vapor

struct Series: Codable, Content {
    var id = UUID().uuidString
    var slices = (0..<28).map {"\($0)"}
}

let series = Series()

func routes(_ app: Application) throws {

    app.get("series") { req -> Series in
        return series
    }
    
    app.get("series", ":seriesId", "slice", ":index") {
         request -> Response in
        guard let id = request.parameters.get("seriesId"), id == series.id else {
            throw Abort(.notFound, reason: "Series not found for given id")
        }
        guard let index = request.parameters.get("index"),
              let indexVal = Int(index), (0..<28).contains(indexVal) else {
                  throw Abort(.notFound, reason: "Slice not found for given id")
              }
        
        let response = request.fileio.streamFile(at: "Public/images/image_\(index).jpg")
        return response
    }

}
