//
//  AudioTrackView.swift
//  UserAudioApp_0608
//
//  Created by Gavin Kwon on 6/8/23.
//

import SwiftUI

struct AudioTrackView: View {
    
    // This array already exists as String array of song titles, might be modified
    @State var tracks = ["Song One", "Song Two", "Song Three"]
    
    // This array will save the newly downloaded audio file names
    @State var audioFiles: [String] = []
    
    // This array will save filePath of downloaded audio files
    @State private var fileURLs: [URL] = []
    
    // This variable will trigger fileImport modifier
    @State var openFiles = false
    
    // Audio Player on/off button
    @State private var isPlayerOn = false
    
    // Error messages
    @State private var errorMessage: String?
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Group {
                    HStack {
                        Text("AUDIO TRACKS")
                            .font(Font.custom("Futura Medium", size: geo.size.width*0.04))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if !audioFiles.isEmpty {
                            HStack(spacing: geo.size.width*0.04) {
                                Button(action: {
                                    audioFiles.removeAll()
                                    fileURLs.removeAll()
                                }, label: {
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geo.size.width*0.07)
                                })
                                Button(action: {
                                    openFiles.toggle()
                                }, label: {
                                    Image(systemName: "folder.badge.plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geo.size.width*0.08)
                                })
                            }
                            .bold()
                            .opacity(0.6)
                            .foregroundColor(Color("appColor7"))
                        }
                    }
                    .padding()
                    if errorMessage != nil {
                        Text(errorMessage!)
                            .font(Font.custom("Avenir Roman", size: geo.size.width*0.04))
                            .frame(height: geo.size.height*0.001)
                            .foregroundColor(Color("appColor2"))
                    }
                    ZStack {
                        Rectangle()
                            .cornerRadius(15)
                            .foregroundColor(Color("mainColor"))
                            .opacity(0.5)
                            .shadow(color: Color("shadowColor"), radius: 10)
                        // This button will access user iCloud drive to select audio files
                        if !audioFiles.isEmpty {
                            ZStack {
                                ScrollView {
                                    VStack(spacing: geo.size.width*0.03) {
                                        ForEach(audioFiles.indices, id:\.self) { r in
                                            ZStack {
                                                Rectangle()
                                                    .cornerRadius(10)
                                                    .foregroundColor(Color("bgColor4"))
                                                    .opacity(0.8)
                                                    .shadow(color: Color("selectedColor"), radius: 0.1, x: 2, y: 3)
                                                Text(audioFiles[r])
                                                    .font(Font.custom("Avenir Heavy", size: geo.size.width*0.035))
                                                    .padding(8)
                                            }
                                        }
                                    }
                                    .padding()
                                }
                            }
                        } else {
                            Button(action: {
                                openFiles.toggle()
                            }, label: {
                                ZStack {
                                    VStack(spacing: geo.size.height*0.02) {
                                        Image(systemName: "folder.badge.plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geo.size.width*0.1)
                                            .bold()
                                        Text("Select Audio Files from iCloud Drive")
                                            .font(Font.custom("Avenir Roman", size: geo.size.width*0.04))
                                    }
                                    .foregroundColor(Color("appColor7"))
                                }
                            })
                        }
                        
                    }
                    .frame(height: geo.size.height*0.22)
                    .padding(.horizontal)
                }
                .fileImporter(
                    isPresented: $openFiles,
                    allowedContentTypes: [.audio],
                    allowsMultipleSelection: true
                ) { result in
                    do {
                        let fileURLs = try result.get()
                        self.fileURLs = fileURLs
                        self.audioFiles = fileURLs.map { $0.lastPathComponent }
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
                ScrollView(showsIndicators: false) {
                    VStack {
                        VStack {
                            ForEach(tracks.indices, id:\.self) { index in
                                VStack {
                                    ZStack {
                                        Rectangle()
                                            .frame(height: geo.size.height*0.04)
                                            .cornerRadius(6)
                                            .foregroundColor(Color("textColor3"))
                                        Text(tracks[index])
                                            .font(Font.custom("Avenir Roman", size: geo.size.width*0.04))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, geo.size.width*0.03)
                                    }
                                    ZStack {
                                        Rectangle()
                                            .frame(height: geo.size.height*0.15)
                                            .cornerRadius(15)
                                            .shadow(color: Color("shadowColor"), radius: 10)
                                            .foregroundColor(Color("mainColor"))
                                            .opacity(0.5)
                                        Text("Drag your audio files here for\n<\(tracks[index])>")
                                            .font(Font.custom("Avenir Roman", size: geo.size.width*0.04))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("appColor7"))
                                    }
                                    .padding(.bottom, geo.size.height*0.02)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top, 7)
                        Group {
                            Divider()
                            Text("AUDIO PLAYER")
                                .font(Font.custom("Futura Medium", size: geo.size.width*0.04))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            ZStack {
                                Rectangle()
                                    .frame(height: geo.size.height*0.15)
                                    .cornerRadius(15)
                                    .shadow(color: Color("shadowColor"), radius: 10)
                                    .foregroundColor(Color("selectedColor"))
                                    .opacity(0.8)
                                HStack(spacing: geo.size.width*0.08) {
                                    Button(action: {}, label: {
                                        Image(systemName: "backward.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geo.size.width*0.12)
                                            .foregroundColor(.white)
                                    })
                                    Button(action: {
                                        isPlayerOn.toggle()
                                    }, label: {
                                        Image(systemName: isPlayerOn ? "pause.circle.fill" : "play.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geo.size.width*0.17)
                                        .foregroundColor(.white)})
                                    Button(action: {}, label: {
                                        Image(systemName: "forward.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geo.size.width*0.12)
                                            .foregroundColor(.white)
                                    })
                                }
                            }
                        }
                        .padding()
                    }
                    .onChange(of: audioFiles) { _ in
                        print(audioFiles)
                        print(fileURLs)
                    }
                }
            }
        }
    }
}

struct AudioTrackView_Previews: PreviewProvider {
    static var previews: some View {
        AudioTrackView()
    }
}
