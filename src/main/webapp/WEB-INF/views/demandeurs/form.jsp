<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../layout/header.jsp" />

<!-- HEADER BAR -->
<div class="header">
    <div>
        <div class="header-title">Nouveau demandeur</div>
        <div class="header-subtitle">Enregistrement d'un nouveau demandeur avec passeport et VISA transformable</div>
    </div>
    <div class="header-actions">
        <a href="${pageContext.request.contextPath}/demandeurs" class="btn btn-outline">← Retour à la liste</a>
    </div>
</div>

<div class="page-content">

    <!-- ALERTS -->
    <c:if test="${not empty error}">
        <div class="alert alert-error">❌ ${error}</div>
    </c:if>

    <div class="card mb-2">
        <div class="card-body">
            <div class="form-section" style="margin-bottom: 0;">
                <div class="form-section-title">🔍 Rechercher un demandeur par passeport</div>
                <div class="form-row" style="align-items: flex-end;">
                    <div class="form-group" style="flex: 1;">
                        <label class="form-label">Numéro de passeport</label>
                        <input type="text" id="lookupNumeroPasseport" class="form-control" placeholder="Saisir le numéro puis cliquer sur Rechercher">
                    </div>
                    <div class="form-group" style="flex: 0 0 auto; display: flex; gap: 10px;">
                        <button type="button" class="btn btn-primary" onclick="lookupDemandeurByPassport()">🔎 Rechercher</button>
                        <button type="button" class="btn btn-outline" onclick="resetDemandeurForm()">↺ Nouveau</button>
                    </div>
                </div>
                <div id="lookupMessage" class="alert alert-info" style="display: none; margin-top: 12px;"></div>
            </div>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/demandeurs/nouveau" method="post">
        <input type="hidden" name="demandeurId" id="demandeurId" value="">
        <div class="card">
            <div class="card-body">

                <!-- SECTION: État civil -->
                <div class="form-section">
                    <div class="form-section-title">👤 État civil</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Nom <span class="required">*</span></label>
                            <input type="text" name="nom" id="nom" class="form-control" required placeholder="Ex: DUPONT">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Prénom <span class="required">*</span></label>
                            <input type="text" name="prenom" id="prenom" class="form-control" required placeholder="Ex: Jean">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Nom de jeune fille</label>
                            <input type="text" name="nomJeuneFille" id="nomJeuneFille" class="form-control" placeholder="Si applicable">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Nom du père</label>
                            <input type="text" name="nomPere" id="nomPere" class="form-control" placeholder="Nom du père">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Date de naissance <span class="required">*</span></label>
                            <input type="date" name="dateNaissance" id="dateNaissance" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Lieu de naissance <span class="required">*</span></label>
                            <input type="text" name="lieuNaissance" id="lieuNaissance" class="form-control" required placeholder="Ville, Pays">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Nationalité <span class="required">*</span></label>
                            <select name="nationaliteId" id="nationaliteId" class="form-control" required>
                                <option value="">-- Sélectionnez --</option>
                                <c:forEach var="n" items="${nationalites}">
                                    <option value="${n.id}">${n.libelle}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Situation familiale <span class="required">*</span></label>
                            <select name="situationFamilialeId" id="situationFamilialeId" class="form-control" required>
                                <option value="">-- Sélectionnez --</option>
                                <c:forEach var="sf" items="${situationsFamiliales}">
                                    <option value="${sf.id}">${sf.libelle}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Profession</label>
                            <input type="text" name="profession" id="profession" class="form-control" placeholder="Profession actuelle">
                        </div>
                    </div>
                </div>

                <!-- SECTION: Coordonnées -->
                <div class="form-section">
                    <div class="form-section-title">📞 Coordonnées</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Téléphone <span class="required">*</span></label>
                            <input type="tel" name="telephone" id="telephone" class="form-control" required placeholder="+261 34 00 000 00">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Email <span class="required">*</span></label>
                            <input type="email" name="email" id="email" class="form-control" required placeholder="email@exemple.com">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Adresse <span class="required">*</span></label>
                        <textarea name="adresse" id="adresse" class="form-control" required placeholder="Adresse complète du demandeur" style="min-height: 80px;"></textarea>
                    </div>
                </div>

                <!-- SECTION: Passeport -->
                <div class="form-section" id="passportSection">
                    <div class="form-section-title">🛂 Passeport actif</div>
                    <div id="passportModeInfo" class="alert alert-info mb-2">
                        ℹ️ Renseignez un nouveau numéro de passeport pour créer un demandeur, ou recherchez un passeport existant pour modifier le demandeur sans créer de doublon.
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Numéro de passeport <span class="required">*</span></label>
                            <input type="text" name="numeroPasse" id="numeroPasse" class="form-control" required placeholder="Ex: AB1234567">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Pays de délivrance</label>
                            <input type="text" name="paysDelivrance" id="paysDelivrance" class="form-control" placeholder="Ex: France">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Date de délivrance <span class="required">*</span></label>
                            <input type="date" name="dateDelivrancePasse" id="dateDelivrancePasse" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Date d'expiration <span class="required">*</span></label>
                            <input type="date" name="dateExpirationPasse" id="dateExpirationPasse" class="form-control" required>
                        </div>
                    </div>
                </div>

                <!-- SECTION: VISA Transformable -->
                <div class="form-section">
                    <div class="form-section-title">🌐 VISA Transformable</div>
                    <div class="alert alert-info mb-2">
                        ℹ️ Requis pour creer la demande initiale et associer les pieces justificatives.
                    </div>
                    
                    <!-- Sélection d'un visa transformable existant -->
                    <div class="form-row" id="existingVisaSection" style="display: none;">
                        <div class="form-group">
                            <label class="form-label">Visa transformable existant</label>
                            <select id="visaTransformableSelect" class="form-control" onchange="selectExistingVisa()">
                                <option value="">-- Créer un nouveau --</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Numéro de référence du VISA transformable <span class="required">*</span></label>
                            <input type="text" name="numeroReferenceVisa" id="numeroReferenceVisa" class="form-control" placeholder="Ex: VT-2024-001234" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Lieu d'entree a l'aeroport <span class="required">*</span></label>
                            <input type="text" name="lieuEntreeVisa" id="lieuEntreeVisa" class="form-control" placeholder="Ex: Aeroport international" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Date d'entree <span class="required">*</span></label>
                            <input type="date" name="dateEntreeVisa" id="dateEntreeVisa" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Date d'expiration du VISA transformable <span class="required">*</span></label>
                            <input type="date" name="dateExpirationVisa" id="dateExpirationVisa" class="form-control" required>
                        </div>
                    </div>
                    <input type="hidden" name="visaTransformableId" id="visaTransformableId">
                </div>

                <!-- SECTION: Demande initiale + pieces -->
                <div class="form-section">
                    <div class="form-section-title">📋 Demande initiale et pieces justificatives</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Type de demande <span class="required">*</span></label>
                            <select name="typeDemandeId" id="typeDemandeSelect" class="form-control" required onchange="loadPiecesJustificatives()">
                                <option value="">-- Selectionnez --</option>
                                <c:forEach var="td" items="${typesDemande}">
                                    <option value="${td.id}">${td.libelle}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Type de VISA demande <span class="required">*</span></label>
                            <select name="typeVisaId" id="typeVisaSelect" class="form-control" required onchange="loadPiecesJustificatives()">
                                <option value="">-- Selectionnez --</option>
                                <c:forEach var="tv" items="${typesVisa}">
                                    <option value="${tv.id}">${tv.libelle}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Motif de duplicata (visible seulement pour Duplicata/Transfert) -->
                    <div id="motifDuplicataSection" style="display: none;" class="form-row">
                        <div class="form-group">
                            <label class="form-label">Motif <span class="required">*</span></label>
                            <select name="motifDuplicateId" id="motifDuplicateSelect" class="form-control">
                                <option value="">-- Chargement... --</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Nouveau numéro de passeport (si Transfert) <span id="passportRequired"></span></label>
                            <input type="text" name="nouveauNumeroPasseport" id="nouveauNumeroPasseport" class="form-control" 
                                   placeholder="Ex: FR12345678" maxlength="50">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Profil (optionnel)</label>
                            <select name="typeProfilId" class="form-control">
                                <option value="">-- Aucun --</option>
                                <c:forEach var="tp" items="${typesProfil}">
                                    <option value="${tp.id}">${tp.libelle}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div id="piecesContainer" class="checklist-box mt-2">
                        <div class="text-muted">Selectionnez d'abord le type de demande et le type de VISA.</div>
                    </div>
                </div>

            </div>

            <div class="card-footer" style="display: flex; justify-content: flex-end; gap: 12px;">
                <a href="${pageContext.request.contextPath}/demandeurs" class="btn btn-outline">Annuler</a>
                <button type="submit" id="submitBtn" class="btn btn-primary btn-lg">💾 Enregistrer le demandeur</button>
            </div>
        </div>
    </form>

</div>

<script>
// Charger les motifs de duplicata au chargement de la page
document.addEventListener('DOMContentLoaded', function() {
    loadDuplicataMotifs();
});

function lookupDemandeurByPassport() {
    var lookupInput = document.getElementById('lookupNumeroPasseport');
    var lookupMessage = document.getElementById('lookupMessage');
    var numeroPasse = lookupInput.value.trim();

    if (!numeroPasse) {
        showLookupMessage('Saisissez un numéro de passeport avant de lancer la recherche.', 'alert-warning');
        return;
    }

    fetch('${pageContext.request.contextPath}/api/demandeurs/par-passeport/' + encodeURIComponent(numeroPasse))
        .then(function(response) {
            if (response.status === 404) {
                return null;
            }
            if (!response.ok) {
                throw new Error('Erreur lors de la recherche du demandeur');
            }
            return response.json();
        })
        .then(function(data) {
            if (!data) {
                resetDemandeurForm();
                document.getElementById('numeroPasse').value = numeroPasse;
                showLookupMessage('Aucun demandeur trouvé pour ce passeport. Vous pouvez créer un nouveau dossier avec ce numéro.', 'alert-info');
                return;
            }

            fillDemandeurForm(data);
            showLookupMessage('Demandeur existant trouvé. Les informations ont été préremplies et le formulaire est passé en mode mise à jour.', 'alert-success');
        })
        .catch(function(error) {
            console.error('Erreur lors de la recherche:', error);
            showLookupMessage('Erreur lors de la recherche du demandeur.', 'alert-error');
        });
}

// Variable globale pour stocker les visas transformables pour le JavaScript
var globalVisasTransformables = [];
var globalLastDemande = null;

function fillDemandeurForm(data) {
    console.log('DEBUG: fillDemandeurForm data =', data);
    
    var demandeur = data.demandeur || {};
    var passeport = (data.demandeur && data.demandeur.passeportActif) || {};
    var visasTransformables = data.visasTransformables || [];
    var derniereDemande = data.derniereDemande || null;

    // Stocker les visas et dernière demande pour utilisation ultérieure
    globalVisasTransformables = visasTransformables;
    globalLastDemande = derniereDemande;

    console.log('DEBUG: visasTransformables =', visasTransformables);
    console.log('DEBUG: derniereDemande =', derniereDemande);

    // ===== SECTION 1: Remplir les infos du demandeur =====
    document.getElementById('demandeurId').value = demandeur.id || '';
    document.getElementById('nom').value = demandeur.nom || '';
    document.getElementById('prenom').value = demandeur.prenom || '';
    document.getElementById('nomJeuneFille').value = demandeur.nomJeuneFille || '';
    document.getElementById('nomPere').value = demandeur.nomPere || '';
    document.getElementById('dateNaissance').value = demandeur.dateNaissance || '';
    document.getElementById('lieuNaissance').value = demandeur.lieuNaissance || '';
    document.getElementById('profession').value = demandeur.profession || '';
    document.getElementById('telephone').value = demandeur.telephone || '';
    document.getElementById('email').value = demandeur.email || '';
    document.getElementById('adresse').value = demandeur.adresse || '';
    document.getElementById('nationaliteId').value = demandeur.nationaliteId || '';
    document.getElementById('situationFamilialeId').value = demandeur.situationFamilialeId || '';

    // ===== SECTION 2: Remplir les infos du passeport =====
    if (passeport && passeport.numeroPasse) {
        document.getElementById('numeroPasse').value = passeport.numeroPasse;
        document.getElementById('paysDelivrance').value = passeport.paysDelivrance || '';
        document.getElementById('dateDelivrancePasse').value = convertToDateFormat(passeport.dateDelivrance);
        document.getElementById('dateExpirationPasse').value = convertToDateFormat(passeport.dateExpiration);
        setPassportMode(true, passeport.numeroPasse);
    } else {
        setPassportMode(false, '');
    }

    // ===== SECTION 3: Remplir les visas transformables =====
    if (visasTransformables && visasTransformables.length > 0) {
        var visaSelect = document.getElementById('visaTransformableSelect');
        visaSelect.innerHTML = '<option value="">-- Créer un nouveau --</option>';
        
        var visaASelectionner = null;
        
        // Créer les options et identifier le visa à sélectionner
        visasTransformables.forEach(function(visa) {
            var option = document.createElement('option');
            option.value = visa.id;
            option.textContent = visa.numeroReference + ' (Expire: ' + formatDate(visa.dateExpiration) + ')';
            visaSelect.appendChild(option);
            
            // Si dernière demande a un visa, le marquer pour sélection
            if (derniereDemande && derniereDemande.visaTransformableId && visa.id == derniereDemande.visaTransformableId) {
                visaASelectionner = visa;
            }
        });
        
        // Si pas de dernier visa, prendre le premier
        if (!visaASelectionner && visasTransformables.length > 0) {
            visaASelectionner = visasTransformables[0];
        }
        
        // Maintenant remplir les champs du visa directement
        if (visaASelectionner) {
            console.log('DEBUG: Remplissage visa =', visaASelectionner);
            visaSelect.value = visaASelectionner.id;
            document.getElementById('numeroReferenceVisa').value = visaASelectionner.numeroReference || '';
            document.getElementById('lieuEntreeVisa').value = visaASelectionner.lieuEntree || '';
            document.getElementById('dateEntreeVisa').value = convertToDateFormat(visaASelectionner.dateEntree);
            document.getElementById('dateExpirationVisa').value = convertToDateFormat(visaASelectionner.dateExpiration);
            document.getElementById('visaTransformableId').value = visaASelectionner.id || '';
        }
        
        document.getElementById('existingVisaSection').style.display = 'block';
    } else {
        document.getElementById('existingVisaSection').style.display = 'none';
        // Effacer les champs visa
        document.getElementById('numeroReferenceVisa').value = '';
        document.getElementById('lieuEntreeVisa').value = '';
        document.getElementById('dateEntreeVisa').value = '';
        document.getElementById('dateExpirationVisa').value = '';
        document.getElementById('visaTransformableId').value = '';
    }

    // ===== SECTION 4: Remplir les infos de demande =====
    if (derniereDemande) {
        console.log('DEBUG: Remplissage demande avec derniereDemande');
        var typeDemandeValue = derniereDemande.typeDemande ? derniereDemande.typeDemande.id : '';
        var typeVisaValue = derniereDemande.typeVisa ? derniereDemande.typeVisa.id : '';
        var typeProfilValue = (derniereDemande.typeProfil && derniereDemande.typeProfil.id) ? derniereDemande.typeProfil.id : '';
        
        document.getElementById('typeDemandeSelect').value = typeDemandeValue;
        document.getElementById('typeVisaSelect').value = typeVisaValue;
        
        var typeProfilSelect = document.getElementById('typeProfilId') || document.querySelector('[name="typeProfilId"]');
        if (typeProfilSelect && typeProfilValue) {
            typeProfilSelect.value = typeProfilValue;
        }
    } else {
        console.log('DEBUG: Pas de derniereDemande, champs demande vides');
    }

    // ===== SECTION 5: Charger les pièces justificatives =====
    console.log('DEBUG: Appel loadPiecesJustificatives');
    setTimeout(function() {
        loadPiecesJustificativesComplete();
    }, 200);

    document.getElementById('submitBtn').textContent = '💾 Mettre à jour le demandeur et créer la demande';
}

// Nouvelle fonction pour charger les pièces avec gestion d'erreur
function loadPiecesJustificativesComplete() {
    var typeDemandeId = document.getElementById('typeDemandeSelect').value;
    var typeVisaId = document.getElementById('typeVisaSelect').value;
    
    console.log('DEBUG: loadPiecesJustificativesComplete - typeDemandeId =', typeDemandeId, 'typeVisaId =', typeVisaId);
    
    // Si pas de type demande ou visa, afficher message et attendre que l'utilisateur sélectionne
    if (!typeDemandeId || !typeVisaId) {
        console.log('DEBUG: Types demande/visa vides, attendant sélection utilisateur');
        var container = document.getElementById('piecesContainer');
        container.innerHTML = '<div class="text-muted">Selectionnez le type de demande et le type de VISA pour charger les pieces justificatives.</div>';
        return;
    }
    
    // Sinon appeler la fonction normale
    loadPiecesJustificatives();
}

// Convertit une date du format ISO (YYYY-MM-DD ou YYYY-MM-DDTHH:mm:ss) vers YYYY-MM-DD pour input type="date"
function convertToDateFormat(dateString) {
    if (!dateString) return '';
    
    // Si c'est un format ISO complet avec heure, extraire juste la date
    if (dateString.includes('T')) {
        return dateString.split('T')[0];
    }
    
    // Si c'est déjà au format YYYY-MM-DD, retourner tel quel
    if (/^\d{4}-\d{2}-\d{2}$/.test(dateString)) {
        return dateString;
    }
    
    // Si c'est au format DD/MM/YYYY, le convertir en YYYY-MM-DD
    if (/^\d{2}\/\d{2}\/\d{4}$/.test(dateString)) {
        var parts = dateString.split('/');
        return parts[2] + '-' + parts[1] + '-' + parts[0];
    }
    
    return '';
}

// Formate une date au format YYYY-MM-DD vers DD/MM/YYYY
function formatDate(dateString) {
    if (!dateString) return '';
    var date = new Date(dateString + 'T00:00:00Z');
    var day = String(date.getUTCDate()).padStart(2, '0');
    var month = String(date.getUTCMonth() + 1).padStart(2, '0');
    var year = date.getUTCFullYear();
    return day + '/' + month + '/' + year;
}

// Remplit les champs visa quand l'utilisateur change la sélection manuellement
function selectExistingVisa() {
    var visaSelect = document.getElementById('visaTransformableSelect');
    var selectedVisaId = visaSelect.value;
    
    if (selectedVisaId && globalVisasTransformables && globalVisasTransformables.length > 0) {
        // Chercher le visa dans les données globales
        var visa = null;
        for (var i = 0; i < globalVisasTransformables.length; i++) {
            if (globalVisasTransformables[i].id == selectedVisaId) {
                visa = globalVisasTransformables[i];
                break;
            }
        }
        
        if (visa) {
            console.log('DEBUG: selectExistingVisa remplissage avec =', visa);
            document.getElementById('numeroReferenceVisa').value = visa.numeroReference || '';
            document.getElementById('lieuEntreeVisa').value = visa.lieuEntree || '';
            document.getElementById('dateEntreeVisa').value = convertToDateFormat(visa.dateEntree);
            document.getElementById('dateExpirationVisa').value = convertToDateFormat(visa.dateExpiration);
            document.getElementById('visaTransformableId').value = visa.id || '';
        }
    } else {
        // Effacer les champs si on crée un nouveau visa
        document.getElementById('numeroReferenceVisa').value = '';
        document.getElementById('lieuEntreeVisa').value = '';
        document.getElementById('dateEntreeVisa').value = '';
        document.getElementById('dateExpirationVisa').value = '';
        document.getElementById('visaTransformableId').value = '';
    }
}

function setPassportMode(isExisting, numeroPasse) {
    var passportModeInfo = document.getElementById('passportModeInfo');
    var passportInputs = [
        document.getElementById('numeroPasse'),
        document.getElementById('paysDelivrance'),
        document.getElementById('dateDelivrancePasse'),
        document.getElementById('dateExpirationPasse')
    ];

    passportInputs.forEach(function(input) {
        if (!input) {
            return;
        }
        input.disabled = isExisting;
    });

    if (!isExisting) {
        document.getElementById('numeroPasse').setAttribute('required', 'required');
        document.getElementById('dateDelivrancePasse').setAttribute('required', 'required');
        document.getElementById('dateExpirationPasse').setAttribute('required', 'required');
    } else {
        document.getElementById('numeroPasse').removeAttribute('required');
        document.getElementById('dateDelivrancePasse').removeAttribute('required');
        document.getElementById('dateExpirationPasse').removeAttribute('required');
    }

    if (isExisting) {
        passportModeInfo.className = 'alert alert-success mb-2';
        passportModeInfo.textContent = 'Passeport trouvé : ' + numeroPasse + '. Les champs passeport sont verrouillés pour éviter la création d’un doublon.';
    } else {
        passportModeInfo.className = 'alert alert-info mb-2';
        passportModeInfo.textContent = 'Renseignez un nouveau numéro de passeport pour créer un demandeur, ou recherchez un passeport existant pour modifier le demandeur sans créer de doublon.';
    }
}

function resetDemandeurForm() {
    var form = document.querySelector('form[action="${pageContext.request.contextPath}/demandeurs/nouveau"]');
    form.reset();
    document.getElementById('demandeurId').value = '';
    document.getElementById('visaTransformableId').value = '';
    document.getElementById('visaTransformableSelect').value = '';
    document.getElementById('submitBtn').textContent = '💾 Enregistrer le demandeur';
    setPassportMode(false, '');
    document.getElementById('lookupMessage').style.display = 'none';
    document.getElementById('existingVisaSection').style.display = 'none';
    globalVisasTransformables = [];
    globalLastDemande = null;
}

function showLookupMessage(message, alertClass) {
    var lookupMessage = document.getElementById('lookupMessage');
    lookupMessage.className = 'alert ' + alertClass;
    lookupMessage.textContent = message;
    lookupMessage.style.display = 'block';
}

function loadDuplicataMotifs() {
    fetch('${pageContext.request.contextPath}/demandeurs/duplicata-motifs')
        .then(function(response) { return response.json(); })
        .then(function(data) {
            var select = document.getElementById('motifDuplicateSelect');
            select.innerHTML = '<option value="">-- Sélectionnez --</option>';
            if (data && Array.isArray(data)) {
                data.forEach(function(motif) {
                    var option = document.createElement('option');
                    option.value = motif.id;
                    option.textContent = motif.libelle;
                    select.appendChild(option);
                });
            }
        })
        .catch(function(error) {
            console.error('Erreur lors du chargement des motifs:', error);
        });
}

function loadPiecesJustificatives() {
    var typeDemandeId = document.getElementById('typeDemandeSelect').value;
    var typeVisaId = document.getElementById('typeVisaSelect').value;
    var typeDemandeSelect = document.getElementById('typeDemandeSelect');
    var selectedOptionText = typeDemandeSelect.options[typeDemandeSelect.selectedIndex].text;
    var container = document.getElementById('piecesContainer');
    var motifSection = document.getElementById('motifDuplicataSection');
    var passportInput = document.getElementById('nouveauNumeroPasseport');
    var passportRequired = document.getElementById('passportRequired');

    // Vérifier si c'est un type de demande "Duplicata" ou "Transfert"
    var isDuplicataOrTransfer = selectedOptionText.toLowerCase().includes('duplicata') || 
                                selectedOptionText.toLowerCase().includes('transfert');

    if (isDuplicataOrTransfer) {
        motifSection.style.display = 'block';
        
        // Si c'est un Transfert, rendre le passeport obligatoire
        if (selectedOptionText.toLowerCase().includes('transfert')) {
            passportRequired.innerHTML = '<span class="required">*</span>';
            passportInput.setAttribute('required', 'required');
        } else {
            passportRequired.innerHTML = '';
            passportInput.removeAttribute('required');
            passportInput.value = '';
        }
    } else {
        motifSection.style.display = 'none';
        passportRequired.innerHTML = '';
        passportInput.removeAttribute('required');
        passportInput.value = '';
    }

    if (!typeDemandeId || !typeVisaId) {
        container.innerHTML = '<div class="text-muted">Selectionnez d\'abord le type de demande et le type de VISA.</div>';
        return;
    }

    fetch('${pageContext.request.contextPath}/demandeurs/pieces-justificatives?typeDemandeId=' + typeDemandeId + '&typeVisaId=' + typeVisaId)
        .then(function(response) { return response.json(); })
        .then(function(pieces) {
            if (!pieces || pieces.length === 0) {
                container.innerHTML = '<div class="alert alert-warning">Aucune piece justificative configuree pour cette combinaison.</div>';
                return;
            }

            var html = '<div class="checklist-title">Pieces justificatives a cocher</div>';
            html += '<div class="checklist-help">Les pieces marquees <strong>(Obligatoire)</strong> doivent etre cochees pour valider la creation.</div>';
            html += '<div class="checklist-list">';

            for (var i = 0; i < pieces.length; i++) {
                var p = pieces[i];
                var requiredAttr = p.obligatoire ? ' required' : '';
                var labelSuffix = p.obligatoire ? ' <span class="required">(Obligatoire)</span>' : ' <span class="text-muted">(Optionnel)</span>';
                html += '<label class="check-item">';
                html += '<input type="checkbox" name="pieceIds" value="' + p.id + '"' + requiredAttr + ' />';
                html += '<span>' + p.libelle + labelSuffix + '</span>';
                html += '</label>';
            }

            html += '</div>';
            container.innerHTML = html;
        })
        .catch(function() {
            container.innerHTML = '<div class="alert alert-error">Erreur lors du chargement des pieces justificatives.</div>';
        });
}
</script>

<jsp:include page="../layout/footer.jsp" />
