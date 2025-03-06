//
//  HomeVIew.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import SwiftUI

struct HomeVIew: View {
    @FetchRequest (sortDescriptors: [NSSortDescriptor(keyPath: \MatchesHockey.idMatch, ascending: true)], predicate: NSPredicate(format: "playedGameMatch == %@", NSNumber(value: false)))
    private var upcomingMatches: FetchedResults<MatchesHockey>
    
    @FetchRequest (sortDescriptors: [NSSortDescriptor(keyPath: \MatchesHockey.idMatch, ascending: true)], predicate: NSPredicate(format: "playedGameMatch == %@", NSNumber(value: true)))
    private var playedMatches: FetchedResults<MatchesHockey>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TeamHockey.idTeam, ascending: true)])
    private var allTeams: FetchedResults<TeamHockey>
    
    @Binding var selectedTab: Int
    @State var listOfNotes: Bool = false
    
    let ipadMode = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Divider()
                mainBody
                    .padding(.horizontal,ipadMode ? 90 : 16)
                    .navigationTitle("Home")
                    .sheet(isPresented: $listOfNotes, content: {
                        NotesView(dismiss: $listOfNotes)
                    })
            }
        }
    }
    private var mainBody: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                HStack {
                    results
                    VStack {
                        teams
                        notes
                        
                    }
                }
                .padding(.top, 30)
                statistics
            })
        }
    }
    
    private var results: some View {
        Button(action: {
            selectedTab = 2
        }, label: {
            VStack(alignment: .leading) {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                VStack(alignment: .leading) {
                    Text("Results")
                        .font(Font.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    Text("Match history")
                        .font(Font.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
                .frame(maxHeight: .infinity)
                
                HStack {
                    if ipadMode {
                        rectangeToChart(height: 76)
                        rectangeToChart(height: 54)
                        rectangeToChart(height: 65)
                        rectangeToChart(height: 35)
                        rectangeToChart(height: 35)
                        rectangeToChart(height: 35)
                        rectangeToChart(height: 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        rectangeToChart(height: 76)
                        rectangeToChart(height: 54)
                        rectangeToChart(height: 65)
                        rectangeToChart(height: 35)
                        rectangeToChart(height: 16)
                    }
                }
            }
            .foregroundColor(.black)
            .frame(height: 221)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        })
        
    }
    
    private func rectangeToChart(height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.blue.opacity(0.3))
            .frame(width: 19, height: height)
            .frame(maxWidth:ipadMode ? 25 : .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    
    private var teams: some View {
        Button(action: {
            selectedTab = 1
        }, label: {
            VStack(spacing: 15) {
                HStack {
                    Text("Teams")
                        .font(Font.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack {
                    let firstTreeItems = allTeams.prefix(3)
                    ForEach(firstTreeItems, id: \.idTeam) { item in
                        Circle()
                            .fill(Color.gray)
                            .overlay(
                                VStack(spacing: 0) {
                                    if let imageData = item.logoTeam {
                                        Image(uiImage: UIImage(data: imageData) ?? UIImage())
                                            .resizable()
                                            .scaledToFill()
                                            .background(Color.white)
                                    }
                                }
                            )
                            .frame(height: 36)
                            .clipShape(Circle())
                            .cornerRadiusWithBorder(radius: 50, borderLineWidth: 1, borderColor: .black, antialiased: true)
                            .padding(.leading, -16)
                    }
                    if firstTreeItems.count < 3 {
                        let circleCount = 3 - firstTreeItems.count
                        let range = 0..<circleCount
                        ForEach(range, id: \.self) { index in
                            Circle()
                                .fill(Color.gray)
                                .frame(height: 36)
                                .clipShape(Circle())
                                .cornerRadiusWithBorder(radius: 50, borderLineWidth: 1, borderColor: .black, antialiased: true)
                                .padding(.leading, -16)
                        }
                    }
                }
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(16)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
        })
    }
    private var notes: some View {
        Button(action: {
            listOfNotes.toggle()
        }, label: {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Notes")
                        .font(Font.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Text("Team Performance \nRecords")
                    .font(Font.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(16)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
        })
    }
    private var statistics: some View {
        VStack(alignment: .leading) {
            Text("Statistics")
                .font(Font.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 30)
            HStack {
                statisticsCard(result: playedMatches.count.description, placeholder: "Matches \nplayed:")
                statisticsCard(result: upcomingMatches.count.description, placeholder: "Upcoming \nmatches:")
                statisticsCard(result: allTeams.count.description, placeholder: "Total \nteams:", color: .blue)
            }
        }
    }
    
    private func statisticsCard(result: String, placeholder: String, color: Color = .white.opacity(0.05)) -> some View {
        VStack {
            Text(placeholder)
                .multilineTextAlignment(.leading)
                .font(Font.system(size: 13, weight: .semibold))
                .foregroundColor(color == .blue ? .white : .gray.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Text(result)
                .font(Font.system(size: 34, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        .frame(height: 158)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    HomeVIew(selectedTab: .constant(0))
}
