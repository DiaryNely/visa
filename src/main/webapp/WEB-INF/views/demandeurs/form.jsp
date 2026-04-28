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

    <form action="${pageContext.request.contextPath}/demandeurs/nouveau" method="post">
        <div class="card">
            <div class="card-body">

                <!-- SECTION: État civil -->
                <div class="form-section">
                    <div class="form-section-title">👤 État civil</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Nom <span class="required">*</span></label>
                            <input type="text" name="nom" class="form-control" required placeholder="Ex: DUPONT">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Prénom <span class="required">*</span></label>
                            <input type="text" name="prenom" class="form-control" required placeholder="Ex: Jean">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Nom de jeune fille</label>
                            <input type="text" name="nomJeuneFille" class="form-control" placeholder="Si applicable">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Nom du père</label>
                            <input type="text" name="nomPere" class="form-control" placeholder="Nom du père">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Date de naissance <span class="required">*</span></label>
                            <input type="date" name="dateNaissance" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Lieu de naissance <span class="required">*</span></label>
                            <input type="text" name="lieuNaissance" class="form-control" required placeholder="Ville, Pays">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Nationalité <span class="required">*</span></label>
                            <select name="nationaliteId" class="form-control" required>
                                <option value="">-- Sélectionnez --</option>
                                <c:forEach var="n" items="${nationalites}">
                                    <option value="${n.id}">${n.libelle}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Situation familiale <span class="required">*</span></label>
                            <select name="situationFamilialeId" class="form-control" required>
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
                            <input type="text" name="profession" class="form-control" placeholder="Profession actuelle">
                        </div>
                    </div>
                </div>

                <!-- SECTION: Coordonnées -->
                <div class="form-section">
                    <div class="form-section-title">📞 Coordonnées</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Téléphone <span class="required">*</span></label>
                            <input type="tel" name="telephone" class="form-control" required placeholder="+261 34 00 000 00">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Email <span class="required">*</span></label>
                            <input type="email" name="email" class="form-control" required placeholder="email@exemple.com">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Adresse <span class="required">*</span></label>
                        <textarea name="adresse" class="form-control" required placeholder="Adresse complète du demandeur" style="min-height: 80px;"></textarea>
                    </div>
                </div>

                <!-- SECTION: Passeport -->
                <div class="form-section">
                    <div class="form-section-title">🛂 Passeport actif</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Numéro de passeport <span class="required">*</span></label>
                            <input type="text" name="numeroPasse" class="form-control" required placeholder="Ex: AB1234567">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Pays de délivrance</label>
                            <input type="text" name="paysDelivrance" class="form-control" placeholder="Ex: France">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Date de délivrance <span class="required">*</span></label>
                            <input type="date" name="dateDelivrancePasse" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Date d'expiration <span class="required">*</span></label>
                            <input type="date" name="dateExpirationPasse" class="form-control" required>
                        </div>
                    </div>
                </div>

                <!-- SECTION: VISA Transformable -->
                <div class="form-section">
                    <div class="form-section-title">🌐 VISA Transformable</div>
                    <div class="alert alert-info mb-2">
                        ℹ️ Requis pour creer la demande initiale et associer les pieces justificatives.
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Numéro de référence du VISA transformable <span class="required">*</span></label>
                            <input type="text" name="numeroReferenceVisa" class="form-control" placeholder="Ex: VT-2024-001234" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Lieu d'entree a l'aeroport <span class="required">*</span></label>
                            <input type="text" name="lieuEntreeVisa" class="form-control" placeholder="Ex: Aeroport international" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Date d'entree <span class="required">*</span></label>
                            <input type="date" name="dateEntreeVisa" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Date d'expiration du VISA transformable <span class="required">*</span></label>
                            <input type="date" name="dateExpirationVisa" class="form-control" required>
                        </div>
                    </div>
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
                <button type="submit" class="btn btn-primary btn-lg">💾 Enregistrer le demandeur</button>
            </div>
        </div>
    </form>

</div>

<script>
function loadPiecesJustificatives() {
    var typeDemandeId = document.getElementById('typeDemandeSelect').value;
    var typeVisaId = document.getElementById('typeVisaSelect').value;
    var container = document.getElementById('piecesContainer');

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
