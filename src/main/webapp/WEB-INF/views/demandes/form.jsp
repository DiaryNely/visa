<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../layout/header.jsp" />

<!-- HEADER BAR -->
<div class="header">
    <div>
        <div class="header-title">Nouvelle demande de VISA</div>
        <div class="header-subtitle">Créer une demande de transformation de VISA</div>
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

    <form action="${pageContext.request.contextPath}/demandes/nouveau" method="post">
        <div class="card">
            <div class="card-body">

                <!-- SECTION: Demandeur -->
                <div class="form-section">
                    <div class="form-section-title">👤 Sélection du demandeur</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Demandeur <span class="required">*</span></label>
                            <select name="demandeurId" id="demandeurSelect" class="form-control" required onchange="loadVisasTransformables()">
                                <option value="">-- Sélectionnez un demandeur --</option>
                                <c:forEach var="demandeur" items="${demandeurs}">
                                    <option value="${demandeur.id}">${demandeur.nomComplet} — ${demandeur.email}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="mt-1">
                        <a href="${pageContext.request.contextPath}/demandeurs/nouveau" class="text-sm">
                            ➕ Créer un nouveau demandeur
                        </a>
                    </div>
                </div>

                <!-- INFO: Types recuperes depuis le demandeur -->
                <div class="form-section">
                    <div class="form-section-title">📋 Informations de type</div>
                    <div class="readonly-panel">
                        <div id="typeInfosHint" class="readonly-hint">
                            Selectionnez un demandeur pour recuperer automatiquement le type de demande, le type de VISA et le profil.
                        </div>

                        <div class="form-row mt-1">
                            <div class="form-group">
                                <label class="form-label">Type de demande</label>
                                <input type="text" id="typeDemandeLibelleView" class="form-control readonly-field" readonly value="-">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Type de VISA</label>
                                <input type="text" id="typeVisaLibelleView" class="form-control readonly-field" readonly value="-">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Profil</label>
                                <input type="text" id="typeProfilLibelleView" class="form-control readonly-field" readonly value="-">
                            </div>
                        </div>
                    </div>
                    <input type="hidden" name="typeDemandeId" id="typeDemandeIdHidden">
                    <input type="hidden" name="typeVisaId" id="typeVisaIdHidden">
                    <input type="hidden" name="typeProfilId" id="typeProfilIdHidden">
                </div>

                <!-- SECTION: VISA Transformable -->
                <div class="form-section">
                    <div class="form-section-title">🛂 VISA Transformable</div>
                    <div id="visaTransformableContainer">
                        <div class="alert alert-info">
                            ℹ️ Sélectionnez d'abord un demandeur pour voir ses VISA transformables.
                        </div>
                    </div>
                </div>

                <!-- SECTION: Observations -->
                <div class="form-section">
                    <div class="form-section-title">📝 Observations</div>
                    <div class="form-group">
                        <label class="form-label">Observations / Notes</label>
                        <textarea name="observations" class="form-control" placeholder="Observations supplémentaires concernant cette demande..."></textarea>
                    </div>
                </div>

            </div>

            <div class="card-footer" style="display: flex; justify-content: flex-end; gap: 12px;">
                <a href="${pageContext.request.contextPath}/demandes" class="btn btn-outline">Annuler</a>
                <button type="submit" id="submitDemandeBtn" class="btn btn-primary btn-lg" disabled>📤 Créer la demande</button>
            </div>
        </div>
    </form>

</div>

<script>
function loadVisasTransformables() {
    var demandeurId = document.getElementById('demandeurSelect').value;
    var container = document.getElementById('visaTransformableContainer');
    var typeInfosHint = document.getElementById('typeInfosHint');
    var submitBtn = document.getElementById('submitDemandeBtn');

    resetTypeFields();
    submitBtn.disabled = true;

    if (!demandeurId) {
        container.innerHTML = '<div class="alert alert-info">ℹ️ Sélectionnez d\'abord un demandeur pour voir ses VISA transformables.</div>';
        typeInfosHint.textContent = 'Selectionnez un demandeur pour recuperer automatiquement le type de demande, le type de VISA et le profil.';
        return;
    }

    fetch('${pageContext.request.contextPath}/demandes/visas-transformables?demandeurId=' + demandeurId)
        .then(function(response) { return response.json(); })
        .then(function(visas) {
            if (visas.length === 0) {
                container.innerHTML = '<div class="alert alert-warning">⚠️ Aucun VISA transformable trouvé pour ce demandeur. <a href="${pageContext.request.contextPath}/demandeurs/' + demandeurId + '">Ajouter un VISA transformable</a></div>';
            } else {
                var html = '<div class="form-group"><label class="form-label">VISA Transformable <span class="required">*</span></label>';
                html += '<select name="visaTransformableId" class="form-control" required>';
                html += '<option value="">-- Sélectionnez --</option>';
                for (var i = 0; i < visas.length; i++) {
                    var v = visas[i];
                    var valid = v.valide;
                    var label = 'Réf: ' + v.numeroReference + ' — Passeport: ' + v.passeport.numeroPasse;
                    if (!valid) {
                        label += ' (EXPIRÉ)';
                    }
                    html += '<option value="' + v.id + '"' + (!valid ? ' disabled' : '') + '>' + label + '</option>';
                }
                html += '</select></div>';
                if (visas.some(function(v) { return !v.valide; })) {
                    html += '<div class="alert alert-warning mt-1">⚠️ Les VISA transformables dont le passeport est expiré ne peuvent pas être utilisés.</div>';
                }
                container.innerHTML = html;
            }
        })
        .catch(function(err) {
            container.innerHTML = '<div class="alert alert-error">❌ Erreur lors du chargement des VISA transformables.</div>';
        });

    fetch('${pageContext.request.contextPath}/demandes/type-infos?demandeurId=' + demandeurId)
        .then(function(response) { return response.json(); })
        .then(function(payload) {
            if (!payload.found) {
                typeInfosHint.textContent = 'Aucune information de type trouvee pour ce demandeur. Creez d\'abord une demande depuis la creation du demandeur.';
                return;
            }

            document.getElementById('typeDemandeIdHidden').value = payload.typeDemandeId;
            document.getElementById('typeVisaIdHidden').value = payload.typeVisaId;
            document.getElementById('typeProfilIdHidden').value = payload.typeProfilId == null ? '' : payload.typeProfilId;
            document.getElementById('typeDemandeLibelleView').value = payload.typeDemandeLibelle;
            document.getElementById('typeVisaLibelleView').value = payload.typeVisaLibelle;
            document.getElementById('typeProfilLibelleView').value = payload.typeProfilLibelle;

            typeInfosHint.textContent = 'Informations recuperees automatiquement depuis ce demandeur.';

            submitBtn.disabled = false;
        })
        .catch(function() {
            typeInfosHint.textContent = 'Erreur lors de la recuperation des informations de type.';
        });
}

function resetTypeFields() {
    document.getElementById('typeDemandeIdHidden').value = '';
    document.getElementById('typeVisaIdHidden').value = '';
    document.getElementById('typeProfilIdHidden').value = '';
    document.getElementById('typeDemandeLibelleView').value = '-';
    document.getElementById('typeVisaLibelleView').value = '-';
    document.getElementById('typeProfilLibelleView').value = '-';
}
</script>

<jsp:include page="../layout/footer.jsp" />
