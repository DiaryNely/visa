<script setup>
defineProps({
  searchType: String,
  searchInput: String,
  loading: Boolean,
  error: String,
  showResults: Boolean
})

const emit = defineEmits(['update:searchType', 'update:searchInput', 'search', 'reset'])
</script>

<template>
  <div class="search-card">
    <!-- Onglets de recherche -->
    <div class="tab-switches">
      <button
        class="tab-btn"
        :class="{ active: searchType === 'passport' }"
        @click="emit('update:searchType', 'passport')">
        🛂 Par Passeport
      </button>
      <button
        class="tab-btn"
        :class="{ active: searchType === 'demande' }"
        @click="emit('update:searchType', 'demande')">
        📋 Par Numéro Demande
      </button>
    </div>

    <!-- Formulaire de recherche -->
    <form @submit.prevent="emit('search')" class="search-form">
      <div class="form-group" v-if="searchType === 'passport'">
        <label for="passeport">Numéro de Passeport</label>
        <input
          id="passeport"
          :value="searchInput"
          @input="emit('update:searchInput', $event.target.value)"
          type="text"
          placeholder="Ex: 12345678"
          required>
      </div>
      <div class="form-group" v-if="searchType === 'demande'">
        <label for="demandeNum">Numéro de Demande</label>
        <input
          id="demandeNum"
          :value="searchInput"
          @input="emit('update:searchInput', $event.target.value)"
          type="number"
          placeholder="Ex: 1, 2, 3..."
          required>
      </div>

      <div class="search-buttons">
        <button type="submit" class="btn btn-primary" :disabled="loading">
          <span v-if="!loading">🔍 Rechercher</span>
          <span v-else>Recherche en cours...</span>
        </button>
        <button type="button" class="btn btn-secondary" @click="emit('reset')" v-if="showResults">
          Réinitialiser
        </button>
      </div>
    </form>

    <!-- Messages d'erreur -->
    <div v-if="error" class="alert alert-error">
      ⚠️ {{ error }}
    </div>
  </div>
</template>

<style scoped>
.search-card {
  background: var(--bg-card);
  border-radius: var(--radius-md);
  padding: 22px;
  box-shadow: var(--shadow-sm);
  margin-bottom: 18px;
  border: 1px solid var(--border-color);
}

.tab-switches {
  display: flex;
  gap: 10px;
  margin-bottom: 16px;
}

.tab-btn {
  padding: 9px 14px;
  border: 1px solid var(--border-color);
  background: var(--bg-soft);
  color: var(--text-secondary);
  border-radius: var(--radius-sm);
  cursor: pointer;
  font-weight: 600;
  transition: all 0.2s ease;
}

.tab-btn.active {
  background: var(--primary);
  color: white;
  border-color: var(--primary);
}

.tab-btn:hover {
  border-color: var(--primary);
}

.search-form {
  display: flex;
  gap: 15px;
  flex-wrap: wrap;
  align-items: flex-end;
  margin-bottom: 14px;
}

.form-group {
  flex: 1;
  min-width: 250px;
}

.form-group label {
  display: block;
  margin-bottom: 6px;
  font-weight: 600;
  color: var(--text-secondary);
  font-size: 0.88rem;
}

.form-group input {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid var(--border-color);
  border-radius: var(--radius-sm);
  font-size: 0.95rem;
  color: var(--text-primary);
  transition: all 0.2s ease;
  background: #fff;
}

.form-group input:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 0 3px var(--primary-light);
}

.search-buttons {
  display: flex;
  gap: 10px;
}

.btn {
  padding: 10px 16px;
  border: none;
  border-radius: var(--radius-sm);
  font-size: 0.92rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.btn-primary {
  background: var(--primary);
  color: white;
}

.btn-primary:hover {
  background: var(--primary-dark);
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-secondary {
  background: var(--bg-soft);
  border: 1px solid var(--border-color);
  color: var(--text-secondary);
}

.btn-secondary:hover {
  border-color: var(--primary);
  color: var(--primary);
}

.alert {
  padding: 12px 14px;
  border-radius: var(--radius-sm);
  margin-top: 8px;
  font-weight: 500;
}

.alert-error {
  background: #fef2f2;
  color: #b91c1c;
  border: 1px solid #fecaca;
}

@media (max-width: 768px) {
  .search-form {
    flex-direction: column;
  }

  .form-group {
    min-width: 100%;
  }

  .search-buttons {
    flex-direction: column;
  }

  .btn {
    width: 100%;
  }
}
</style>
