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
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty demandes}">
                                <tr>
                                    <td colspan="9">
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
                                    <tr>
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

<jsp:include page="../layout/footer.jsp" />
