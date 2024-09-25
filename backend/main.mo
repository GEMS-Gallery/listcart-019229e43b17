import Bool "mo:base/Bool";
import Func "mo:base/Func";
import Text "mo:base/Text";

import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";

actor {
  // Define the structure for a shopping list item
  type ShoppingItem = {
    id: Nat;
    name: Text;
    completed: Bool;
  };

  // Stable variable to store the shopping list items
  stable var items : [ShoppingItem] = [];
  stable var nextId : Nat = 0;

  // Function to add a new item to the list
  public func addItem(name : Text) : async Nat {
    let id = nextId;
    nextId += 1;
    let newItem : ShoppingItem = {
      id = id;
      name = name;
      completed = false;
    };
    items := Array.append(items, [newItem]);
    id
  };

  // Function to get all items
  public query func getItems() : async [ShoppingItem] {
    items
  };

  // Function to mark an item as completed
  public func completeItem(id : Nat) : async Bool {
    let updatedItems = Array.map<ShoppingItem, ShoppingItem>(
      items,
      func (item) {
        if (item.id == id) {
          {
            id = item.id;
            name = item.name;
            completed = not item.completed;
          }
        } else {
          item
        }
      }
    );
    items := updatedItems;
    true
  };

  // Function to delete an item
  public func deleteItem(id : Nat) : async Bool {
    let updatedItems = Array.filter<ShoppingItem>(
      items,
      func (item) { item.id != id }
    );
    if (items.size() != updatedItems.size()) {
      items := updatedItems;
      true
    } else {
      false
    }
  };
}
