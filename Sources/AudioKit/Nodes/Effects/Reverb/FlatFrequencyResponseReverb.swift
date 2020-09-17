// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// This filter reiterates the input with an echo density determined by loop time. The attenuation rate is
/// independent and is determined by the reverberation time (defined as the time in seconds for a signal to
/// decay to 1/1000, or 60dB down from its original amplitude).  Output will begin to appear immediately.
/// 
public class FlatFrequencyResponseReverb: AKNode, AKComponent, AKToggleable {

    public static let ComponentDescription = AudioComponentDescription(effect: "alps")

    public typealias AKAudioUnitType = InternalAU

    public private(set) var internalAU: AKAudioUnitType?

    // MARK: - Parameters

    public static let reverbDurationDef = AKNodeParameterDef(
        identifier: "reverbDuration",
        name: "Reverb Duration (Seconds)",
        address: akGetParameterAddress("FlatFrequencyResponseReverbParameterReverbDuration"),
        range: 0 ... 10,
        unit: .seconds,
        flags: .default)

    /// Seconds for a signal to decay to 1/1000, or 60dB down from its original amplitude.
    @Parameter public var reverbDuration: AUValue

    // MARK: - Audio Unit

    public class InternalAU: AudioUnitBase {

        public override func getParameterDefs() -> [AKNodeParameterDef] {
            [FlatFrequencyResponseReverb.reverbDurationDef]
        }

        public override func createDSP() -> AKDSPRef {
            akCreateDSP("FlatFrequencyResponseReverbDSP")
        }

        public func setLoopDuration(_ duration: AUValue) {
            akFlatFrequencyResponseSetLoopDuration(dsp, duration)
        }
    }

    // MARK: - Initialization

    /// Initialize this reverb node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - reverbDuration: Seconds for a signal to decay to 1/1000, or 60dB down from its original amplitude.
    ///   - loopDuration: The loop duration of the filter, in seconds. This can also be thought of as the delay time or “echo density” of the reverberation.  
    ///
    public init(
        _ input: AKNode,
        reverbDuration: AUValue = 0.5,
        loopDuration: AUValue = 0.1
        ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AKAudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            audioUnit.setLoopDuration(loopDuration)

            self.reverbDuration = reverbDuration
        }
        connections.append(input)
    }
}
