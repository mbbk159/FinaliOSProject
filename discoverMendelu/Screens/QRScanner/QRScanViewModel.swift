import Foundation
import AVFoundation

@Observable
final class QRScanViewModel: NSObject, AVCaptureMetadataOutputObjectsDelegate, ObservableObject {
    var state: QRScanState
    var session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var dataManager: DataManaging
    var metadataOutput = AVCaptureMetadataOutput()
    
    init(locationInfo: LocationInfo) {
        state = QRScanState(locationInfo: locationInfo)
        dataManager = DIContainer.shared.resolve()
        super.init()
        setupScanner()
    }
    
    private func setupScanner() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }
        
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        }
        
        metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspectFill
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            
            session.stopRunning()
            
            DispatchQueue.main.async {
                self.state.scannedCode = stringValue
                self.state.hasScanned = true
            }
        }
    }
}
