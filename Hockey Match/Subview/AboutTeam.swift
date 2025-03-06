//
//  AboutTeam.swift
//  Hockey Match
//
//  Created by DF on 06/06/24.
//

import SwiftUI

struct AboutTeam: View {
    @Binding var choosedTeam: TeamHockey?
    @State var teamMock: TeamModel = .init()
    @State var editTeam: Bool = false
    @State var navigationTitle: String = "New team"
    @Binding var dismiss: Bool
    var body: some View {
        NavigationView {
            mainBody
                .navigationTitle(navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            editTeam.toggle()
                        }, label: {
                            Text("Edit")
                        })
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss.toggle()
                        }, label: {
                            HStack(spacing: 3) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        })
                    }
                }
                .sheet(isPresented: $editTeam, content: {
                    CreateTeam(choosedTeam: $choosedTeam, editMode: true, dismiss: $editTeam)
                })
                .onAppear() {
                    navigationTitle = choosedTeam?.nameTeam ?? "Team"
                }
        }
    }
    
    private var mainBody: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack(spacing: 35) {
                image
                information
                players
            }
            .padding(.horizontal, 16)
            .padding(.top, 25)
        })
    }
    
    private var image: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white.opacity(0.05))
            .overlay(
                VStack {
                    if let imageData = choosedTeam?.logoTeam {
                        Image(uiImage: UIImage(data: imageData) ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .background(Color.white)
                    } else {
                        VStack(spacing: 20) {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 70)
                            Text("+ Add Logo")
                                .font(Font.system(size: 17, weight: .semibold))
                        }
                    }
                }
            )
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .foregroundColor(.gray.opacity(0.5))
    }
    
    private var information: some View {
        VStack(alignment: .leading) {
            Text(choosedTeam?.nameTeam ?? "No name")
                .font(Font.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            HStack {
                VStack( content: {
                    Text("Total matches:")
                        .font(Font.system(size: 13, weight: .regular))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .lineLimit(2)
                    Text("\(choosedTeam?.totalMatchesTeam ?? "0")")
                        .foregroundColor(.white)
                        .font(Font.system(size: 34, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                })
                .padding(16)
                .frame(height: 120)
                .cornerRadiusWithBorder(radius: 20, borderLineWidth: 1, borderColor: .gray, antialiased: true)
                
                VStack( content: {
                    Text("Winning:")
                        .font(Font.system(size: 13, weight: .regular))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .lineLimit(2)
                    Text("\(choosedTeam?.winTeam ?? "0")")
                        .foregroundColor(.blue)
                        .font(Font.system(size: 34, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                })
                .padding(16)
                .frame(height: 120)
                .cornerRadiusWithBorder(radius: 20, borderLineWidth: 1, borderColor: .gray, antialiased: true)
                
                VStack( content: {
                    Text("Losses:")
                        .font(Font.system(size: 13, weight: .regular))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .lineLimit(2)
                    Text("\(choosedTeam?.loseTeam ?? "0")")
                        .foregroundColor(.red)
                        .font(Font.system(size: 34, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                })
                .padding(16)
                .frame(height: 120)
                .cornerRadiusWithBorder(radius: 20, borderLineWidth: 1, borderColor: .gray, antialiased: true)
            }
        }
    }
    
    private var players: some View {
        VStack {
            HStack {
                Text("Players")
                    .foregroundColor(.white)
                    .font(Font.system(size: 17, weight: .semibold))
                Text("(\(choosedTeam?.teamPlayerRelationship?.allObjects.count ?? 0)/6)")
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            LazyVStack(spacing: 0) {
                if choosedTeam?.teamPlayerRelationship?.allObjects.count ?? 0 > 0 {
                    Divider()
                        .padding(.horizontal, 16)
                }
                ForEach(choosedTeam?.teamPlayerRelationship?.allObjects as? [PlayersHockey] ?? [], id: \.idPlayer) {item in
                    palyerCell(item: item)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.horizontal, -16)
        }
    }
    
    private func palyerCell(item: PlayersHockey) -> some View {
        ZStack(alignment: .bottom) {
            HStack {
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        VStack {
                            if let imageData = item.photoPlayer {
                                Image(uiImage: UIImage(data: imageData) ?? UIImage())
                                    .resizable()
                                    .scaledToFill()
                                    .background(Color.white)
                            }
                        }
                    )
                    .clipShape(Circle())
                    .frame(height: 40)
                VStack(alignment: .leading) {
                    HStack(spacing: 3) {
                        Text(item.namePlayer ?? "")
                            .font(Font.system(size: 17, weight: .semibold))
                        
                        Text("\(item.yearsOldPlayer ?? "") (y.o.)")
                            .font(Font.system(size: 12, weight: .regular))
                            .foregroundColor(.blue)
                    }
                    Text(PositionPlayer(rawValue: item.positionPlayer)?.stringDescription() ?? "no positions")
                        .font(Font.system(size: 13, weight: .regular))
                        .foregroundColor(.gray.opacity(0.5))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text("#\(item.teamNumberPlayer ?? "-")")
                    .foregroundColor(.gray.opacity(0.5))
            }
            .frame(maxHeight: .infinity)
            Divider()
        }
        .frame(height: 85)
    }
    
}

#Preview {
    AboutTeam(choosedTeam: .constant(.init(entity: TeamHockey.entity(), insertInto: .none)), dismiss: .constant(false))
}
