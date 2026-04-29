<script setup>
import { onMounted, ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const demande = ref(null)
const loading = ref(true)
const error = ref(null)
const showQrModal = ref(false)

const demandeId = computed(() => route.params.id)

const qrImageSrc = computed(() => {
  if (!demande.value?.qrCodeImageBase64) {
    return ''
  }
  return `data:image/png;base64,${demande.value.qrCodeImageBase64}`
})

function formatDate(dateString) {
  if (!dateString) return '—'
  try {
    const date = new Date(dateString)
    return date.toLocaleDateString('fr-FR', {
      year: 'numeric',
      month: 'long',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    })
  } catch {
    return dateString
  }
}

async function loadDemande() {
  loading.value = true
  error.value = null

  try {
    const response = await fetch(`http://localhost:8081/api/demandes/${encodeURIComponent(demandeId.value)}`)
    if (!response.ok) {
      if (response.status === 404) {
        throw new Error('Demande introuvable')
      }
      throw new Error('Erreur lors du chargement de la demande')
    }

    demande.value = await response.json()
  } catch (e) {
    error.value = e.message || 'Erreur inconnue'
  } finally {
    loading.value = false
  }
}

onMounted(loadDemande)
</script>

<template>
  <div class="detail-page">
    <div class="header-card">
      <div>
        <h1>Détail de la demande #{{ demandeId }}</h1>
        <p>Accès direct via QR code</p>
      </div>
      <button class="btn btn-secondary" @click="router.push('/')">Retour à la recherche</button>
    </div>

    <div v-if="loading" class="card">Chargement...</div>
    <div v-else-if="error" class="card error">{{ error }}</div>

    <template v-else>
      <div class="card">
        <h3>Informations principales</h3>
        <div class="grid">
          <div><span class="label">Demandeur</span><span class="value">{{ demande.demandeur?.prenom }} {{ demande.demandeur?.nom }}</span></div>
          <div><span class="label">Type demande</span><span class="value">{{ demande.typeDemande?.libelle || '—' }}</span></div>
          <div><span class="label">Type VISA</span><span class="value">{{ demande.typeVisa?.libelle || '—' }}</span></div>
          <div><span class="label">Statut</span><span class="value">{{ demande.statut || '—' }}</span></div>
          <div><span class="label">Date demande</span><span class="value">{{ formatDate(demande.dateDemande) }}</span></div>
          <div><span class="label">Date traitement</span><span class="value">{{ formatDate(demande.dateTraitement) }}</span></div>
        </div>
      </div>

      <div class="card qr-card" v-if="demande.qrCodeImageBase64">
        <h3>QR code de la demande</h3>
        <img :src="qrImageSrc" alt="QR code" class="qr-thumb" />
        <div class="qr-actions">
          <button class="btn btn-primary" @click="showQrModal = true">Afficher en grand</button>
          <a class="btn btn-outline" :href="demande.qrCodeUrl" target="_blank">Ouvrir l'URL</a>
        </div>
      </div>
    </template>

    <div v-if="showQrModal" class="modal-overlay" @click.self="showQrModal = false">
      <div class="modal-card">
        <button class="modal-close" @click="showQrModal = false">✕</button>
        <img :src="qrImageSrc" alt="QR code en grand" class="qr-large" />
      </div>
    </div>
  </div>
</template>

<style scoped>
.detail-page {
  max-width: 980px;
  margin: 0 auto;
}

.header-card,
.card {
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-sm);
  padding: 18px;
}

.header-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.header-card h1 {
  font-size: 1.25rem;
  margin: 0;
}

.header-card p {
  color: var(--text-secondary);
  margin-top: 4px;
}

.card {
  margin-bottom: 14px;
}

.error {
  color: #b91c1c;
  background: #fef2f2;
  border-color: #fecaca;
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 14px;
  margin-top: 12px;
}

.label {
  display: block;
  color: var(--text-secondary);
  font-size: 0.82rem;
  margin-bottom: 3px;
}

.value {
  font-weight: 600;
  color: var(--text-primary);
}

.qr-card {
  text-align: center;
}

.qr-thumb {
  width: 140px;
  height: 140px;
  border: 1px solid var(--border-color);
  border-radius: 8px;
  padding: 8px;
  background: #fff;
  margin-top: 10px;
}

.qr-actions {
  margin-top: 14px;
  display: flex;
  gap: 10px;
  justify-content: center;
}

.btn {
  border: none;
  border-radius: var(--radius-sm);
  padding: 9px 14px;
  font-weight: 600;
  cursor: pointer;
  text-decoration: none;
}

.btn-primary {
  background: var(--primary);
  color: #fff;
}

.btn-secondary {
  background: var(--bg-soft);
  color: var(--text-primary);
  border: 1px solid var(--border-color);
}

.btn-outline {
  border: 1px solid var(--primary);
  color: var(--primary);
  background: #fff;
}

.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(15, 23, 42, 0.55);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}

.modal-card {
  position: relative;
  background: #fff;
  border-radius: 12px;
  padding: 20px;
}

.modal-close {
  position: absolute;
  top: 8px;
  right: 10px;
  border: none;
  background: transparent;
  font-size: 18px;
  cursor: pointer;
}

.qr-large {
  width: min(78vw, 420px);
  height: auto;
}
</style>
