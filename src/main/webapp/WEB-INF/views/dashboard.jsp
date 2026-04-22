<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="layout/header.jsp" />

<!-- HEADER BAR -->
<div class="header">
    <div>
        <div class="header-title">Tableau de bord</div>
        <div class="header-subtitle">Vue d'ensemble des demandes de VISA</div>
    </div>
    <div class="header-actions">
        <a href="${pageContext.request.contextPath}/demandes/nouveau" class="btn btn-primary">
            ➕ Nouvelle demande
        </a>
    </div>
</div>

<div class="page-content">

    <!-- KPI CARDS -->
    <div class="kpi-grid">
        <div class="kpi-card kpi-total">
            <div class="kpi-icon">📋</div>
            <div class="kpi-content">
                <h4>Total demandes</h4>
                <div class="kpi-value">${stats.total}</div>
            </div>
        </div>

        <div class="kpi-card kpi-encours">
            <div class="kpi-icon">⏳</div>
            <div class="kpi-content">
                <h4>En cours</h4>
                <div class="kpi-value">${stats.en_cours + stats.soumise}</div>
            </div>
        </div>

        <div class="kpi-card kpi-validee">
            <div class="kpi-icon">✅</div>
            <div class="kpi-content">
                <h4>Validées</h4>
                <div class="kpi-value">${stats.validee}</div>
            </div>
        </div>

        <div class="kpi-card kpi-rejetee">
            <div class="kpi-icon">❌</div>
            <div class="kpi-content">
                <h4>Rejetées</h4>
                <div class="kpi-value">${stats.rejetee}</div>
            </div>
        </div>

        <div class="kpi-card kpi-demandeurs">
            <div class="kpi-icon">👥</div>
            <div class="kpi-content">
                <h4>Demandeurs</h4>
                <div class="kpi-value">${totalDemandeurs}</div>
            </div>
        </div>
    </div>

    <!-- DERNIÈRES DEMANDES -->
    <div class="card">
        <div class="card-header">
            <h3>📋 Dernières demandes</h3>
            <a href="${pageContext.request.contextPath}/demandes" class="btn btn-outline btn-sm">Voir tout</a>
        </div>
        <div class="card-body" style="padding: 0;">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>N°</th>
                            <th>Demandeur</th>
                            <th>Type demande</th>
                            <th>Type VISA</th>
                            <th>Date</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty dernieresDemandes}">
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state">
                                            <div class="icon">📭</div>
                                            <h4>Aucune demande</h4>
                                            <p>Commencez par créer une nouvelle demande de VISA.</p>
                                            <a href="${pageContext.request.contextPath}/demandes/nouveau" class="btn btn-primary">
                                                ➕ Créer une demande
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="demande" items="${dernieresDemandes}">
                                    <tr>
                                        <td><strong>#${demande.id}</strong></td>
                                        <td>${demande.demandeur.nomComplet}</td>
                                        <td>${demande.typeDemande.libelle}</td>
                                        <td>${demande.typeVisa.libelle}</td>
                                        <td class="text-muted">
                                            <fmt:parseDate value="${demande.dateDemande}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td><span class="badge ${demande.statutBadgeClass}">${demande.statutLabel}</span></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/demandes/${demande.id}" class="btn btn-outline btn-sm">Voir</a>
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

<jsp:include page="layout/footer.jsp" />
