//
//  WitnessFormView.swift
//  ClaimIt
//
//  Witness contact collection
//

import SwiftUI

struct WitnessFormView: View {
    @StateObject private var manager = AccidentModeManager.shared
    @State private var showingAddWitness = false
    @State private var newWitnessName = ""
    @State private var newWitnessPhone = ""
    @State private var newWitnessEmail = ""

    var body: some View {
        VStack(spacing: 0) {
            // Title
            VStack(spacing: 8) {
                Text("Witness Info")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)

                Text("Collect contact information from anyone who saw what happened")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding(.top, 16)
            .padding(.bottom, 20)

            // Witness List or Empty State
            ScrollView {
                VStack(spacing: 16) {
                    if let witnesses = manager.currentReport?.witnesses, !witnesses.isEmpty {
                        ForEach(Array(witnesses.enumerated()), id: \.element.id) { index, witness in
                            WitnessCard(witness: witness) {
                                manager.removeWitness(at: index)
                            }
                        }
                    } else {
                        // Empty state
                        VStack(spacing: 16) {
                            Image(systemName: "person.2.slash")
                                .font(.system(size: 48))
                                .foregroundColor(.white.opacity(0.3))

                            Text("No witnesses added yet")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.5))

                            Text("If anyone saw the accident, their testimony could be valuable for your case.")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.4))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        .padding(.vertical, 40)
                    }

                    // Add Witness Button
                    Button {
                        showingAddWitness = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                            Text("Add Witness")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }

            // Continue Button
            Button {
                manager.nextStep()
            } label: {
                let hasWitnesses = (manager.currentReport?.witnesses.count ?? 0) > 0
                Text(hasWitnesses ? "Continue" : "Skip - No Witnesses")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(hasWitnesses ? Color(hex: "00C48C") : Color.white.opacity(0.2))
                    .cornerRadius(14)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.black.opacity(0.9))
        }
        .background(Color.black)
        .sheet(isPresented: $showingAddWitness) {
            AddWitnessSheet(
                name: $newWitnessName,
                phone: $newWitnessPhone,
                email: $newWitnessEmail,
                onSave: {
                    manager.addWitness(
                        name: newWitnessName,
                        phone: newWitnessPhone,
                        email: newWitnessEmail.isEmpty ? nil : newWitnessEmail
                    )
                    newWitnessName = ""
                    newWitnessPhone = ""
                    newWitnessEmail = ""
                    showingAddWitness = false
                },
                onCancel: {
                    newWitnessName = ""
                    newWitnessPhone = ""
                    newWitnessEmail = ""
                    showingAddWitness = false
                }
            )
        }
    }
}

// MARK: - Witness Card
struct WitnessCard: View {
    let witness: Witness
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            Circle()
                .fill(Color(hex: "00C48C").opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(witness.name.prefix(1)).uppercased())
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: "00C48C"))
                )

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(witness.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Text(witness.phone)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            // Delete
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.3))
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(14)
    }
}

// MARK: - Add Witness Sheet
struct AddWitnessSheet: View {
    @Binding var name: String
    @Binding var phone: String
    @Binding var email: String
    let onSave: () -> Void
    let onCancel: () -> Void

    var isValid: Bool {
        !name.isEmpty && phone.count >= 10
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Contact Information") {
                    TextField("Full Name", text: $name)
                        .textContentType(.name)
                    TextField("Phone Number", text: $phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                    TextField("Email (optional)", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Add Witness")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: onSave)
                        .disabled(!isValid)
                }
            }
        }
    }
}

#Preview {
    WitnessFormView()
}
