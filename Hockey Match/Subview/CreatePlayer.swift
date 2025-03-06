//
//  CreatePlayer.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import SwiftUI

struct CreatePlayer: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var disableSaveButton: Bool = true
    @State var playerMock: PlayerModel = .init()
    @State var imagePicker: Bool = false
    @State var completion: (PlayersHockey) -> Void = {_ in}
    @Binding var dismiss: Bool
    var body: some View {
        NavigationView {
            mainBody
                .navigationTitle("Add player")
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
                .sheet(isPresented: $imagePicker, content: {
                    ImagePicker(selectedImage: $playerMock.image, completion: {
                        cheking()
                    })
                })
        }
    }
    
    private var mainBody: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack(spacing: 35) {
                imageView
                information
                players
                    .padding(.top, 15)
                addButton
            }
            .padding(.horizontal, 16)
            .padding(.top, 25)
        })
    }
    
    private var imageView: some View {
        Button(action: {
            imagePicker.toggle()
        }, label: {
            Circle()
                .fill(Color.white.opacity(0.05))
                .overlay(
                    VStack {
                        if let imageData = playerMock.image {
                            Image(uiImage: imageData)
                                .resizable()
                                .scaledToFill()
                                .background(Color.white)
                        } else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(.gray.opacity(0.5))
                                .offset(y: 20)
                        }
                    }
                )
                .frame(height: 100)
                .clipShape(Circle())
        })
    }
    
    private var information: some View {
        VStack(alignment: .leading) {
            Text("Infomation")
                .foregroundColor(.white)
                .font(Font.system(size: 17, weight: .semibold))
                .onTapGesture {
                    UIApplication.shared.endEditing(true)
                }
            ZStack(alignment: .leading, content: {
                Text(playerMock.name.isEmpty ? "Name" : playerMock.name)
                    .foregroundColor(playerMock.name.isEmpty ? .gray.opacity(0.5) : .white)
                TextField("", text: $playerMock.name)
                    .onChange(of: playerMock.name, perform: { value in
                        cheking()
                    })
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 54)
            .padding(.horizontal, 16)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            HStack {
                ZStack(alignment: .leading, content: {
                    Text(playerMock.yearsOld.isEmpty ? "Age" : playerMock.yearsOld)
                        .foregroundColor(playerMock.yearsOld.isEmpty ? .gray.opacity(0.5) : .white)
                        .onTapGesture {
                            UIApplication.shared.endEditing(true)
                        }
                    TextField("", text: $playerMock.yearsOld)
                        .keyboardType(.decimalPad)
                        .onChange(of: playerMock.yearsOld, perform: { value in
                            let clearNumber = value.filter({"0123456789".contains($0)})
                            playerMock.yearsOld = clearNumber
                            cheking()
                        })
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 54)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                HStack(spacing: 3) {
                    Text("#")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            UIApplication.shared.endEditing(true)
                        }
                    ZStack(alignment: .leading, content: {
                        if playerMock.number.isEmpty {
                            Text("Number")
                                .foregroundColor(.gray.opacity(0.5))
                        }
                        TextField("", text: $playerMock.number)
                            .keyboardType(.decimalPad)
                            .onChange(of: playerMock.number, perform: { value in
                                cheking()
                            })
                    })
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 54)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private var players: some View {
        VStack(alignment: .leading) {
            Text("Position")
                .foregroundColor(.white)
                .font(Font.system(size: 17, weight: .semibold))
                .onTapGesture {
                    UIApplication.shared.endEditing(true)
                }
            HStack {
                switchButton(position: .forward)
                switchButton(position: .center)
            }
            HStack {
                switchButton(position: .winger)
                switchButton(position: .defenseman)
            }
            HStack {
                switchButton(position: .goaltender)
                switchButton(position: .spare)
            }
        }
    }
    
    private func switchButton(position: PositionPlayer) -> some View {
        Button(action: {
            playerMock.position = position
        }, label: {
            HStack {
                Image(systemName: playerMock.position == position ? "record.circle" : "circle")
                    .foregroundColor(playerMock.position == position ? .blue : .gray.opacity(0.5))
                Text(position.stringDescription())
                    .foregroundColor(playerMock.position == position ? .white : .gray.opacity(0.5))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 54)
            .padding(.horizontal, 16)
            .background(Color.white.opacity(0.05))
            .cornerRadiusWithBorder(radius: 12, borderLineWidth: playerMock.position == position ? 1 : 0, borderColor: .blue, antialiased: true)
        })
        .onChange(of: playerMock.position, perform: { value in
            cheking()
        })
    }
    
    private var addButton: some View {
        Button(action: {
            save()
        }, label: {
            Text("ADD")
                .fontWeight(.semibold)
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .background(!disableSaveButton ? Color.blue : Color.blue.opacity(0.5))
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        })
        .disabled(disableSaveButton)
    }
    
    private func cheking() {
        disableSaveButton = playerMock.checkFilled()
    }
    
    private func save() {
        let savePlayer = PlayersHockey(context: viewContext)
        savePlayer.idPlayer = UUID()
        savePlayer.photoPlayer = playerMock.image?.pngData()
        savePlayer.namePlayer = playerMock.name
        savePlayer.yearsOldPlayer = playerMock.yearsOld
        savePlayer.teamNumberPlayer = playerMock.number
        if let position = playerMock.position {
            savePlayer.positionPlayer = position.rawValue
        }
        completion(savePlayer)
        dismiss.toggle()
    }
}

#Preview {
    CreatePlayer(dismiss: .constant(false))
}
