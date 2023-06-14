//
//  AudioTrackView.swift
//  UserAudioApp_0608
//
//  Created by Gavin Kwon on 6/8/23.
//

import SwiftUI

struct AudioTrackView: View {
    
    // This array already exists as String array of song titles
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
    
    @State private var song1Items: [(Int,String)] = []
    @State private var song2Items: [(Int,String)] = []
    @State private var song3Items: [(Int,String)] = [
        (1,"audio3"),
        (2,"audio3"),
        (3,"audio3"),
        (4,"audio3"),
        (5,"audio3"),
    ]
    
    
    var body: some View {
        GeometryReader { geo in
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Group {
                        Divider()
                        
                        SelectedTracksTitleView(geo: geo)
                        
                        if errorMessage != nil {
                            ErrorMessageView(geo: geo)
                        }
                        
                        // This button will access user iCloud drive to select audio files
                        if !audioFiles.isEmpty {
                            AudioFilesListView(geo: geo)
                        } else {
                            SelectFilesButtonView(geo: geo)
                        }
                    }
                    .padding()
                    
                    SongsListView(geo: geo)
                    
                    AudioPlayerView(geo: geo)
                }
                .onChange(of: audioFiles) { _ in
                    print(audioFiles)
                    print(fileURLs)
                }
            }
        }
    }
}

// MARK: - View Functions

// MARK: -

extension AudioTrackView {
    
    private func SelectedTracksTitleView(geo: GeometryProxy) -> some View {
        
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
    }
    
    private func ErrorMessageView(geo: GeometryProxy) -> some View {
        Text(errorMessage!)
            .font(Font.custom("Avenir Roman", size: geo.size.width*0.04))
            .foregroundColor(Color("appColor2"))
    }
    
    private func AudioFilesListView(geo: GeometryProxy) -> some View {
        
        ZStack {
            
            Rectangle()
                .cornerRadius(15)
                .foregroundColor(Color("mainColor"))
                .opacity(0.5)
                .shadow(color: Color("shadowColor"), radius: 10)
            
            VStack(spacing: geo.size.width*0.03) {
                
                ForEach(audioFiles.indices, id: \.self) { r in
                    
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
                    .draggable(audioFiles[r]) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color("bgColor4"))
                                .opacity(0.8)
                            Text(audioFiles[r])
                                .font(Font.custom("Avenir Heavy", size: geo.size.width*0.035))
                                .padding(8)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func SelectFilesButtonView(geo: GeometryProxy) -> some View {
        Button(action: {
            openFiles.toggle()
        }, label: {
            ZStack {
                Rectangle()
                    .frame(height: geo.size.height*0.2)
                    .cornerRadius(15)
                    .foregroundColor(Color("mainColor"))
                    .opacity(0.5)
                    .shadow(color: Color("shadowColor"), radius: 10)
                
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

// MARK: - View Functions

// MARK: -

extension AudioTrackView {
    
    private func SongsListView(geo: GeometryProxy) -> some View {
        
        Group {
            
            VStack {
                
                SongsInfoView(geo: geo, title: tracks[0], items: $song1Items)
                
                SongsInfoView(geo: geo, title: tracks[1], items: $song2Items)
                
                SongsInfoView(geo: geo, title: tracks[2], items: $song3Items)
                
            }
            
        }
    }
    
    private func SongsInfoView(geo: GeometryProxy, title: String, items: Binding<[(Int,String)]>) -> some View {
        
        VStack {
            
            SongHeadingView(geo: geo, name: title)
            
            VStack {
                
                Spacer()
                
                SongInfoRowView(geo: geo, items: items)
                
                Spacer()
                Divider()
                Spacer()
                
                SongInfoRowView(geo: geo, items: items)
                
                Spacer()
                
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .frame(height: geo.size.height*0.15)
            .overlay(DragFilesTextView(geo: geo, name: title, count: items.count))
            .background(RectangleBackgroundView(geo: geo))
            .padding(.bottom, geo.size.height*0.02)
            
        }
        .dropDestination(for: String.self) { values, _ in
            guard let item = values.first else { return true }
            items.wrappedValue.append((items.count+1,item))
            audioFiles.removeAll(where: {$0 == item })
            return true
        }
        .padding(.horizontal)

    }
    
    private func SongInfoRowView(geo: GeometryProxy, items: Binding<[(Int,String)]>) -> some View {
        HStack {
            ForEach(items, id: \.self.0) { item in
                Text("\(item.wrappedValue.0)")
                    .frame(height: 30)
                    .frame(maxWidth: geo.size.width/6.8)
                    .background{ Color.gray }
                    .cornerRadius(5)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private func SongHeadingView(geo: GeometryProxy, name: String) -> some View {
        ZStack {
            
            Rectangle()
                .frame(height: geo.size.height*0.04)
                .cornerRadius(6)
                .foregroundColor(Color("textColor3"))
            
            Text(name)
                .font(Font.custom("Avenir Roman", size: geo.size.width*0.04))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, geo.size.width*0.03)
        }
    }
    
    private func DragFilesTextView(geo: GeometryProxy, name: String, count: Int) -> some View {
        Text("Drag your audio file here for\n<\(name)>")
            .font(Font.custom("Avenir Roman", size: geo.size.width*0.04))
            .multilineTextAlignment(.center)
            .foregroundColor(Color("appColor7"))
            .opacity(count > 0 ? 0 : 1)
    }
    
    private func RectangleBackgroundView(geo: GeometryProxy) -> some View {
        Rectangle()
            .frame(height: geo.size.height*0.15)
            .cornerRadius(15)
            .shadow(color: Color("shadowColor"), radius: 10)
            .foregroundColor(Color("mainColor"))
            .opacity(0.5)
    }
    
    private func AudioPlayerView(geo: GeometryProxy) -> some View {
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
                            .foregroundColor(.white)
                    })
                    
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
    
}

// MARK: Preview

// MARK: -

struct AudioTrackView_Previews: PreviewProvider {
    static var previews: some View {
        AudioTrackView()
    }
}
