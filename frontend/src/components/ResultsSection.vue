<script setup>
defineProps({
  demandeurInfo: Object,
  results: Array,
  error: String
})

function formatDate(dateString) {
  if (!dateString) return 'N/A'

  try {
    const date = new Date(dateString)
    const options = {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    }
    return date.toLocaleDateString('fr-FR', options)
  } catch {
    return dateString
  }
}

function formatStatut(statut) {
  const statusMap = {
    'brouillon': '📝 Brouillon',
    'soumise': '📤 Soumise',
    'en_cours': '⏳ En cours',
    'validee': '✅ Validée',
    'rejetee': '❌ Rejetée'
  }
  return statusMap[statut] || statut
}

function getStatutClass(statut) {
  return 'statut-' + (statut || 'brouillon')
}
</script>

<template>
  <div class="results-section">
    <!-- Infos Demandeur -->
    <div v-if="demandeurInfo" class="demandeur-info">
      <h3>👤 Informations du Demandeur</h3>
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">Nom Complet</div>
          <div class="info-value">{{ demandeurInfo.prenom }} {{ demandeurInfo.nom }}</div>
        </div>
        <div class="info-item">
          <div class="info-label">Nationalité</div>
          <div class="info-value">{{ demandeurInfo.nationalite?.libelle }}</div>
        </div>
        <div class="info-item">
          <div class="info-label">Email</div>
          <div class="info-value">{{ demandeurInfo.email }}</div>
        </div>
        <div class="info-item">
          <div class="info-label">Téléphone</div>
          <div class="info-value">{{ demandeurInfo.telephone }}</div>
        </div>
      </div>
    </div>

    <!-- Liste des demandes -->
    <div>
      <h2 class="results-title">
        📋 Demandes ({{ results.length }} trouvée{{ results.length > 1 ? 's' : '' }})
      </h2>

      <div v-if="results.length === 0" class="empty-state">
        <h3>Aucune demande trouvée</h3>
        <p>Ce demandeur n'a pas encore effectué de demande.</p>
      </div>

      <div v-else class="table-responsive">
        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>Type de Demande</th>
              <th>Type de Visa</th>
              <th>Statut</th>
              <th>Date de Demande</th>
              <th>Date de Traitement</th>
              
            </tr>
          </thead>
          <tbody>
            <tr v-for="demande in results" :key="demande.id">
              <td><strong>#{{ demande.id }}</strong></td>
              <td>{{ demande.typeDemande?.libelle || 'N/A' }}</td>
              <td>{{ demande.typeVisa?.libelle || 'N/A' }}</td>
              <td>
                <span class="statut-badge" :class="getStatutClass(demande.statut)">
                  {{ formatStatut(demande.statut) }}
                </span>
              </td>
              <td>{{ formatDate(demande.dateDemande) }}</td>
              <td>{{ demande.dateTraitement ? formatDate(demande.dateTraitement) : 'En attente' }}</td>
              
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<style scoped>
.results-section {
  background: var(--bg-card);
  border-radius: var(--radius-md);
  padding: 22px;
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--border-color);
}

.demandeur-info {
  background: var(--bg-soft);
  padding: 16px;
  border-radius: var(--radius-sm);
  margin-bottom: 18px;
  border: 1px solid var(--border-color);
}

.demandeur-info h3 {
  margin-bottom: 12px;
  color: var(--text-primary);
  font-size: 1rem;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 15px;
}

.info-item {
  background: #ffffff;
  padding: 10px;
  border-radius: 6px;
  border: 1px solid var(--border-color);
}

.info-label {
  font-size: 0.78rem;
  color: var(--text-secondary);
  font-weight: 600;
  margin-bottom: 4px;
}

.info-value {
  font-size: 0.92rem;
  color: var(--text-primary);
  font-weight: 500;
}

.results-title {
  font-size: 1.05rem;
  font-weight: 700;
  margin-bottom: 14px;
  color: var(--text-primary);
}

.table-responsive {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 8px;
}

thead {
  background: var(--bg-soft);
}

th {
  padding: 11px 12px;
  text-align: left;
  font-weight: 600;
  color: var(--text-secondary);
  border-bottom: 1px solid var(--border-color);
  font-size: 0.82rem;
  text-transform: uppercase;
  letter-spacing: 0.4px;
}

td {
  padding: 12px;
  border-bottom: 1px solid var(--border-color);
  color: var(--text-primary);
  font-size: 0.9rem;
}

tr:hover {
  background: #f8fafc;
}

.statut-badge {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 999px;
  font-size: 0.78rem;
  font-weight: 600;
  text-transform: capitalize;
}

.detail-link {
  display: inline-block;
  border: 1px solid var(--primary);
  color: var(--primary);
  border-radius: 999px;
  padding: 4px 10px;
  text-decoration: none;
  font-size: 0.8rem;
  font-weight: 600;
}

.detail-link:hover {
  background: var(--primary);
  color: #fff;
}

.statut-brouillon {
  background: #fff3cd;
  color: #856404;
}

.statut-soumise {
  background: #cce5ff;
  color: #004085;
}

.statut-en_cours {
  background: #d1ecf1;
  color: #0c5460;
}

.statut-validee {
  background: #d4edda;
  color: #155724;
}

.statut-rejetee {
  background: #f8d7da;
  color: #721c24;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: var(--text-muted);
}

.empty-state h3 {
  margin-bottom: 10px;
  color: var(--text-secondary);
}

@media (max-width: 768px) {
  .info-grid {
    grid-template-columns: 1fr;
  }

  table {
    font-size: 0.85rem;
  }

  th, td {
    padding: 9px;
  }
}
</style>
