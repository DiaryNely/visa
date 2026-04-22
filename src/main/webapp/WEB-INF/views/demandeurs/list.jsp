<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../layout/header.jsp" />

<!-- HEADER BAR -->
<div class="header">
    <div>
        <div class="header-title">Demandeurs</div>
        <div class="header-subtitle">Liste des demandeurs de VISA</div>
    </div>
    <div class="header-actions">
        <a href="${pageContext.request.contextPath}/demandeurs/nouveau" class="btn btn-primary">
            ➕ Nouveau demandeur
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

    <!-- SEARCH BAR -->
    <div class="action-bar">
        <form action="${pageContext.request.contextPath}/demandeurs" method="get" class="search-bar">
            <span class="search-icon">🔍</span>
            <input type="text" name="search" value="${search}" placeholder="Rechercher par nom ou prénom..." />
        </form>
        <c:if test="${not empty search}">
            <a href="${pageContext.request.contextPath}/demandeurs" class="btn btn-outline btn-sm">✕ Effacer la recherche</a>
        </c:if>
    </div>

    <!-- TABLE -->
    <div class="card">
        <div class="card-body" style="padding: 0;">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nom complet</th>
                            <th>Nationalité</th>
                            <th>Email</th>
                            <th>Téléphone</th>
                            <th>Situation familiale</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty demandeurs}">
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state">
                                            <div class="icon">👥</div>
                                            <h4>Aucun demandeur trouvé</h4>
                                            <p>
                                                <c:choose>
                                                    <c:when test="${not empty search}">Aucun résultat pour "${search}".</c:when>
                                                    <c:otherwise>Commencez par enregistrer un demandeur.</c:otherwise>
                                                </c:choose>
                                            </p>
                                            <a href="${pageContext.request.contextPath}/demandeurs/nouveau" class="btn btn-primary">
                                                ➕ Nouveau demandeur
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="d" items="${demandeurs}">
                                    <tr>
                                        <td><strong>#${d.id}</strong></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/demandeurs/${d.id}" class="fw-500">
                                                ${d.nomComplet}
                                            </a>
                                        </td>
                                        <td>${d.nationalite.libelle}</td>
                                        <td class="text-muted">${d.email}</td>
                                        <td class="text-muted">${d.telephone}</td>
                                        <td>${d.situationFamiliale.libelle}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/demandeurs/${d.id}" class="btn btn-outline btn-sm">Voir</a>
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
