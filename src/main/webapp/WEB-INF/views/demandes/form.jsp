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

                <!-- SECTION: Type de demande -->
                <div class="form-section">
                    <div class="form-section-title">📋 Type de demande</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Type de demande <span class="required">*</span></label>
                            <select name="typeDemandeId" class="form-control" required>
                                <option value="">-- Sélectionnez --</option>
                                <c:forEach var="type" items="${typesDemande}">
                                    <option value="${type.id}">${type.libelle}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Type de VISA demandé <span class="required">*</span></label>
                            <select name="typeVisaId" class="form-control" required>
                                <option value="">-- Sélectionnez --</option>
                                <c:forEach var="type" items="${typesVisa}">
                                    <option value="${type.id}">${type.libelle} (${type.dureeValidite} mois)</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Profil du demandeur</label>
                            <select name="typeProfilId" class="form-control">
                                <option value="">-- Aucun --</option>
                                <c:forEach var="profil" items="${typesProfil}">
                                    <option value="${profil.id}">${profil.libelle}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
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
                <button type="submit" class="btn btn-primary btn-lg">📤 Créer la demande</button>
            </div>
        </div>
    </form>

</div>

<script>
function loadVisasTransformables() {
    var demandeurId = document.getElementById('demandeurSelect').value;
    var container = document.getElementById('visaTransformableContainer');

    if (!demandeurId) {
        container.innerHTML = '<div class="alert alert-info">ℹ️ Sélectionnez d\'abord un demandeur pour voir ses VISA transformables.</div>';
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
}
</script>

<jsp:include page="../layout/footer.jsp" />
