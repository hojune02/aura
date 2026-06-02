import AVFoundation

@MainActor
final class SoundCueService {
    static let shared = SoundCueService()

    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
    private var isPrepared = false

    private init() {}

    func phaseChanged(enabled: Bool) {
        play(enabled: enabled, frequency: 523.25, duration: 0.12, volume: 0.16)
    }

    func completed(enabled: Bool) {
        play(enabled: enabled, frequency: 659.25, duration: 0.18, volume: 0.18)
    }

    private func play(enabled: Bool, frequency: Double, duration: Double, volume: Float) {
        guard enabled else { return }

        do {
            try prepareEngineIfNeeded()
            if !engine.isRunning {
                try engine.start()
            }
        } catch {
            return
        }

        guard let buffer = makeBuffer(frequency: frequency, duration: duration, volume: volume) else {
            return
        }

        if !player.isPlaying {
            player.play()
        }

        player.scheduleBuffer(buffer, at: nil, options: .interrupts)
    }

    private func prepareEngineIfNeeded() throws {
        guard !isPrepared else { return }

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
        try session.setActive(true)

        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)
        engine.prepare()
        isPrepared = true
    }

    private func makeBuffer(frequency: Double, duration: Double, volume: Float) -> AVAudioPCMBuffer? {
        let frameCount = AVAudioFrameCount(duration * format.sampleRate)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount),
              let channel = buffer.floatChannelData?[0] else {
            return nil
        }

        buffer.frameLength = frameCount

        for frame in 0..<Int(frameCount) {
            let progress = Double(frame) / Double(frameCount)
            let sampleTime = Double(frame) / format.sampleRate
            let envelope = sin(progress * .pi)
            let sample = sin(2.0 * .pi * frequency * sampleTime)
            channel[frame] = Float(sample * envelope) * volume
        }

        return buffer
    }
}
