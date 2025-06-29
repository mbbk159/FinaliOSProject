import Foundation

@Observable
final class QRScanState {
    var scannedCode: String? = nil
    var hasScanned: Bool = false
    var locationInfo: LocationInfo

    init(locationInfo: LocationInfo) {
        self.locationInfo = locationInfo
    }
}
