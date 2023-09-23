//
//  MetronomeView.swift
//  v10 Watch App
//
//  Created by Timucin Uygungil on 9/22/23.
//

import SwiftUI
import AVFoundation

struct MetronomeView: View {
    @State private var isPlaying = false
    @State private var bpm: Double = 120.0
    @State private var timer: Timer?
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack(spacing: 20) {
            Text("\(Int(bpm)) BPM")
                .font(.title)

            Button(action: toggleMetronome) {
                Text(isPlaying ? "Stop" : "Start")
            }
        }
        .focusable(true)
        .digitalCrownRotation($bpm, from: 40.0, through: 240.0, by: 1.0, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
        .onAppear(perform: {
            setUpAudioPlayer()
            
            if #available(watchOS 10.0, *) {
                // WatchOS 10 specific code
                // You may not need anything here if the setup is generic
            } else {
                // Fallback on earlier versions
            }
        })
        .onDisappear(perform: stopMetronome)
        .onChange(of: bpm) { _ in
            if #available(watchOS 10.0, *) {
                if isPlaying {
                    stopMetronome()
                    startMetronome()
                }
            }
        }
    }

    func toggleMetronome() {
        isPlaying.toggle()

        if isPlaying {
            startMetronome()
        } else {
            stopMetronome()
        }
    }

    func startMetronome() {
        stopMetronome() // Invalidate any existing timer first
        let interval = 60.0 / bpm
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.audioPlayer?.play()
            WKInterfaceDevice.current().play(.click)
        }
    }

    func stopMetronome() {
        timer?.invalidate()
        timer = nil
        audioPlayer?.stop()
    }

    func setUpAudioPlayer() {
        if let soundURL = Bundle.main.url(forResource: "chic", withExtension: "m4a") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print("Error initializing audio player")
            }
        }
    }
}

struct MetronomeView_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeView()
    }
}
