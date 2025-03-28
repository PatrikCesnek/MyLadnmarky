//
//  ProfileView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import SwiftUI

struct ProfileView: View {
    var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            if let user = viewModel.user {
                Form {
                    Section(Constants.Strings.profile) {
                        VStack(alignment: .leading) {
                            ProfileCellView(text: user.name, showDivider: true)
                            ProfileCellView(text: user.lastName, showDivider: true)
                            ProfileCellView(text: viewModel.landmarkCountText ?? Constants.Strings.noLandmarks, showDivider: false)
                        }
                    }
                    
                    Section(Constants.Strings.achievementsTitle) {
                        VStack {
                            ProfileCellView(
                                text: Constants.Strings.noAchievements,
                                showDivider: false
                            )
                        }
                    }
                }
            }
        }
        .navigationTitle(Constants.Strings.profile)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(
                action: {},
                label: {
                    Text(Constants.Strings.edit)
                }
            )
        }
    }
}

#Preview {
    ProfileView()
}
