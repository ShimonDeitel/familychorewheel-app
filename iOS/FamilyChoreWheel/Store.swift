import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeLimit = 14

    @Published var items: [Chore] = []
    @Published var isPro: Bool = false

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("familychorewheel_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Chore) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Chore) {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx] = item
            save()
        }
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Chore) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([Chore].self, from: data) else {
            items = [
            Chore(assignedTo: "Dishes", note: "Alex"),
            Chore(assignedTo: "Trash", note: "Sam"),
            Chore(assignedTo: "Vacuum", note: "Jordan"),
            Chore(assignedTo: "Laundry", note: "Alex")
            ]
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
