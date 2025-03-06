//
//  Matches.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import SwiftUI

struct MatchesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest (sortDescriptors: [NSSortDescriptor(keyPath: \MatchesHockey.idMatch, ascending: true)])
    private var matches: FetchedResults<MatchesHockey>
    
    @FetchRequest (sortDescriptors: [NSSortDescriptor(keyPath: \MatchesHockey.idMatch, ascending: true)], predicate: NSPredicate(format: "playedGameMatch == %@", NSNumber(value: false)))
    private var upcomingMatches: FetchedResults<MatchesHockey>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \MatchesHockey.idMatch, ascending: true)], predicate: NSPredicate(format: "playedGameMatch == %@", NSNumber(value: true)))
    private var pastMatches: FetchedResults<MatchesHockey>
    
    @State var positionSwitch: Bool = true
    @State var createMatch: Bool = false
    @State var addScoreToMatches: Bool = false
    @State var choosedMatch: MatchesHockey?
    
    let ipadMode = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        NavigationView {
            ZStack {
                Divider()
                    .frame(maxHeight: .infinity, alignment: .top)
                mainBody
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.horizontal, ipadMode ? 90 : 16)
                    .navigationTitle("Matches")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                createMatch.toggle()
                            }, label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                            })
                        }
                    }
                    .sheet(isPresented: $createMatch, content: {
                        CreateMatch(dismiss: $createMatch)
                    })
                    .sheet(isPresented: $addScoreToMatches, content: {
                        ScoreMatch(choosedMatch: $choosedMatch, dismiss: $addScoreToMatches)
                    })
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var mainBody: some View {
        VStack {
            switchMatch
                .padding(.top, 15)
            if
                (positionSwitch && upcomingMatches.count == 0)
                    || (!positionSwitch && pastMatches.count == 0)
            {
                emptyViewList
                    .frame(maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView(.vertical, showsIndicators: false, content: {
                    matchesList
                        .padding(.top, 20)
                })
            }
        }
    }

    private var switchMatch: some View {
        
        ZStack(alignment: .center) {
            GeometryReader(content: { geometry in
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue)
                    .frame(width: geometry.size.width / 2)
                    .frame(maxWidth: .infinity, alignment: positionSwitch ? .leading : .trailing)
                HStack {
                    Button(action: {
                        withAnimation {
                            positionSwitch = true
                        }
                    }, label: {
                        Text("Upcoming")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(positionSwitch ? .black : .white)
                    })
                    Button(action: {
                        withAnimation {
                            positionSwitch = false
                        }
                    }, label: {
                        Text("Past")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(positionSwitch ? .white : .black)
                    })
                }
                .frame(maxHeight: .infinity)
            })
        }
        .padding(2)
        .frame(height: 32)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var matchesList: some View {
        VStack {
            if positionSwitch {
                upcomingMatchesList
            } else {
                pastMatchesList
            }
        }
    }
    
    private var upcomingMatchesList: some View {
        LazyVStack(spacing: 12) {
            let filterArray = upcomingMatches.sorted(by: {$0.dateMatch ?? Date() < $1.dateMatch ?? Date()})
            ForEach(filterArray, id: \.idMatch) { item in
                matchCell(data: item)
            }
        }
    }
    
    private var pastMatchesList: some View {
        LazyVStack(spacing: 12)  {
            let filterArray = pastMatches.sorted(by: {$0.dateMatch ?? Date() < $1.dateMatch ?? Date()})
            ForEach(filterArray, id: \.idMatch) { item in
                matchCell(data: item)
            }
        }
    }
    
    private func matchCell(data: MatchesHockey) -> some View {
        VStack(alignment: .leading) {
            
            HStack {
                HStack {
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .overlay (
                            VStack {
                                if let unwrImage = data.teamOneRelationship?.logoTeam {
                                    Image(uiImage: UIImage(data: unwrImage) ?? UIImage())
                                        .resizable()
                                        .scaledToFill()
                                        .background(Color.white)
                                }
                            }
                        )
                        .frame(height: 48)
                        .clipShape(Circle())
                    .cornerRadiusWithBorder(radius: 50, borderLineWidth: 1, borderColor: .black, antialiased: true)
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .overlay (
                            VStack {
                                if let unwrImage = data.teamTwoRelationship?.logoTeam {
                                    Image(uiImage: UIImage(data: unwrImage) ?? UIImage())
                                        .resizable()
                                        .scaledToFill()
                                }
                            }
                        )
                        .frame(height: 48)
                        .clipShape(Circle())
                        .cornerRadiusWithBorder(radius: 50, borderLineWidth: 1, borderColor: .black, antialiased: true)
                        .padding(.leading, -20)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(data.teamOneRelationship?.nameTeam ?? "no name") - \(data.teamTwoRelationship?.nameTeam ?? "no name")")
                            .font(Font.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                        Text(data.dateMatch?.dateFormatddMMMMHHmm() ?? Date().dateFormatddMMMMHHmm())
                            .font(Font.system(size: 13, weight: .semibold))
                            .foregroundColor(.red)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                if data.playedGameMatch == true {
                    Text("\(data.teamOneScoreMatch ?? "0") - \(data.teamTwoScoreMatch ?? "0")")
                        .font(Font.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .frame(maxHeight: .infinity, alignment: .top)
                }
            }
            Spacer()
            Text("\(data.locationMatch ?? "") / \(data.rewardMatch ?? "") / \(data.playoffStageMatch ?? "")")
                .font(Font.system(size: 15, weight: .regular))
                .foregroundColor(.gray.opacity(0.5))
                .frame(maxHeight: .infinity, alignment: .center)
            if data.playedGameMatch == false {
                Button(action: {
                    choosedMatch = data
                    addScoreToMatches.toggle()
                }, label: {
                    Text("Done")
                        .font(Font.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                        .frame(height: 42)
                        .frame(maxWidth: .infinity)
                        .cornerRadiusWithBorder(radius: 16, borderLineWidth: 1, borderColor: .gray.opacity(0.5), antialiased: true)
                })
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .frame(height: data.playedGameMatch ? 140 : 204)
        .background(Color.white.opacity(0.05))
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var emptyViewList: some View {
        VStack(spacing: 21) {
            Image(systemName: "figure.hockey")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .foregroundColor(.blue)
            Text(positionSwitch ? "Create a new match" : "There are no completed \nmatches")
                .font(Font.system(size: 17, weight: .semibold))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            if positionSwitch {
                Button(action: {
                    createMatch.toggle()
                }, label: {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                        Text("CREATE")
                            .font(Font.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .frame(width: 200)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                })
                
            }
        }
        
    }
}

#Preview {
    MatchesView()
}
