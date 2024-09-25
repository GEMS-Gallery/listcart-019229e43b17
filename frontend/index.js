import { backend } from 'declarations/backend';

document.addEventListener('DOMContentLoaded', async () => {
  const form = document.getElementById('add-item-form');
  const input = document.getElementById('item-input');
  const list = document.getElementById('shopping-list');

  // Load initial items
  await loadItems();

  // Add new item
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const name = input.value.trim();
    if (name) {
      await backend.addItem(name);
      input.value = '';
      await loadItems();
    }
  });

  // Load and display items
  async function loadItems() {
    const items = await backend.getItems();
    list.innerHTML = '';
    items.forEach(item => {
      const li = document.createElement('li');
      li.innerHTML = `
        <span class="${item.completed ? 'completed' : ''}">${item.name}</span>
        <div>
          <button class="complete-btn" data-id="${item.id}">
            <i class="fas fa-check"></i>
          </button>
          <button class="delete-btn" data-id="${item.id}">
            <i class="fas fa-trash"></i>
          </button>
        </div>
      `;
      list.appendChild(li);
    });
  }

  // Event delegation for complete and delete buttons
  list.addEventListener('click', async (e) => {
    if (e.target.closest('.complete-btn')) {
      const id = Number(e.target.closest('.complete-btn').dataset.id);
      await backend.completeItem(id);
      await loadItems();
    } else if (e.target.closest('.delete-btn')) {
      const id = Number(e.target.closest('.delete-btn').dataset.id);
      await backend.deleteItem(id);
      await loadItems();
    }
  });
});
