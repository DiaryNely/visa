<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../layout/header.jsp" />

<!-- HEADER BAR -->
<div class="header">
    <div>
        <div class="header-title">Demande de Duplicata</div>
        <div class="header-subtitle">Transfert de visa ou duplicata de carte de résident</div>
    </div>
    <div class="header-actions">
        <a href="${pageContext.request.contextPath}/demandes" class="btn btn-outline">← Retour à la liste</a>
    </div>
</div>

<div class="page-content">

    <!-- ALERTS -->
    <c:if test="${not empty error}">
        <div class="alert alert-error">❌ ${error}</div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="alert alert-success">✅ ${success}</div>
    </c:if>

    <div class="card">
        <div class="card-body">

            <!-- SECTION 1: Sélection d'utilisateur existant -->
            <div class="form-section">
                <div class="form-section-title">🔍 Étape 1 : Sélectionner le demandeur</div>
                <div class="form-row">
                    <div class="form-group" style="flex: 1;">
                        <label class="form-label">Demandeur <span class="required">*</span></label>
                        <select id="demandeurSelect" class="form-control" required onchange="updateDemandeurInfo()">
                            <option value="">-- Sélectionnez un demandeur --</option>
                            <c:forEach var="demandeur" items="${demandeurs}">
                                <option value="${demandeur.id}" data-nom="${demandeur.nom}" data-prenom="${demandeur.prenom}" 
                                        data-email="${demandeur.email}" data-telephone="${demandeur.telephone}"
                                        data-date-naissance="${demandeur.dateNaissance}" data-lieu-naissance="${demandeur.lieuNaissance}">
                                    ${demandeur.nom} ${demandeur.prenom} — ${demandeur.email}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <!-- FORMULAIRE principal - toujours visible mais sections conditionnelles -->
            <form action="${pageContext.request.contextPath}/demandes/duplicata" method="post" id="duplicataForm">
                
                <!-- Champ caché pour demandeurId -->
                <input type="hidden" name="demandeurId" id="demandeurId" value="">

                <!-- SECTION 2: Données personnelles (visible après sélection) -->
                <div id="donneesExistantes" style="display: none;">
                    <div class="form-section">
                        <div class="form-section-title">👤 Données personnelles (pré-remplies)</div>
                        <div class="readonly-panel">
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Nom</label>
                                    <input type="text" id="nomView" class="form-control readonly-field" readonly>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Prénom</label>
                                    <input type="text" id="prenomView" class="form-control readonly-field" readonly>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Email</label>
                                    <input type="text" id="emailView" class="form-control readonly-field" readonly>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Téléphone</label>
                                    <input type="text" id="telephoneView" class="form-control readonly-field" readonly>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Date de naissance</label>
                                    <input type="text" id="dateNaissanceView" class="form-control readonly-field" readonly>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Lieu de naissance</label>
                                    <input type="text" id="lieuNaissanceView" class="form-control readonly-field" readonly>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECTION 3: Type de demande et Motif -->
                <div id="formSections" style="display: none;">
                    <div class="form-section">
                        <div class="form-section-title">📋 Étape 2 : Type de demande</div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Situation <span class="required">*</span></label>
                                <select name="typeDuplicateId" id="typeDuplicateId" class="form-control" required onchange="updateDuplicataFields()">
                                    <option value="">-- Chargement... --</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Motif <span class="required">*</span></label>
                                <select name="motifDuplicateId" id="motifDuplicateId" class="form-control" required>
                                    <option value="">-- Chargement... --</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 4: Nouveau numéro passeport (conditionnel) -->
                    <div id="visaTransferSection" class="form-section" style="display: none;">
                        <div class="form-section-title">🛂 Numéro de passeport</div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Nouveau numéro de passeport <span class="required">*</span></label>
                                <input type="text" name="nouveauNumeroPasseport" id="nouveauNumeroPasseport" class="form-control" 
                                       placeholder="Ex: FR12345678" maxlength="50">
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 5: Observations -->
                    <div class="form-section">
                        <div class="form-section-title">📝 Observations</div>
                        <div class="form-group">
                            <label class="form-label">Observations / Notes supplémentaires</label>
                            <textarea name="observations" class="form-control" placeholder="Détails additionnels concernant cette demande..." rows="4"></textarea>
                        </div>
                    </div>
                </div>

            </form>

        </div>

        <div class="card-footer" style="display: flex; justify-content: flex-end; gap: 12px;">
            <a href="${pageContext.request.contextPath}/demandes" class="btn btn-outline">Annuler</a>
            <button type="submit" id="submitBtn" class="btn btn-primary btn-lg" style="display: none;" onclick="submitDuplicate()">
                📤 Créer la demande
            </button>
        </div>
    </div>

</div>

<script>
// Charger les données au chargement de la page
document.addEventListener('DOMContentLoaded', function() {
    loadDuplicataOptions();
});

function loadDuplicataOptions() {
    fetch('${pageContext.request.contextPath}/demandes/duplicata/data')
        .then(response => response.json())
        .then(data => {
            // Remplir les selects avec les options
            const typeSelect = document.getElementById('typeDuplicateId');
            const motifSelect = document.getElementById('motifDuplicateId');
            
            // Vider les selects sauf l'option par défaut
            typeSelect.innerHTML = '<option value="">-- Sélectionnez --</option>';
            motifSelect.innerHTML = '<option value="">-- Sélectionnez --</option>';
            
            // Ajouter les types
            if (data.types && Array.isArray(data.types)) {
                data.types.forEach(type => {
                    const option = document.createElement('option');
                    option.value = type.id;
                    option.textContent = type.libelle;
                    typeSelect.appendChild(option);
                });
            }
            
            // Ajouter les motifs
            if (data.motifs && Array.isArray(data.motifs)) {
                data.motifs.forEach(motif => {
                    const option = document.createElement('option');
                    option.value = motif.id;
                    option.textContent = motif.libelle;
                    motifSelect.appendChild(option);
                });
            }
        })
        .catch(error => {
            console.error('Erreur lors du chargement des données:', error);
            // Fallback: afficher les options par défaut
            document.getElementById('typeDuplicateId').innerHTML = '<option value="">-- Erreur de chargement --</option>';
            document.getElementById('motifDuplicateId').innerHTML = '<option value="">-- Erreur de chargement --</option>';
        });
}

function updateDemandeurInfo() {
    const select = document.getElementById('demandeurSelect');
    const demandeurId = select.value;
    const selectedOption = select.options[select.selectedIndex];
    
    const formSections = document.getElementById('formSections');
    const donneesExistantes = document.getElementById('donneesExistantes');
    const submitBtn = document.getElementById('submitBtn');

    if (!demandeurId) {
        formSections.style.display = 'none';
        donneesExistantes.style.display = 'none';
        submitBtn.style.display = 'none';
        return;
    }

    // Récupérer les données depuis les attributs data-
    const nom = selectedOption.getAttribute('data-nom') || '';
    const prenom = selectedOption.getAttribute('data-prenom') || '';
    const email = selectedOption.getAttribute('data-email') || '';
    const telephone = selectedOption.getAttribute('data-telephone') || '';
    const dateNaissance = selectedOption.getAttribute('data-date-naissance') || '';
    const lieuNaissance = selectedOption.getAttribute('data-lieu-naissance') || '';

    // Pré-remplir les champs
    document.getElementById('demandeurId').value = demandeurId;
    document.getElementById('nomView').value = nom;
    document.getElementById('prenomView').value = prenom;
    document.getElementById('emailView').value = email;
    document.getElementById('telephoneView').value = telephone;
    document.getElementById('dateNaissanceView').value = dateNaissance;
    document.getElementById('lieuNaissanceView').value = lieuNaissance;

    // Afficher les sections
    donneesExistantes.style.display = 'block';
    formSections.style.display = 'block';
    submitBtn.style.display = 'inline-block';
}

function updateDuplicataFields() {
    const typeSelect = document.getElementById('typeDuplicateId');
    const selectedOption = typeSelect.options[typeSelect.selectedIndex];
    const isVisaTransfer = selectedOption.text && selectedOption.text.toLowerCase().includes('visa');
    
    const visaSection = document.getElementById('visaTransferSection');
    const passportInput = document.getElementById('nouveauNumeroPasseport');
    
    if (isVisaTransfer) {
        visaSection.style.display = 'block';
        passportInput.setAttribute('required', 'required');
    } else {
        visaSection.style.display = 'none';
        passportInput.removeAttribute('required');
        passportInput.value = '';
    }
}

function submitDuplicate() {
    document.getElementById('duplicataForm').submit();
}
</script>

<jsp:include page="../layout/footer.jsp" />
