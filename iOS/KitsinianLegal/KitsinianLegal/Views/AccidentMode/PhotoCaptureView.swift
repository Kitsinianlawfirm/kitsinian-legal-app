//
//  PhotoCaptureView.swift
//  ClaimIt
//
//  Photo checklist for accident evidence
//

import SwiftUI

struct PhotoCaptureView: View {
    @StateObject private var manager = AccidentModeManager.shared
    @State private var showingCamera = false
    @State private var selectedPhotoType: AccidentPhoto.PhotoType?

    var body: some View {
        VStack(spacing: 0) {
            // Title
            VStack(spacing: 8) {
                Text("Photo Evidence")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)

                Text("Capture these 8 critical photos")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.7))

                // Progress
                Text("\(manager.photoCount()) of 8 photos taken")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "00C48C"))
                    .padding(.top, 4)
            }
            .padding(.top, 16)
            .padding(.bottom, 20)

            // Photo Grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    ForEach(AccidentPhoto.PhotoType.allCases, id: \.self) { type in
                        PhotoTypeCard(
                            type: type,
                            isCaptured: manager.hasPhoto(ofType: type),
                            onTap: {
                                selectedPhotoType = type
                                showingCamera = true
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }

            // Continue Button
            VStack(spacing: 8) {
                Button {
                    manager.nextStep()
                } label: {
                    Text(manager.canProceedFromPhotos ? "Continue" : "Skip for Now")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            manager.canProceedFromPhotos
                                ? Color(hex: "00C48C")
                                : Color.white.opacity(0.2)
                        )
                        .cornerRadius(14)
                }
                .padding(.horizontal, 16)

                if !manager.canProceedFromPhotos {
                    Text("Take at least 3 photos to continue")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding(.vertical, 16)
            .background(Color.black.opacity(0.9))
        }
        .background(Color.black)
        .sheet(isPresented: $showingCamera) {
            // TODO: Replace with actual camera view
            CameraPlaceholderView(
                photoType: selectedPhotoType,
                onCapture: { path in
                    if let type = selectedPhotoType {
                        manager.addPhoto(type: type, localPath: path)
                    }
                    showingCamera = false
                },
                onCancel: {
                    showingCamera = false
                }
            )
        }
    }
}

// MARK: - Photo Type Card
struct PhotoTypeCard: View {
    let type: AccidentPhoto.PhotoType
    let isCaptured: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isCaptured ? Color(hex: "00C48C").opacity(0.2) : Color.white.opacity(0.1))
                        .frame(height: 80)

                    if isCaptured {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(Color(hex: "00C48C"))
                    } else {
                        Image(systemName: type.icon)
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }

                Text(type.displayName)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isCaptured ? Color(hex: "00C48C") : Color.white.opacity(0.1),
                                lineWidth: isCaptured ? 2 : 1
                            )
                    )
            )
        }
    }
}

// MARK: - Camera Placeholder (temporary)
struct CameraPlaceholderView: View {
    let photoType: AccidentPhoto.PhotoType?
    let onCapture: (String) -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "camera.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.gray)

                Text("Camera Preview")
                    .font(.title2.weight(.semibold))

                if let type = photoType {
                    Text(type.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()

                // Simulate capture
                Button {
                    // Generate a fake path for now
                    let path = "photos/\(UUID().uuidString).jpg"
                    onCapture(path)
                } label: {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 4)
                                .frame(width: 80, height: 80)
                        )
                }
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onCancel() }
                }
            }
        }
    }
}

#Preview {
    PhotoCaptureView()
}
