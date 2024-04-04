import SwiftUI
public protocol AnimationPhase: Equatable {
    var animation: Animation? { get }
}

public extension AnimationPhase {
    var animation: Animation? {
        .default
    }
}

public struct TransitionPhaseAnimator<Phase: AnimationPhase, S: Sequence<Phase>, ViewState: Equatable, V: View>: View {
    let restPhase: (ViewState) -> Phase
    let transitionPhases: (ViewState, ViewState) -> S
    let trigger: ViewState
    @ViewBuilder
    let content: (Phase) -> V
    @State var currentIndex = 0
    @State var currentPhases: [Phase]
    
    public init(restPhase: @escaping (ViewState) -> Phase, transitionPhases: @escaping (ViewState, ViewState) -> S, trigger: ViewState, content: @escaping (Phase) -> V) {
        self.restPhase = restPhase
        self.transitionPhases = transitionPhases
        self.trigger = trigger
        self.content = content
        _currentPhases = State(initialValue: [restPhase(trigger)])
    }
    public var body: some View {
        content(currentPhase)
            .animation(currentPhase.animation, value: currentIndex)
            .onChange(of: trigger) { oldValue, newValue in
                setTransitionPhases(oldValue: oldValue, newValue: newValue)
                incrementPhase()
            }
    }
    
    var currentPhase: Phase {
        currentPhases[currentIndex]
    }
    
    func setTransitionPhases(oldValue: ViewState, newValue: ViewState) {
        currentIndex = 0
        let currentPhase = restPhase(oldValue)
        var phases = [currentPhase]
        phases.append(contentsOf: transitionPhases(oldValue, newValue))
        let finalPhase = restPhase(newValue)
        phases.append(finalPhase)
        currentPhases = phases
    }
    
    func incrementPhase() {
        if currentIndex < currentPhases.count - 1 {
            withAnimation {
                currentIndex += 1
            }
            completion: {
                incrementPhase()
            }
        }
    }
}

