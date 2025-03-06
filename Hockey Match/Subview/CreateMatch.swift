//
//  CreateMatch.swift
//  Hockey Match
//
//  Created by DF on 07/06/24.
//

import SwiftUI

struct CreateMatch: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var matchMock: MatchModel = .init()
    @State var disableSaveButton: Bool = true
    @Binding var dismiss: Bool
    @State var openListTeams: Bool = false
    @State var whichTeam: WhichTeam?
    var body: some View {
        NavigationView {
            mainBody
                .navigationTitle("New match")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            dismiss.toggle()
                            save()
                        }, label: {
                            Text("Save")
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
                .sheet(isPresented: $openListTeams, content: {
                    ListOfTeams(completion: {team in
                        switch whichTeam {
                        case .teamOne:
                            matchMock.teamOne = team
                        case .teamTwo:
                            matchMock.teamTwo = team
                        case nil:
                            break
                        }
                    }, dismiss: $openListTeams, allreadyChoosedOne: $matchMock.teamOne, allreadyChoosedTwo: $matchMock.teamTwo)
                })
        }
    }
    
    private var mainBody: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack(spacing: 20) {
                chooseTeamButtons
                information
            }
            .padding(.horizontal, 16)
            .padding(.top, 15)
        })
    }
    
    private var chooseTeamButtons: some View {
        HStack {
            createTeamButton(data: matchMock.teamOne, placeholder: "Add team 1", firstOrSecond: true)
            createTeamButton(data: matchMock.teamTwo, placeholder: "Add team 2", firstOrSecond: false)
        }
    }
    
    private func createTeamButton(data: TeamHockey?, placeholder: String, firstOrSecond: Bool) -> some View {
        VStack {
            if data == nil {
                VStack {
                    VStack(spacing: 10) {
                        Image(systemName: "person.3")
                            .resizable()
                            .scaledToFit()
                        .frame(height: 41)
                        Text("Add team 2")
                            .font(Font.system(size: 16, weight: .semibold))
                    }
                    .frame(maxHeight: .infinity)
                    Button(action: {
                        firstOrSecond ? (whichTeam = .teamOne) : (whichTeam = .teamTwo)
                        openListTeams.toggle()
                    }, label: {
                        HStack(spacing: 2) {
                            Image(systemName: "plus")
                                .font(Font.system(size: 17, weight: .semibold))
                            Text("ADD")
                                .font(Font.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.black)
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    })
                }
                .frame(height: 227)
                .padding(16)
            } else {
                Button(action: {
                    firstOrSecond ? (whichTeam = .teamOne) : (whichTeam = .teamTwo)
                    openListTeams.toggle()
                }, label: {
                    if firstOrSecond {
                        if let teamOne = matchMock.teamOne {
                            teamCell(data: teamOne)
                        }
                    } else {
                        if let teamTwo = matchMock.teamTwo {
                            teamCell(data: teamTwo)
                        }
                    }
                })
            }
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.gray)
        .cornerRadiusWithBorder(radius: 20, borderLineWidth: 1, borderColor: .gray, antialiased: true)
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
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var information: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("Information")
                .font(Font.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .onTapGesture {
                    UIApplication.shared.endEditing(true)
                }
            
            HStack {
                HStack(content: {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    Spacer()
                    ZStack(alignment: .trailing) {
                        Text(matchMock.date.dateFormatddMMM())
                        
                        DatePicker("clock.arrow.circlepath", selection: $matchMock.date, displayedComponents: .date)
                            .labelsHidden()
                            .blendMode(.color)
                            .opacity(0.05)
                            .frame(width: 100)
                    }
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 54)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .layoutPriority(1)
                HStack(content: {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.blue)
                    Spacer()
                    ZStack(alignment: .trailing) {
                        Text(matchMock.date.dateFormatHHmm())
                        
                        DatePicker("", selection: $matchMock.date, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .blendMode(.color)
                            .opacity(0.05)
                    }
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 54)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .layoutPriority(1)
            }
            .onChange(of: matchMock.date, perform: { value in
                cheking()
            })
            
            ZStack(alignment: .leading, content: {
                Text(matchMock.location.isEmpty ? "Location" : matchMock.location)
                    .foregroundColor(matchMock.location.isEmpty ? .gray.opacity(0.5) : .white)
                TextField("", text: $matchMock.location)
                    .onChange(of: matchMock.location, perform: { value in
                        cheking()
                    })
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 54)
            .padding(.horizontal, 16)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            ZStack(alignment: .leading, content: {
                Text(matchMock.reward.isEmpty ? "Reward" : matchMock.reward)
                    .foregroundColor(matchMock.reward.isEmpty ? .gray.opacity(0.5) : .white)
                TextField("", text: $matchMock.reward)
                    .onChange(of: matchMock.reward, perform: { value in
                        cheking()
                    })
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 54)
            .padding(.horizontal, 16)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            ZStack(alignment: .leading, content: {
                Text(matchMock.playoffStage.isEmpty ? "Playoff stage" : matchMock.playoffStage)
                    .foregroundColor(matchMock.playoffStage.isEmpty ? .gray.opacity(0.5) : .white)
                TextField("", text: $matchMock.playoffStage)
                    .onChange(of: matchMock.playoffStage, perform: { value in
                        cheking()
                    })
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 54)
            .padding(.horizontal, 16)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        })
    }
    
    private func cheking() {
        disableSaveButton = matchMock.checkFilled()
    }
    
    private func save() {
        CoreDataService.shared.saveMatch(viewContext: viewContext, data: matchMock)
    }
}

#Preview {
    CreateMatch(dismiss: .constant(false))
}

enum WhichTeam {
    case teamOne
    case teamTwo
}
