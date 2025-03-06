//
//  ListOfTeams.swift
//  Hockey Match
//
//  Created by DF on 07/06/24.
//

import SwiftUI

struct ListOfTeams: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TeamHockey.idTeam, ascending: true)]) private var allTeams: FetchedResults<TeamHockey>
    
    @State var choosedTeam: TeamHockey?
    
    @State var completion: (TeamHockey) -> Void
    @Binding var dismiss: Bool
    @Binding var allreadyChoosedOne: TeamHockey?
    @Binding var allreadyChoosedTwo: TeamHockey?
    
    let ipadMode = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        NavigationView {
            mainBody
                .padding(.horizontal,ipadMode ? 90 : 16)
                .navigationTitle("List of commands")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
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
        }
    }
    
    private var mainBody: some View {
        VStack {
            if ipadMode {
                ScrollView(.vertical, showsIndicators: false, content: {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 14),
                        GridItem(.flexible(), spacing: 14),
                        GridItem(.flexible(), spacing: 14)],
                              spacing: 14, content: {
                        
                        ForEach(allTeams, id: \.idTeam) {item in
                            if (item.idTeam == allreadyChoosedOne?.idTeam)
                            || (item.idTeam == allreadyChoosedTwo?.idTeam) {
                               
                            } else {
                                Button(action: {
                                    completion(item)
                                    dismiss.toggle()
                                }, label: {
                                    VStack {
                                        teamCell(data: item)
                                    }
                                })
                            }
                        }
                    })
                    .padding(.top, 30)
                    .padding(.bottom, 70)
                })

            } else {
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 14),
                        GridItem(.flexible(), spacing: 14)],
                              spacing: 14, content: {
                        
                        ForEach(allTeams, id: \.idTeam) {item in
                            if (item.idTeam == allreadyChoosedOne?.idTeam)
                            || (item.idTeam == allreadyChoosedTwo?.idTeam) {
                               
                            } else {
                                Button(action: {
                                    completion(item)
                                    dismiss.toggle()
                                }, label: {
                                    VStack {
                                        teamCell(data: item)
                                    }
                                })
                            }
                        }
                    })
                    .padding(.top, 30)
                    .padding(.bottom, 70)
                })
            }
        }
    }
    
    private func teamCell(data: TeamHockey) -> some View {
        VStack {
            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(height: 104)
                .overlay(
                    VStack {
                        if let imageData = data.logoTeam {
                            Image(uiImage: UIImage(data: imageData) ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .background(Color.white)
                        }
                    }
                )
                .clipShape(Circle())
            Spacer()
            VStack(spacing: 7) {
                Text(data.nameTeam ?? "")
                    .font(Font.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text("\(data.totalMatchesTeam ?? "0") matches")
                    .font(Font.system(size: 13, weight: .regular))
                    .foregroundColor(.gray.opacity(0.5))
                    .lineLimit(1)
            }
            Spacer()
            HStack {
                Text("Win: \(data.winTeam ?? "0")")
                    .font(Font.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .lineLimit(1)
                
                Text("Lose: \(data.loseTeam ?? "0")")
                    .font(Font.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .lineLimit(1)
            }
        }
        .frame(height: 227)
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.white.opacity(0.05))
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ListOfTeams(completion: {_ in}, dismiss: .constant(false), allreadyChoosedOne: .constant(nil), allreadyChoosedTwo: .constant(nil))
}
