import SwiftUI
import AVFoundation

struct QRScanView: View {
    @State private var viewModel: QRScanViewModel
    @Binding var scanned: Bool
    @Environment(\.dismiss) private var dismiss
    
    @State private var showAlert = false

    init(viewModel: QRScanViewModel, scanned: Binding<Bool>) {
        self.viewModel = viewModel
        self._scanned = scanned
    }

    var body: some View {
        ZStack {
            QRPreviewLayer(session: viewModel.session)
                .onAppear {
                    DispatchQueue.global(qos: .userInitiated).async {
                        viewModel.session.startRunning()
                    }
                }
                .onDisappear {
                    DispatchQueue.global(qos: .userInitiated).async {
                        viewModel.session.stopRunning()
                    }
                }
        }
        .onChange(of: viewModel.state.hasScanned) {
            if viewModel.state.scannedCode == viewModel.state.locationInfo.qrScanText {
                scanned = true
                dismiss()
            } else {
                showAlert = true
            }
        }
//        .alert("Invalid QR code", isPresented: $showAlert) {
//            Button("OK", role: .cancel) {
//                dismiss()
//            }
//        } message: {
//            Text("This QR code is not related to this location. Try another one :]")
//        }
        .edgesIgnoringSafeArea(.all)
        .toolbar(.hidden, for: .tabBar)
        .overlay(
            Group {
                if showAlert {
                    CustomAlertView(
                        title: "Invalid QR code",
                        description: "Try to find the correct one :)",
                        buttonTitle: "OK",
                        onDismiss: {
                            dismiss()
                        }
                    )
                }
            }
        )
    }
}

struct QRPreviewLayer: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
