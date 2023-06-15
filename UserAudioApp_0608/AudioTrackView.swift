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
    
    // Show/Hide third row
    @State private var showThirdRow = false
    
    // Error messages
    @State private var errorMessage: String?
    
    @State private var song1Items: [[String]] = [[],[]]
    @State private var song2Items: [[String]] = [[],[]]
    @State private var song3Items: [[String]] = //[[],[]]
    [
        [ "audio1", "audio2", "audio3", "audio4", "audio5", "audio6", "audio7", "audio8" ],
        [ "audio11", "audio22", "audio33"]
    ]
    
    @State private var song1Title: String = ""
    @State private var song2Title: String = ""
    @State private var song3Title: String = ""
    
    var body: some View {
        
        GeometryReader { geo in
            
            ScrollView(showsIndicators: false) {
                
                VStack {
                    
                    //-------------------------------------------------- Audio Files
                    
                    AudioFilesView(geo: geo)
                    
                    //-------------------------------------------------- Songs
                    
                    SongsListView(geo: geo)
                    
                    //-------------------------------------------------- Audio Player
                    
                    AudioPlayerView(geo: geo)
                    
                }
                
            }
        }
    }
    
}


// MARK: - Audio Files View Functions
// MARK: -
extension AudioTrackView {
    
    private func AudioFilesView(geo: GeometryProxy) -> some View {
        
        Group {
            
            Divider()
            
            //-------------------------------------------------- Title
            
            AudioFilesTitleView(geo: geo)
            
            
            if errorMessage != nil {
                
                //-------------------------------------------------- Error Message
                
                ErrorMessageView(geo: geo)
            }
            
            
            if !audioFiles.isEmpty {
                
                //-------------------------------------------------- Selected Files List
                
                AudioFilesListView(geo: geo)
                
            }
            else {
                
                //-------------------------------------------------- Open iCloud Files Button
                
                SelectFilesButtonView(geo: geo)
                
            }
            
        }
        .padding()
        //-------------------------------------------------- Audio Files Imported
        .fileImporter(isPresented: $openFiles, allowedContentTypes: [.audio], allowsMultipleSelection: true) { result in filesImported(result: result)}
        //-------------------------------------------------- Audio Files Changed
        .onChange(of: audioFiles) { _ in
            print(audioFiles)
            print(fileURLs)
        }
        .dropDestination(for: String.self) { values, _ in
            guard let item = values.first else { return true }
            removeFromAllSongs(itemToRemove: item)
            audioFiles.append(item)
            return true
        }

    }
    
    private func AudioFilesTitleView(geo: GeometryProxy) -> some View {
        
        HStack {
            
            //-------------------------------------------------- Title
            
            Text("AUDIO TRACKS")
                .font(Font.custom("Futura Medium", size: geo.size.width*0.04))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if !audioFiles.isEmpty {
                
                HStack(spacing: geo.size.width*0.04) {
                    
                    //-------------------------------------------------- Remove Files Button
                    
                    Button(action: {
                        audioFiles.removeAll()
                        fileURLs.removeAll()
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width*0.07)
                    })
                    
                    //-------------------------------------------------- Add Files Button
                    
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
    
    }
    
    private func ErrorMessageView(geo: GeometryProxy) -> some View {
        
        Text(errorMessage!)
            .font(Font.custom("Avenir Roman", size: geo.size.width*0.04))
            .foregroundColor(Color("appColor2"))
        
    }
    
    private func AudioFilesListView(geo: GeometryProxy) -> some View {
        
        ZStack {
            
            //-------------------------------------------------- Background Rectangle
            
            AudioFilesListBackgroundView()
            
            ScrollView {
                
                LazyVStack(spacing: geo.size.width*0.03) {
                    
                    //-------------------------------------------------- List of Files
                    
                    ForEach(audioFiles.indices, id: \.self) { r in
                        
                        //-------------------------------------------------- File Row View
                        
                        Text(audioFiles[r])
                            .font(Font.custom("Avenir Heavy", size: geo.size.width*0.035))
                            .padding(8)
                            .frame(maxWidth: .greatestFiniteMagnitude)
                            .background{ AudioFilesRowBackgroundView() }
                            .draggable(audioFiles[r]) { DragView(title: audioFiles[r], geo: geo) }
                    }
                }
                .padding()
                
            }
            
        }
        .frame(height: geo.size.height*0.2)
    }
    
    private func DragView(title: String, geo: GeometryProxy) -> some View {
        
        Text(title)
            .font(Font.custom("Avenir Heavy", size: geo.size.width*0.035))
            .padding(8)
            .background {
                Rectangle()
                    .foregroundColor(Color("bgColor4"))
                    .opacity(0.8)
            }
        
    }
    
    private func SelectFilesButtonView(geo: GeometryProxy) -> some View {
        
        Button(action: {
            openFiles.toggle()
        }, label: {
            
            VStack(spacing: geo.size.height*0.02) {
                
                //-------------------------------------------------- Icon
                
                Image(systemName: "folder.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width*0.1)
                    .bold()
                
                
                //-------------------------------------------------- Text
                
                Text("Select Audio Files from iCloud Drive")
                    .font(Font.custom("Avenir Roman", size: geo.size.width*0.04))
                
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .frame(height: geo.size.height*0.2)
            .background{ AudioFilesListBackgroundView() }
            .foregroundColor(Color("appColor7"))
            
        })
    }
    
}


// MARK: - Song View Functions
// MARK: -
extension AudioTrackView {
    
    private func SongsListView(geo: GeometryProxy) -> some View {
        
        Group {
            
            VStack {
                
                //-------------------------------------------------- Song 1
                
                SongsInfoView(title: tracks[0], items: $song1Items, songTitle: $song1Title, geo: geo)
                
                //-------------------------------------------------- Song 2
                
                SongsInfoView(title: tracks[1], items: $song2Items, songTitle: $song2Title, geo: geo)
                
                //-------------------------------------------------- Song 3
                
                SongsInfoView(title: tracks[2], items: $song3Items, songTitle: $song3Title, geo: geo)
                
            }
            
        }
    }
    
    private func SongsInfoView(title: String, items: Binding<[[String]]>, songTitle: Binding<String>, geo: GeometryProxy) -> some View {
        
        VStack {
            
            //-------------------------------------------------- Heading
            
            SongHeadingView(geo: geo, name: title, songTitle: songTitle.wrappedValue)
            
            VStack(spacing: 0) {
                
                //-------------------------------------------------- Row 1
                
                SongInfoRowView(geo: geo, items: items[0], songTitle: songTitle)
                
                Divider()
                
                //-------------------------------------------------- Row 2
                
                SongInfoRowView(geo: geo, items: items[1], songTitle: songTitle)
                
                
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .frame(height: geo.size.height*0.15)
            .overlay(DragSongFilesView(geo: geo, name: title, count: getItemsCount(items: items.wrappedValue)))
            .background(SongInfoBackgroundView(geo: geo))
            .padding(.bottom, geo.size.height*0.02)
            
        }
        .padding(.horizontal)

    }
    
    private func SongInfoRowView(geo: GeometryProxy, items: Binding<[String]>, songTitle: Binding<String>) -> some View {
        
        ScrollView(.horizontal, showsIndicators: false){
            
            HStack {
                
                ForEach(items, id: \.self) { item in
                    
                    Text(getIndex(title: item.wrappedValue, items: items.wrappedValue))
                        .frame(height: 30)
                        .frame(width: geo.size.width/6.8)
                        .background(Color.gray.opacity(songTitle.wrappedValue == item.wrappedValue ? 0.5 : 0))
                        .background{ AudioFilesRowBackgroundView() }
                        .cornerRadius(10)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            songTitle.wrappedValue = item.wrappedValue
                        }
                        .draggable(String(item.wrappedValue)) {
                            DragView(title: item.wrappedValue, geo: geo)
                        }
                    
                }
                
                Spacer()
                
            }
            .frame(maxHeight: .greatestFiniteMagnitude)
            .padding(.horizontal)
        }
        .dropDestination(for: String.self) { values, _ in
            guard let item = values.first else { return true }
            removeFromAllSongs(itemToRemove: item)
            items.wrappedValue.append(item)
            audioFiles.removeAll(where: {$0 == item })
            return true
        }

    }
    
    private func SongHeadingView(geo: GeometryProxy, name: String, songTitle: String) -> some View {
        
        HStack {
            
            Text(name)
                .font(Font.custom("Avenir Roman", size: geo.size.width*0.04))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(songTitle)
                .font(Font.custom("Avenir Roman", size: geo.size.width*0.04))
                .foregroundColor(.white)

            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, geo.size.width*0.03)
        .background {
            Rectangle()
                .frame(height: geo.size.height*0.04)
                .cornerRadius(6)
                .foregroundColor(Color("textColor3"))
        }
        
        
    }
    
    private func DragSongFilesView(geo: GeometryProxy, name: String, count: Int) -> some View {
        Text("Drag your audio file here for\n<\(name)>")
            .font(Font.custom("Avenir Roman", size: geo.size.width*0.04))
            .multilineTextAlignment(.center)
            .foregroundColor(Color("appColor7"))
            .opacity(count > 0 ? 0 : 1)
            .allowsHitTesting(false)
    }
    
}


// MARK: - Audio Player Functions
// MARK: -
extension AudioTrackView {
    
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


// MARK: - Helper View Functions
// MARK: -
extension AudioTrackView {
    
    private func DividerView() -> some View {
        
        Group {
            Spacer()
            Divider()
            Spacer()
        }
        
    }
    
    private func AudioFilesListBackgroundView() -> some View {
        
        Rectangle()
            .cornerRadius(15)
            .foregroundColor(Color("mainColor"))
            .opacity(0.5)
            .shadow(color: Color("shadowColor"), radius: 10)
        
    }
    
    private func AudioFilesRowBackgroundView(cornerRadius: CGFloat = 10) -> some View {
        
        Rectangle()
            .cornerRadius(cornerRadius)
            .foregroundColor(Color("bgColor4"))
            .opacity(0.8)
            .shadow(color: Color("selectedColor"), radius: 0.1, x: 2, y: 3)
        
    }
    
    private func SongInfoBackgroundView(geo: GeometryProxy) -> some View {
        Rectangle()
            .frame(height: geo.size.height*0.15)
            .cornerRadius(15)
            .shadow(color: Color("shadowColor"), radius: 10)
            .foregroundColor(Color("mainColor"))
            .opacity(0.5)
    }
    
}


// MARK: - Helper Functions
// MARK: -
extension AudioTrackView {
    
    private func getIndex(title: String, items: [String]) -> String {
        "\((items.firstIndex(of: title) ?? -1) + 1)"
    }
    
    private func filesImported(result: Result<[URL], Error>) {
        
        do {
            let fileURLs = try result.get()
            self.fileURLs = fileURLs
            self.audioFiles = fileURLs.map { $0.lastPathComponent }
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }
    
    private func getItemsCount(items: [[String]]) -> Int {
        items.flatMap({$0}).count
    }
    
    private func removeFromAllSongs(itemToRemove: String) {
        
        for i in 0..<song1Items.count {
            song1Items[i].removeAll(where: { $0 == itemToRemove })
        }
        
        for i in 0..<song2Items.count {
            song2Items[i].removeAll(where: { $0 == itemToRemove })
        }
        
        for i in 0..<song3Items.count {
            song3Items[i].removeAll(where: { $0 == itemToRemove })
        }
        
    }



}


// MARK: Preview
// MARK: -
struct AudioTrackView_Previews: PreviewProvider {
    static var previews: some View {
        AudioTrackView()
    }
}
