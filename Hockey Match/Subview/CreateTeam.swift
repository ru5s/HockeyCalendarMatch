//
//  CreateTeam.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import SwiftUI

struct CreateTeam: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var choosedTeam: TeamHockey?
    @State var teamMock: TeamModel = .init()
    @State var editMode: Bool = false
    @State var navigationTitle: String = "New team"
    @State var disableSaveButton: Bool = true
    @State var imagePicker: Bool = false
    @Binding var dismiss: Bool
    @State var playersArray: [PlayersHockey] = []
    @State var createNewPlayer: Bool = false
    var body: some View {
        NavigationView {
            mainBody
                .navigationTitle(navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            dismiss.toggle()
                            save()
                        }, label: {
                            Text("Save")
                                .foregroundColor(.green)
                        })
                        .disabled(disableSaveButton)
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
                .sheet(isPresented: $imagePicker, content: {
                    ImagePicker(selectedImage: $teamMock.image, completion: {
                        cheking()
                    })
                })
                .sheet(isPresented: $createNewPlayer, content: {
                    CreatePlayer(completion: { player in
                        if editMode {
                            playersArray.append(player)
                            if let choosedTeam = choosedTeam {
                                choosedTeam.addToTeamPlayerRelationship(player)
                                try? viewContext.save()
                            }
                        } else {
                            playersArray.append(player)
                        }
                        
                    }, dismiss: $createNewPlayer)
                })
                .onAppear() {
                    if editMode {
                        if let choosedTeam = choosedTeam {
                            teamMock.getData(data: choosedTeam)
                            navigationTitle = choosedTeam.nameTeam ?? "Team"
                            let arrayOfPlayers = choosedTeam.teamPlayerRelationship?.allObjects as? [PlayersHockey] ?? []
                            
                            for i in arrayOfPlayers {
                                playersArray.append(i)
                            }
                        }
                    }
                }
        }
    }
    
    private var mainBody: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack(spacing: 35) {
                image
                information
                players
                    .padding(.top, 15)
            }
            .padding(.horizontal, 16)
            .padding(.top, 25)
        })
    }
    
    private var image: some View {
        Button(action: {
            imagePicker.toggle()
        }, label: {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    VStack {
                        if let imageData = teamMock.image {
                            Image(uiImage: imageData)
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
        })
    }
    
    private var information: some View {
        VStack(alignment: .leading) {
            Text("Information")
                .font(Font.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .onTapGesture {
                    UIApplication.shared.endEditing(true)
                }
            ZStack(alignment: .leading, content: {
                Text(teamMock.teamName.isEmpty ? "Team name" : teamMock.teamName)
                    .foregroundColor(teamMock.teamName.isEmpty ? .gray.opacity(0.5) : .white)
                TextField("", text: $teamMock.teamName)
                    .onChange(of: teamMock.teamName, perform: { value in
                        cheking()
                    })
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 54)
            .padding(.horizontal, 16)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            HStack( content: {
                Text("Total matches")
                    .foregroundColor(teamMock.totalMatches.isEmpty ? .gray.opacity(0.5) : .white)
                    .onTapGesture {
                        UIApplication.shared.endEditing(true)
                    }
                TextField("0", text: $teamMock.totalMatches)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .onChange(of: teamMock.totalMatches, perform: { value in
                        let clearNumber = value.filter({"0123456789".contains($0)})
                        teamMock.totalMatches = clearNumber
                        cheking()
                    })
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 54)
            .padding(.horizontal, 16)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            HStack {
                HStack( content: {
                    Text("Win")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            UIApplication.shared.endEditing(true)
                        }
                    TextField("0", text: $teamMock.win)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onChange(of: teamMock.win, perform: { value in
                            let clearNumber = value.filter({"0123456789".contains($0)})
                            teamMock.win = clearNumber
                            cheking()
                        })
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 54)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                HStack( content: {
                    Text("Lose")
                        .foregroundColor(.red)
                        .onTapGesture {
                            UIApplication.shared.endEditing(true)
                        }
                    TextField("0", text: $teamMock.lose)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onChange(of: teamMock.lose, perform: { value in
                            let clearNumber = value.filter({"0123456789".contains($0)})
                            teamMock.lose = clearNumber
                            cheking()
                        })
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 54)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private var players: some View {
        VStack {
            HStack {
                Text("Players")
                    .foregroundColor(.white)
                    .font(Font.system(size: 17, weight: .semibold))
                Text("(\(playersArray.count)/6)")
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    if playersArray.count < 6 {
                        createNewPlayer.toggle()
                    }
                }, label: {
                    Image(systemName: "plus.app.fill")
                        .foregroundColor(playersArray.count < 6 ? .white : .gray)
                })
                .disabled(playersArray.count < 6 ? false : true)
            }
            if playersArray.isEmpty {
                Button(action: {
                    if playersArray.count < 6 {
                        createNewPlayer.toggle()
                    }
                }, label: {
                    Text("+ Add player")
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(style: .init(lineWidth: 1, lineCap: .butt, lineJoin: .round, miterLimit: 0, dash: [5], dashPhase: 10))
                        )
                })
                .padding(.top, 15)
            }
            LazyVStack(spacing: 0) {
                Divider()
                    .padding(.horizontal, 16)
                ForEach(Array(playersArray.enumerated()), id: \.element.idPlayer) {index, item in
                    palyerCell(item: item)
                        .padding(.horizontal, 16)
                        .addButtonActions(leadingButtons: [], trailingButton: [.delete]) { type in
                            playersArray.remove(at: index)
                            viewContext.delete(item)
                            try? viewContext.save()
                        }
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
    
    private func cheking() {
        disableSaveButton = teamMock.checkFilled()
    }
    
    private func save() {
        if editMode {
            if let choosedTeam = choosedTeam {
                CoreDataService.shared.updateTeam(viewContext: viewContext, data: teamMock, item: choosedTeam)
            }
        } else {
            CoreDataService.shared.saveTeam(viewContext: viewContext, data: teamMock, players: playersArray)
        }
    }
}

#Preview {
    CreateTeam(choosedTeam: .constant(nil), dismiss: .constant(false))
}
