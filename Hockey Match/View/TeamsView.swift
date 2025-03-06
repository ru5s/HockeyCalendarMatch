//
//  TeamsView.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import SwiftUI

struct TeamsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TeamHockey.idTeam, ascending: true)]) private var allTeams: FetchedResults<TeamHockey>
    
    @State var createTeam: Bool = false
    @State var editTeam: Bool = false
    @State var deleteMode: Bool = false
    @State var chooseTeam: TeamHockey?
    @State var deleteId: Int?
    
    let ipadMode = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Divider()
                mainBody
                    .padding(.horizontal,ipadMode ? 90 : 16)
                    .navigationTitle("Teams")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                createTeam.toggle()
                            }, label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                            })
                        }
                    }
                    .sheet(isPresented: $createTeam, content: {
                        CreateTeam(choosedTeam: .constant(nil), dismiss: $createTeam)
                    })
                    .sheet(isPresented: $editTeam, content: {
                        AboutTeam(choosedTeam: $chooseTeam, dismiss: $editTeam)
                })
            }
        }
    }
    @ViewBuilder
    private var mainBody: some View {
        VStack {
            if allTeams.isEmpty {
                emptyView
                    .frame(maxHeight: .infinity)
            } else {
                if ipadMode {
                    ScrollView(.vertical, showsIndicators: false, content: {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 14),
                            GridItem(.flexible(), spacing: 14),
                            GridItem(.flexible(), spacing: 14)],
                                  spacing: 14, content: {
                            
                            ForEach(Array(allTeams.enumerated()), id: \.element.idTeam) {index, item in
                                teamCell(data: item, index: index, deleteId: $deleteId)
                                    .offset(y:deleteId == index && deleteMode ? -45 : 0)
                                    .compositingGroup()
                                    .shadow(color:deleteId == index && deleteMode ? .black : .clear, radius: 10, x: 0.0, y: 10.0)
                                    .zIndex(Double(allTeams.count - index))
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
                            
                            ForEach(Array(allTeams.enumerated()), id: \.element.idTeam) {index, item in
                                teamCell(data: item, index: index, deleteId: $deleteId)
                                    .offset(y:deleteId == index && deleteMode ? -45 : 0)
                                    .compositingGroup()
                                    .shadow(color:deleteId == index && deleteMode ? .black : .clear, radius: 10, x: 0.0, y: 10.0)
                            }
                        })
                        .padding(.top, 30)
                        .padding(.bottom, 70)
                    })
                }
            }
        }
    }
    
    @ViewBuilder
    private func teamCell(data: TeamHockey, index: Int, deleteId: Binding<Int?>) -> some View {
        ZStack(alignment: .bottom) {
            if deleteMode && deleteId.wrappedValue == index {
                Button(action: {
                    withAnimation {
                        deleteMode.toggle()
                        viewContext.delete(data)
                        try? viewContext.save()
                    }
                }, label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .font(Font.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .frame(height: 39)
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                })
                .offset(y: 45)
                .transition(.move(edge: .top))
            }
            
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
            .blur(radius: deleteMode ? (deleteId.wrappedValue == index ? 0 : 5) : 0)
            .onTapGesture {
                if deleteMode {
                    withAnimation {
                        deleteMode.toggle()
                    }
                } else {
                    chooseTeam = data
                    editTeam.toggle()
                }
            }
            .onLongPressGesture {
                withAnimation {
                    deleteMode.toggle()
                    deleteId.wrappedValue = index
                }
            }
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 21) {
            Image(systemName: "person.3")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(width: 75)
            Text("Create a new hockey team")
                .font(Font.system(size: 17, weight: .semibold))
                .foregroundColor(.gray)
            Button(action: {
                createTeam.toggle()
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

#Preview {
    TabViewHockey(selectedTab: 1)
}
