<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../layout/header.jsp" />

<!-- HEADER BAR -->
<div class="header">
    <div>
        <div class="header-title">Demande #${demande.id}</div>
        <div class="header-subtitle">Détail de la demande de transformation de VISA</div>
    </div>
    <div class="header-actions">
        <a href="${pageContext.request.contextPath}/demandes" class="btn btn-outline">← Retour à la liste</a>
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

    <!-- STATUS + ACTIONS BAR -->
    <div class="action-bar mb-3">
        <div class="action-bar-left">
            <span class="badge ${demande.statutBadgeClass}" style="font-size: 0.9rem; padding: 8px 16px;">
                ${demande.statutLabel}
            </span>
            <c:if test="${demande.sansDonnees}">
                <span class="badge badge-warning" style="font-size: 0.85rem; padding: 6px 14px;">
                    📌 Sans données antérieures
                </span>
            </c:if>
        </div>
        <div class="action-bar-right">
            <c:if test="${demande.statut == 'brouillon'}">
                <form action="${pageContext.request.contextPath}/demandes/${demande.id}/statut" method="post" style="display:inline;">
                    <input type="hidden" name="nouveauStatut" value="soumise">
                    <button type="submit" class="btn btn-primary">📤 Soumettre</button>
                </form>
            </c:if>
            <c:if test="${demande.statut == 'soumise'}">
                <form action="${pageContext.request.contextPath}/demandes/${demande.id}/statut" method="post" style="display:inline;">
                    <input type="hidden" name="nouveauStatut" value="en_cours">
                    <button type="submit" class="btn btn-warning">⏳ Mettre en traitement</button>
                </form>
            </c:if>
            <c:if test="${demande.statut == 'en_cours'}">
                <form action="${pageContext.request.contextPath}/demandes/${demande.id}/statut" method="post" style="display:inline;">
                    <input type="hidden" name="nouveauStatut" value="validee">
                    <button type="submit" class="btn btn-success">✅ Valider</button>
                </form>
                <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">❌ Rejeter</button>
            </c:if>
            <c:if test="${demande.statut == 'soumise'}">
                <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">❌ Rejeter</button>
            </c:if>
        </div>
    </div>

    <div class="detail-grid">

        <!-- INFOS DEMANDE -->
        <div class="card">
            <div class="card-header">
                <h3>📋 Informations de la demande</h3>
            </div>
            <div class="card-body">
                <div class="detail-item">
                    <div class="label">Type de demande</div>
                    <div class="value">${demande.typeDemande.libelle}</div>
                </div>
                <div class="detail-item">
                    <div class="label">Type de VISA demandé</div>
                    <div class="value">${demande.typeVisa.libelle} (${demande.typeVisa.dureeValidite} mois)</div>
                </div>
                <c:if test="${demande.typeProfil != null}">
                    <div class="detail-item">
                        <div class="label">Profil</div>
                        <div class="value">${demande.typeProfil.libelle}</div>
                    </div>
                </c:if>
                <div class="detail-item">
                    <div class="label">Date de demande</div>
                    <div class="value">
                        <fmt:parseDate value="${demande.dateDemande}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy à HH:mm" />
                    </div>
                </div>
                <c:if test="${demande.dateTraitement != null}">
                    <div class="detail-item">
                        <div class="label">Date de traitement</div>
                        <div class="value">
                            <fmt:parseDate value="${demande.dateTraitement}" pattern="yyyy-MM-dd" var="parsedTraitement" type="date" />
                            <fmt:formatDate value="${parsedTraitement}" pattern="dd/MM/yyyy" />
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty demande.observations}">
                    <div class="detail-item">
                        <div class="label">Observations</div>
                        <div class="value">${demande.observations}</div>
                    </div>
                </c:if>
                <c:if test="${not empty demande.motifRejet}">
                    <div class="detail-item">
                        <div class="label">Motif de rejet</div>
                        <div class="value text-danger">${demande.motifRejet}</div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- INFOS DEMANDEUR -->
        <div class="card">
            <div class="card-header">
                <h3>👤 Demandeur</h3>
            </div>
            <div class="card-body">
                <div class="detail-item">
                    <div class="label">Nom complet</div>
                    <div class="value">
                        <a href="${pageContext.request.contextPath}/demandeurs/${demande.demandeur.id}">
                            ${demande.demandeur.nomComplet}
                        </a>
                    </div>
                </div>
                <div class="detail-item">
                    <div class="label">Nationalité</div>
                    <div class="value">${demande.demandeur.nationalite.libelle}</div>
                </div>
                <div class="detail-item">
                    <div class="label">Email</div>
                    <div class="value">${demande.demandeur.email}</div>
                </div>
                <div class="detail-item">
                    <div class="label">Téléphone</div>
                    <div class="value">${demande.demandeur.telephone}</div>
                </div>
            </div>
        </div>

    </div>

    <!-- VISA TRANSFORMABLE -->
    <c:if test="${demande.visaTransformable != null}">
        <div class="card mt-3">
            <div class="card-header">
                <h3>🛂 VISA Transformable</h3>
            </div>
            <div class="card-body">
                <div class="form-row">
                    <div class="detail-item">
                        <div class="label">Référence</div>
                        <div class="value">${demande.visaTransformable.numeroReference}</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Passeport associé</div>
                        <div class="value">${demande.visaTransformable.passeport.numeroPasse}</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Statut du VISA</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${demande.visaTransformable.valide}">
                                    <span class="badge badge-success">Valide</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">Expiré / Invalide</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- HISTORIQUE DES STATUTS -->
    <div class="card mt-3">
        <div class="card-header">
            <h3>📜 Historique des statuts</h3>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty historique}">
                    <p class="text-muted">Aucun historique disponible.</p>
                </c:when>
                <c:otherwise>
                    <div class="timeline">
                        <c:forEach var="h" items="${historique}">
                            <div class="timeline-item">
                                <div class="timeline-date">
                                    <fmt:parseDate value="${h.dateChangementStatut}" pattern="yyyy-MM-dd" var="parsedHistDate" type="date" />
                                    <fmt:formatDate value="${parsedHistDate}" pattern="dd/MM/yyyy" />
                                </div>
                                <div class="timeline-status">${h.statutLabel}</div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</div>

<!-- MODAL REJET -->
<div id="rejectModal" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3>❌ Rejeter la demande</h3>
            <button class="modal-close" onclick="closeModal('rejectModal')">✕</button>
        </div>
        <form action="${pageContext.request.contextPath}/demandes/${demande.id}/statut" method="post">
            <input type="hidden" name="nouveauStatut" value="rejetee">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Motif du rejet <span class="required">*</span></label>
                    <textarea name="motifRejet" class="form-control" required placeholder="Indiquez le motif du rejet de cette demande..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('rejectModal')">Annuler</button>
                <button type="submit" class="btn btn-danger">Confirmer le rejet</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />
