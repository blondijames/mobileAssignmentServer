import Vapor

let seriesMask:[String: String] = {
    var dict = [String: String]()
    for index in 0..<28 {
        dict[UUID().uuidString] = "\(index)"
    }
    return dict
}()

struct Series: Codable, Content {
    var id = UUID().uuidString
    var slices = Array(seriesMask.keys.sorted(by: { Int(seriesMask[$0]!)! < Int(seriesMask[$1]!)! }))
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
              seriesMask.keys.contains(index) else {
                  throw Abort(.notFound, reason: "Slice not found for given id")
              }
        
        let response = request.fileio.streamFile(at: "Public/images/image_\(seriesMask[index]!).jpg")
        return response
    }

}
