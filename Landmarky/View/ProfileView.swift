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
        NavigationView {
            VStack(alignment: .leading) {
                if let user = viewModel.user {
                    Form {
                        Section(Constants.strings.profile) {
                            VStack(alignment: .leading) {
                                ProfileCellView(text: user.name, showDivider: true)
                                ProfileCellView(text: user.lastName, showDivider: true)
                                ProfileCellView(text: viewModel.landmarkCountText ?? Constants.strings.noLandmarks, showDivider: false)
                            }
                        }
                        
                        Section(Constants.strings.achievementsTitle) {
                            VStack {
                                ProfileCellView(text: Constants.strings.noAchievements, showDivider: false)
                            }
                        }
                    }
                }
            }
            .navigationTitle(Constants.strings.profile)
            .onAppear {
                viewModel.createMockUser()
            }
        }
    }
}

#Preview {
    ProfileView()
}
