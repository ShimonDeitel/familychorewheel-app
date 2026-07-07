import XCTest
@testable import FamilyChoreWheel

@MainActor
final class FamilyChoreWheelTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.save()
    }

    func testAddItem() {
        let item = Chore(assignedTo: "Test", note: "Note")
        store.add(item)
        XCTAssertEqual(store.items.count, 1)
    }

    func testAddInsertsAtFront() {
        store.add(Chore(assignedTo: "First", note: ""))
        store.add(Chore(assignedTo: "Second", note: ""))
        XCTAssertEqual(store.items.first?.assignedTo, "Second")
    }

    func testDeleteItem() {
        let item = Chore(assignedTo: "ToDelete", note: "")
        store.add(item)
        store.delete(item)
        XCTAssertTrue(store.items.isEmpty)
    }

    func testDeleteAtOffsets() {
        store.add(Chore(assignedTo: "A", note: ""))
        store.add(Chore(assignedTo: "B", note: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }

    func testFreeLimitAllowsAdding() {
        for i in 0..<Store.freeLimit {
            store.add(Chore(assignedTo: "Item \(i)", note: ""))
        }
        XCTAssertEqual(store.items.count, Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.add(Chore(assignedTo: "One", note: ""))
        XCTAssertTrue(store.canAddMore)
    }

    func testProBypassesLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(Chore(assignedTo: "Item \(i)", note: ""))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateItem() {
        var item = Chore(assignedTo: "Original", note: "")
        store.add(item)
        item.assignedTo = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.assignedTo, "Updated")
    }
}
