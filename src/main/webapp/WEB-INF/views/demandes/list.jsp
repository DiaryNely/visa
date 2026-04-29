<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../layout/header.jsp" />

<!-- HEADER BAR -->
<div class="header">
    <div>
        <div class="header-title">Demandes de VISA</div>
        <div class="header-subtitle">Liste de toutes les demandes de transformation</div>
    </div>
    <div class="header-actions">
        <a href="${pageContext.request.contextPath}/demandes/nouveau" class="btn btn-primary">
            ➕ Nouvelle demande
        </a>
    </div>
</div>

<div class="page-content">

    <!-- ALERTS -->
    <c:if test="${not empty success}">
        <div class="alert alert-success">✅ ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">❌ ${error}</div>
    </c:if>

    <!-- FILTER BAR -->
    <div class="action-bar">
        <div class="filter-bar">
            <a href="${pageContext.request.contextPath}/demandes" class="filter-chip ${empty filtreStatut ? 'active' : ''}">Toutes</a>
            <a href="${pageContext.request.contextPath}/demandes?statut=brouillon" class="filter-chip ${filtreStatut == 'brouillon' ? 'active' : ''}">📝 Brouillon</a>
            <a href="${pageContext.request.contextPath}/demandes?statut=soumise" class="filter-chip ${filtreStatut == 'soumise' ? 'active' : ''}">📤 Soumise</a>
            <a href="${pageContext.request.contextPath}/demandes?statut=en_cours" class="filter-chip ${filtreStatut == 'en_cours' ? 'active' : ''}">⏳ En cours</a>
            <a href="${pageContext.request.contextPath}/demandes?statut=validee" class="filter-chip ${filtreStatut == 'validee' ? 'active' : ''}">✅ Validée</a>
            <a href="${pageContext.request.contextPath}/demandes?statut=rejetee" class="filter-chip ${filtreStatut == 'rejetee' ? 'active' : ''}">❌ Rejetée</a>
        </div>
    </div>

    <!-- TABLE -->
    <div class="card">
        <div class="card-body" style="padding: 0;">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>N°</th>
                            <th>Demandeur</th>
                            <th>Type demande</th>
                            <th>Type VISA</th>
                            <th>Profil</th>
                            <th>Date demande</th>
                            <th>Date traitement</th>
                            <th>Statut</th>
                            <th>QR code</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty demandes}">
                                <tr>
                                    <td colspan="10">
                                        <div class="empty-state">
                                            <div class="icon">📭</div>
                                            <h4>Aucune demande trouvée</h4>
                                            <p>Aucune demande ne correspond aux critères sélectionnés.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="demande" items="${demandes}">
                                    <tr class="${createdId != null && createdId == demande.id ? 'row-created' : ''}">
                                        <td><strong>#${demande.id}</strong></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/demandeurs/${demande.demandeur.id}">
                                                ${demande.demandeur.nomComplet}
                                            </a>
                                        </td>
                                        <td>${demande.typeDemande.libelle}</td>
                                        <td>${demande.typeVisa.libelle}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${demande.typeProfil != null}">${demande.typeProfil.libelle}</c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-muted">
                                            <fmt:parseDate value="${demande.dateDemande}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                                        </td>
                                        <td class="text-muted">
                                            <c:choose>
                                                <c:when test="${demande.dateTraitement != null}">
                                                    <fmt:parseDate value="${demande.dateTraitement}" pattern="yyyy-MM-dd" var="parsedTraitement" type="date" />
                                                    <fmt:formatDate value="${parsedTraitement}" pattern="dd/MM/yyyy" />
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><span class="badge ${demande.statutBadgeClass}">${demande.statutLabel}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty demande.qrCodeImageBase64}">
                                                    <div class="qr-cell">
                                                        <img
                                                            class="qr-thumb"
                                                            src="data:image/png;base64,${demande.qrCodeImageBase64}"
                                                            alt="QR code demande #${demande.id}" />
                                                        <button
                                                            type="button"
                                                            class="btn btn-outline btn-sm qr-open-btn"
                                                            data-qr-src="data:image/png;base64,${demande.qrCodeImageBase64}"
                                                            data-qr-url="${demande.qrCodeUrl}">
                                                            Agrandir
                                                        </button>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">—</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/demandes/${demande.id}" class="btn btn-outline btn-sm">Détail</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>

<div id="qrModal" class="modal-overlay">
    <div class="modal" style="max-width: 520px;">
        <div class="modal-header">
            <h3>QR code de la demande</h3>
            <button class="modal-close" onclick="closeModal('qrModal')">✕</button>
        </div>
        <div class="modal-body" style="text-align: center;">
            <img id="qrModalImage" src="" alt="QR code" style="max-width: 100%; width: 360px; height: auto; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px; background: #fff;" />
            <div style="margin-top: 12px;">
                <a id="qrModalUrl" href="#" target="_blank" class="btn btn-primary">Ouvrir la page Vue</a>
            </div>
        </div>
    </div>
</div>

<style>
.qr-cell {
    display: flex;
    align-items: center;
    gap: 8px;
}

.qr-thumb {
    width: 48px;
    height: 48px;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    background: #fff;
    padding: 4px;
}

.row-created {
    background: #eff6ff;
    animation: pulseCreated 1.2s ease-in-out 2;
}

@keyframes pulseCreated {
    0% { background: #dbeafe; }
    100% { background: #eff6ff; }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const qrButtons = document.querySelectorAll('.qr-open-btn');
    const qrModalImage = document.getElementById('qrModalImage');
    const qrModalUrl = document.getElementById('qrModalUrl');

    qrButtons.forEach(function(button) {
        button.addEventListener('click', function() {
            qrModalImage.src = button.dataset.qrSrc;
            qrModalUrl.href = button.dataset.qrUrl || '#';
            openModal('qrModal');
        });
    });
});
</script>

<jsp:include page="../layout/footer.jsp" />
