//
//  ScoreMatch.swift
//  Hockey Match
//
//  Created by DF on 09/06/24.
//

import SwiftUI

struct ScoreMatch: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var choosedMatch: MatchesHockey?
    @Binding var dismiss: Bool
    
    @State var scoreTeamOne: String = ""
    @State var scoreTeamTwo: String = ""
    @State var disableConfirmButton: Bool = true
    var body: some View {
        NavigationView {
            mainBody
                .navigationTitle("Game score")
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
            ScrollView(.vertical, showsIndicators: false, content: {
                HStack(spacing: 12) {
                    if let teamOne = choosedMatch?.teamOneRelationship, let teamTwo = choosedMatch?.teamTwoRelationship {
                        scoreCard(data: teamOne, score: $scoreTeamOne)
                        scoreCard(data: teamTwo, score: $scoreTeamTwo)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 15)
            })
            confirmButton
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
        }
    }
    
    private func scoreCard(data: TeamHockey, score: Binding <String>) -> some View {
        VStack {
            Circle()
                .fill(Color.white.opacity(0.05))
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
                .frame(height: 114)
                .padding(.top, 10)
                .frame(maxHeight: .infinity, alignment: .top)
            HStack {
                HStack(content: {
                    Text("Score")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            UIApplication.shared.endEditing(true)
                        }
                    TextField("0", text: score)
                        .foregroundColor(.white)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: score.wrappedValue, perform: { value in
                            let clearNumber = value.filter({"0123456789".contains($0)})
                            score.wrappedValue = clearNumber
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
        .frame(height: 227)
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.gray)
        .cornerRadiusWithBorder(radius: 20, borderLineWidth: 1, borderColor: .gray, antialiased: true)
    }
    
    private var confirmButton: some View {
        Button(action: {
            choosedMatch?.teamOneScoreMatch = scoreTeamOne
            choosedMatch?.teamTwoScoreMatch = scoreTeamTwo
            choosedMatch?.playedGameMatch = true
            try? viewContext.save()
            dismiss.toggle()
        }, label: {
            Text("CONFIRM")
                .font(Font.system(size: 15, weight: .semibold))
                .foregroundColor(.black)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(disableConfirmButton ? Color.blue.opacity(0.5) : Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        })
        .disabled(disableConfirmButton)
    }
    
    private func cheking(){
        if !scoreTeamOne.isEmpty && Int(scoreTeamOne) != nil
            && !scoreTeamTwo.isEmpty && Int(scoreTeamTwo) != nil {
            disableConfirmButton = false
        } else {
            disableConfirmButton = true
        }
    }
}

#Preview {
    ScoreMatch(choosedMatch: .constant(nil), dismiss: .constant(false))
}
