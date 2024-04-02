import SwiftUI
public struct TransitionPhaseAnimator<T: Equatable, Trigger: Equatable, V: View>: View {
    let restPhase: (Trigger) -> T
    let transitionPhases: (Trigger, Trigger) -> Array<T>
    let trigger: Trigger
    @ViewBuilder
    let content: (T) -> V
    @State var currentIndex = 0
    @State var currentPhases: [T]
    public init(restPhase: @escaping (Trigger) -> T, transitionPhases: @escaping (Trigger, Trigger) -> Array<T>, trigger: Trigger, content: @escaping (T) -> V) {
        self.restPhase = restPhase
        self.transitionPhases = transitionPhases
        self.trigger = trigger
        self.content = content
        _currentPhases = State(initialValue: [restPhase(trigger)])
    }
    public var body: some View {
        content(currentPhase)
            .onChange(of: trigger) { oldValue, newValue in
                setTransitionPhases(oldValue: oldValue, newValue: newValue)
                incrementPhase()
            }
    }
    
    var currentPhase: T {
        return currentPhases[currentIndex]
    }
    
    func setTransitionPhases(oldValue: Trigger, newValue: Trigger) {
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

