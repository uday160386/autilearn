import Foundation
import SwiftData

// MARK: - Math operation type

enum MathOperation: String, CaseIterable, Codable {
    case addition, subtraction, multiplication, division

    var symbol: String {
        switch self {
        case .addition:       return "+"
        case .subtraction:    return "−"
        case .multiplication: return "×"
        case .division:       return "÷"
        }
    }

    var displayName: String {
        switch self {
        case .addition:       return "Add"
        case .subtraction:    return "Subtract"
        case .multiplication: return "Multiply"
        case .division:       return "Divide"
        }
    }

    var colorHex: String {
        switch self {
        case .addition:       return "#1D9E75"
        case .subtraction:    return "#D85A30"
        case .multiplication: return "#534AB7"
        case .division:       return "#BA7517"
        }
    }

    var icon: String {
        switch self {
        case .addition:       return "plus.circle.fill"
        case .subtraction:    return "minus.circle.fill"
        case .multiplication: return "multiply.circle.fill"
        case .division:       return "divide.circle.fill"
        }
    }

    /// Max value for each operand when generating problems
    var maxOperand: Int {
        switch self {
        case .addition:       return 10
        case .subtraction:    return 10
        case .multiplication: return 10
        case .division:       return 10
        }
    }

    /// Generate a random problem ensuring whole-number answers
    func randomProblem() -> MathProblem {
        switch self {
        case .addition:
            let a = Int.random(in: 1...maxOperand)
            let b = Int.random(in: 1...maxOperand)
            return MathProblem(a: a, b: b, operation: self)

        case .subtraction:
            let a = Int.random(in: 1...maxOperand)
            let b = Int.random(in: 1...a)          // ensure a ≥ b → non-negative result
            return MathProblem(a: a, b: b, operation: self)

        case .multiplication:
            let a = Int.random(in: 1...maxOperand)
            let b = Int.random(in: 1...maxOperand)
            return MathProblem(a: a, b: b, operation: self)

        case .division:
            let b = Int.random(in: 1...maxOperand)
            let answer = Int.random(in: 1...maxOperand)
            return MathProblem(a: b * answer, b: b, operation: self)  // always whole answer
        }
    }
}

// MARK: - A single math problem

struct MathProblem {
    let a: Int
    let b: Int
    let operation: MathOperation

    var answer: Int {
        switch operation {
        case .addition:       return a + b
        case .subtraction:    return a - b
        case .multiplication: return a * b
        case .division:       return a / b
        }
    }

    /// How many visual dots to show (capped for display)
    var dotCount: Int {
        switch operation {
        case .addition:       return min(a + b, 20)
        case .subtraction:    return min(a, 20)
        case .multiplication: return min(a * b, 20)
        case .division:       return min(a, 20)
        }
    }
}

// MARK: - SwiftData model: persisting each math attempt

@Model
class MathAttempt {
    var id: UUID
    var operation: String
    var questionA: Int
    var questionB: Int
    var correctAnswer: Int
    var givenAnswer: Int
    var wasCorrect: Bool
    var timestamp: Date

    init(problem: MathProblem, givenAnswer: Int) {
        self.id            = UUID()
        self.operation     = problem.operation.rawValue
        self.questionA     = problem.a
        self.questionB     = problem.b
        self.correctAnswer = problem.answer
        self.givenAnswer   = givenAnswer
        self.wasCorrect    = givenAnswer == problem.answer
        self.timestamp     = Date()
    }
}
