//
//  DetailView.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

import SwiftUI

struct DetailView: View {
    @State private var viewModel: DetailViewModel
    @State var redirectBack = false
    @State var scanned = false
    @Environment(\.dismiss) private var dismiss
    @State private var bounceScale: CGFloat = 1.0
    @State private var shouldAnimate = false
    @State var isTaskPresented = false
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                if (viewModel.state.locationInfo.qrScanned){
                    Image(uiImage: viewModel.state.locationInfo.image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(.circle)
                    
                    Text(viewModel.state.locationInfo.story)
                        .font(.callout)
                    
                    
                    if (viewModel.state.locationInfo.completed == false) {
                        //                        MendeluButton(label: "Task", destination: TaskView(viewModel: TaskViewModel(location: viewModel.state.locationInfo), redirectBack: $redirectBack), color: .accent, textColor: .white)
                        SubmitButton(label: "Task") {
                            isTaskPresented = true
                        }
                        
                    }
                }else{
                    Text("Hmmm empty?")
                    Spacer()
                    Text("No, you just need to find a QR code to open this location 😉.")
                    Spacer()
                    Text("But be careful, the QR code is precisely hidden! After you find it, just hit the QR code in the right corner and scan it as you're used to.")
                }
            }
            .padding()
            .toolbar{
                if (viewModel.state.locationInfo.qrScanned){
                    ToolbarItem(placement: .topBarTrailing){
                        HStack(spacing: 6){
                            Button(action:{
                                if (viewModel.state.reading && !viewModel.state.paused){
                                    viewModel.pauseReading()
                                } else if (!viewModel.state.reading && !viewModel.state.paused){
                                    viewModel.read()
                                } else if(!viewModel.state.reading && viewModel.state.paused){
                                    viewModel.continueReading()
                                }
                            }){
                                Image(systemName: !viewModel.state.reading ? "speaker.wave.2.circle" : "pause.circle").foregroundColor(.accent)
                                    .font(.system(size: 25))
                            }
                        }
                    }
                }else{
                    ToolbarItem(placement: .topBarTrailing){
                        HStack(spacing: 6){
                            NavigationLink(destination: QRScanView(viewModel: QRScanViewModel(locationInfo: viewModel.state.locationInfo), scanned: $scanned)){
                                Image(systemName: "qrcode").foregroundColor(.accent)
                            }
                            .scaleEffect(bounceScale)
                                    .animation(
                                        shouldAnimate ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default,
                                        value: bounceScale
                                    )
                                    .onAppear {
                                        shouldAnimate = true
                                        bounceScale = 1.2
                                    }
                                    .onDisappear {
                                        shouldAnimate = false
                                        bounceScale = 1.0
                                    }
                        }
                    }
                }
            }
            .sheet(isPresented: $isTaskPresented) {
                    NavigationStack {
                        TaskView(viewModel: TaskViewModel(location: viewModel.state.locationInfo), redirectBack: $redirectBack)
                            .presentationDetents([.fraction(0.3), .medium, .large])
                            .toolbar {
                                ToolbarItemGroup(placement: .topBarLeading){
                                    Button("Close") {
                                        isTaskPresented = false
                                    }
                                }
                            }
                    }
            }
            .navigationTitle(viewModel.state.locationInfo.name)
            .onAppear(){
                if(scanned){
                    viewModel.changeScanToTrue()
                }
//                if (redirectBack){
//                    redirectBack = false
//                    dismiss()
//                }
            }
            .onDisappear{
                viewModel.stopReading()
            }
            .onChange(of: redirectBack) {
                if (redirectBack){
                    redirectBack = false
                    dismiss()
                }
            }
        }
    }
}
