<script setup>
import { onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import SearchForm from '../components/SearchForm.vue'
import ResultsSection from '../components/ResultsSection.vue'

const route = useRoute()
const router = useRouter()

const searchType = ref('passport')
const searchInput = ref('')
const loading = ref(false)
const error = ref(null)
const results = ref(null)
const demandeurInfo = ref(null)

const API_BASE_URL = 'http://localhost:8081/api'

async function search() {
  error.value = null
  results.value = null
  demandeurInfo.value = null
  loading.value = true

  try {
    let response

    if (searchType.value === 'passport') {
      response = await fetch(`${API_BASE_URL}/demandeurs/par-passeport/${encodeURIComponent(searchInput.value)}`)
    } else {
      response = await fetch(`${API_BASE_URL}/demandes/${encodeURIComponent(searchInput.value)}`)
    }

    if (!response.ok) {
      if (response.status === 404) {
        error.value = 'Aucun résultat trouvé. Vérifiez votre saisie.'
        loading.value = false
        return
      }
      throw new Error('Erreur lors de la recherche')
    }

    const data = await response.json()

    if (searchType.value === 'passport') {
      demandeurInfo.value = data.demandeur
      results.value = data.demandes || []
    } else {
      demandeurInfo.value = data.demandeur
      results.value = [data]
    }

    if (results.value.length === 0) {
      error.value = 'Ce demandeur n\'a pas encore de demande.'
    }
  } catch (err) {
    console.error('Erreur:', err)
    error.value = 'Erreur de connexion. Vérifiez que le serveur est accessible.'
  } finally {
    loading.value = false
  }
}

function resetSearch() {
  searchInput.value = ''
  results.value = null
  demandeurInfo.value = null
  error.value = null
  if (route.path !== '/') {
    router.replace('/')
  }
}

async function searchFromRouteIfNeeded() {
  const demandeId = route.params.id
  if (demandeId != null && String(demandeId).trim() !== '') {
    searchType.value = 'demande'
    searchInput.value = String(demandeId)
    await search()
  }
}

onMounted(async () => {
  await searchFromRouteIfNeeded()
})

watch(
  () => route.params.id,
  async () => {
    await searchFromRouteIfNeeded()
  }
)
</script>

<template>
  <div class="app-container">
    <div class="header">
      <h1>Recherche de Demandes</h1>
      <p>Consultez l'historique de vos demandes de visa</p>
    </div>

    <SearchForm
      v-model:searchType="searchType"
      v-model:searchInput="searchInput"
      :loading="loading"
      :error="error"
      :showResults="!!results"
      @search="search"
      @reset="resetSearch"
    />

    <ResultsSection
      v-if="results"
      :demandeurInfo="demandeurInfo"
      :results="results"
      :error="error"
    />

    <div v-if="loading" class="results-section">
      <div class="loading">
        <div class="spinner"></div>
        <span>Recherche en cours...</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.app-container {
  max-width: 1180px;
  margin: 0 auto;
}

.header {
  margin-bottom: 20px;
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-sm);
  padding: 18px 22px;
}

.header h1 {
  font-size: 1.35rem;
  margin-bottom: 2px;
  font-weight: 700;
  color: var(--text-primary);
}

.header p {
  font-size: 0.92rem;
  color: var(--text-secondary);
}

.results-section {
  background: var(--bg-card);
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  padding: 30px;
  box-shadow: var(--shadow-sm);
  margin-top: 30px;
}

.loading {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 40px;
  gap: 15px;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid var(--border-color);
  border-top: 4px solid var(--primary);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

@media (max-width: 768px) {
  .header h1 {
    font-size: 1.1rem;
  }

  .results-section {
    padding: 18px;
  }
}
</style>
