//
//  Persistence.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Hockey_Match")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    fatalError("Unable to access document directory")
                }
                let dbUrl = documentDirectory.appendingPathComponent("Hockey_Match")
                print("Path to database: \(dbUrl.path)")
    }
}

struct CoreDataService {
    static let shared: CoreDataService = CoreDataService()
    
    private func save(viewContext: NSManagedObjectContext) {
        do {
            try viewContext.save()
        } catch {
            print("core data error \(error.localizedDescription)")
        }
    }
    
    func saveTeam(viewContext: NSManagedObjectContext, data: TeamModel, players: [PlayersHockey]) {
        let item = TeamHockey(context: viewContext)
        item.idTeam = UUID()
        item.logoTeam = data.image?.pngData()
        item.nameTeam = data.teamName
        item.totalMatchesTeam = data.totalMatches
        item.winTeam = data.win
        item.loseTeam = data.lose
        for i in players {
            item.addToTeamPlayerRelationship(i)
        }
        
        save(viewContext: viewContext)
    }
    
    func updateTeam(viewContext: NSManagedObjectContext, data: TeamModel, item: TeamHockey) {
        item.logoTeam = data.image?.pngData()
        item.nameTeam = data.teamName
        item.totalMatchesTeam = data.totalMatches
        item.winTeam = data.win
        item.loseTeam = data.lose
        
        save(viewContext: viewContext)
    }
    
    func saveMatch(viewContext: NSManagedObjectContext, data: MatchModel) {
        let item = MatchesHockey(context: viewContext)
        item.idMatch = UUID()
        item.teamOneRelationship = data.teamOne
        item.teamTwoRelationship = data.teamTwo
        item.dateMatch = data.date
        item.locationMatch = data.location
        item.rewardMatch = data.reward
        item.playoffStageMatch = data.playoffStage
        item.playedGameMatch = false
        item.teamOneScoreMatch = ""
        item.teamTwoScoreMatch = ""
        
        save(viewContext: viewContext)
    }
    
    func saveNote(viewContext: NSManagedObjectContext, data: String) {
        let item = NotesHockey(context: viewContext)
        item.idNotes = UUID()
        item.dateNotes = Date()
        item.textNotes = data
        save(viewContext: viewContext)
    }
    
    func updateNote(viewContext: NSManagedObjectContext, data: String, item: NotesHockey) {
        item.textNotes = data
        save(viewContext: viewContext)
    }
}
