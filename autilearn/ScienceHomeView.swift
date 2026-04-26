import SwiftUI

struct ScienceHomeView: View {
    @State private var selectedExperiment: ScienceExperiment? = nil

    // Adaptive: 2 cols on iPhone, 3-4 on iPad
    private let columns = [GridItem(.adaptive(minimum: 200, maximum: 320), spacing: 14)]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                headerCard
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(ScienceExperiment.all) { exp in
                        ExperimentCard(experiment: exp) {
                            selectedExperiment = exp
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Science Lab")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedExperiment) { exp in
            ExperimentDetailSheet(experiment: exp)
        }
    }

    private var headerCard: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Fun experiments!")
                    .font(.system(size: 20, weight: .medium))
                Text("Safe to try at home with a grown-up")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(Color(hex: "#1D9E75").alpha(0.12))
                    .frame(width: 56, height: 56)
                Text("🔬")
                    .font(.system(size: 28))
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Experiment grid card

struct ExperimentCard: View {
    let experiment: ScienceExperiment
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                // Big emoji icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: experiment.colorHex))
                        .frame(height: 72)
                    Text(experiment.emoji)
                        .font(.system(size: 38))
                }

                Text(experiment.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(experiment.tagline)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(experiment.scienceTag)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: experiment.tagColorHex))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(hex: experiment.colorHex))
                    .clipShape(Capsule())
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.separator).alpha(0.35), lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Experiment detail sheet

struct ExperimentDetailSheet: View {
    let experiment: ScienceExperiment
    @Environment(\.dismiss) private var dismiss
    @State private var speechEngine = SpeechEngine()
    @State private var currentStep = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Hero
                    heroSection
                        .padding(.horizontal, 20)
                        .padding(.top, 4)

                    // Why it works
                    whySection
                        .padding(.horizontal, 20)

                    // Safety
                    safetySection
                        .padding(.horizontal, 20)

                    // Materials
                    materialsSection
                        .padding(.horizontal, 20)

                    // Steps
                    stepsSection
                        .padding(.horizontal, 20)

                    // Fun fact
                    funFactSection
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                }
            }
            .navigationTitle(experiment.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        speechEngine.speak(experiment.whyItWorks)
                    } label: {
                        Image(systemName: "speaker.wave.2")
                    }
                }
            }
        }
    }

    private var heroSection: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: experiment.colorHex))
                    .frame(width: 72, height: 72)
                Text(experiment.emoji)
                    .font(.system(size: 40))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(experiment.scienceTag)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: experiment.tagColorHex))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color(hex: experiment.colorHex))
                    .clipShape(Capsule())
                Text(experiment.tagline)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
        }
    }

    private var whySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Why it works", systemImage: "lightbulb.fill")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "#BA7517"))
            Text(experiment.whyItWorks)
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(Color(hex: "#FAEEDA").alpha(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var safetySection: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.shield.fill")
                .foregroundColor(Color(hex: "#1D9E75"))
                .font(.system(size: 18))
            Text(experiment.safetyNote)
                .font(.system(size: 13))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(Color(hex: "#1D9E75").alpha(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var materialsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("You need", systemImage: "bag.fill")
                .font(.system(size: 14, weight: .medium))

            FlowLayout(items: experiment.materials) { item in
                Text(item)
                    .font(.system(size: 13))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color(.separator).alpha(0.4), lineWidth: 0.5))
            }
        }
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label("Steps", systemImage: "list.number")
                .font(.system(size: 14, weight: .medium))
                .padding(.bottom, 6)

            ForEach(Array(experiment.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: experiment.tagColorHex))
                            .frame(width: 28, height: 28)
                        Text("\(index + 1)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Text(step)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Button {
                        speechEngine.speak(step)
                    } label: {
                        Image(systemName: "speaker.wave.1")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var funFactSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Fun fact!", systemImage: "star.fill")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "#534AB7"))
            Text(experiment.funFact)
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(Color(hex: "#534AB7").alpha(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// FlowLayout is defined in SharedComponents.swift
