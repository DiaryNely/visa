<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../layout/header.jsp" />

<!-- HEADER BAR -->
<div class="header">
    <div>
        <div class="header-title">${demandeur.nomComplet}</div>
        <div class="header-subtitle">Fiche du demandeur #${demandeur.id}</div>
    </div>
    <div class="header-actions">
        <a href="${pageContext.request.contextPath}/demandeurs" class="btn btn-outline">← Retour à la liste</a>
        <a href="${pageContext.request.contextPath}/demandes/nouveau" class="btn btn-primary">➕ Nouvelle demande</a>
    </div>
</div>

<div class="page-content">

    <!-- ALERTS -->
    <c:if test="${not empty success}">
        <div class="alert alert-success">✅ ${success}</div>
    </c:if>

    <div class="detail-grid">

        <!-- ÉTAT CIVIL -->
        <div class="card">
            <div class="card-header">
                <h3>👤 État civil</h3>
            </div>
            <div class="card-body">
                <div class="detail-item">
                    <div class="label">Nom complet</div>
                    <div class="value fw-600">${demandeur.nomComplet}</div>
                </div>
                <c:if test="${not empty demandeur.nomJeuneFille}">
                    <div class="detail-item">
                        <div class="label">Nom de jeune fille</div>
                        <div class="value">${demandeur.nomJeuneFille}</div>
                    </div>
                </c:if>
                <c:if test="${not empty demandeur.nomPere}">
                    <div class="detail-item">
                        <div class="label">Nom du père</div>
                        <div class="value">${demandeur.nomPere}</div>
                    </div>
                </c:if>
                <div class="detail-item">
                    <div class="label">Date de naissance</div>
                    <div class="value">
                        <fmt:parseDate value="${demandeur.dateNaissance}" pattern="yyyy-MM-dd" var="parsedDob" type="date" />
                        <fmt:formatDate value="${parsedDob}" pattern="dd/MM/yyyy" />
                    </div>
                </div>
                <div class="detail-item">
                    <div class="label">Lieu de naissance</div>
                    <div class="value">${demandeur.lieuNaissance}</div>
                </div>
                <div class="detail-item">
                    <div class="label">Nationalité</div>
                    <div class="value">${demandeur.nationalite.libelle}</div>
                </div>
                <div class="detail-item">
                    <div class="label">Situation familiale</div>
                    <div class="value">${demandeur.situationFamiliale.libelle}</div>
                </div>
                <c:if test="${not empty demandeur.profession}">
                    <div class="detail-item">
                        <div class="label">Profession</div>
                        <div class="value">${demandeur.profession}</div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- COORDONNÉES -->
        <div class="card">
            <div class="card-header">
                <h3>📞 Coordonnées</h3>
            </div>
            <div class="card-body">
                <div class="detail-item">
                    <div class="label">Email</div>
                    <div class="value">${demandeur.email}</div>
                </div>
                <div class="detail-item">
                    <div class="label">Téléphone</div>
                    <div class="value">${demandeur.telephone}</div>
                </div>
                <div class="detail-item">
                    <div class="label">Adresse</div>
                    <div class="value">${demandeur.adresse}</div>
                </div>
            </div>
        </div>

    </div>

    <!-- PASSEPORTS -->
    <div class="card mt-3">
        <div class="card-header">
            <h3>🛂 Passeports</h3>
        </div>
        <div class="card-body" style="padding: 0;">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Numéro</th>
                            <th>Pays</th>
                            <th>Date délivrance</th>
                            <th>Date expiration</th>
                            <th>Statut</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty passeports}">
                                <tr><td colspan="5" class="text-muted" style="text-align:center; padding:24px;">Aucun passeport enregistré</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="p" items="${passeports}">
                                    <tr>
                                        <td><strong>${p.numeroPasse}</strong></td>
                                        <td>${p.paysDelivrance}</td>
                                        <td>
                                            <fmt:parseDate value="${p.dateDelivrance}" pattern="yyyy-MM-dd" var="pDeliv" type="date" />
                                            <fmt:formatDate value="${pDeliv}" pattern="dd/MM/yyyy" />
                                        </td>
                                        <td>
                                            <fmt:parseDate value="${p.dateExpiration}" pattern="yyyy-MM-dd" var="pExp" type="date" />
                                            <fmt:formatDate value="${pExp}" pattern="dd/MM/yyyy" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.valide}">
                                                    <span class="badge badge-success">Actif & Valide</span>
                                                </c:when>
                                                <c:when test="${p.estActif}">
                                                    <span class="badge badge-danger">Actif mais Expiré</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-secondary">Inactif</span>
                                                </c:otherwise>
                                            </c:choose>
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

    <!-- VISA TRANSFORMABLES -->
    <div class="card mt-3">
        <div class="card-header">
            <h3>🌐 VISA Transformables</h3>
        </div>
        <div class="card-body" style="padding: 0;">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Référence</th>
                            <th>Passeport associé</th>
                            <th>Statut</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty visasTransformables}">
                                <tr><td colspan="3" class="text-muted" style="text-align:center; padding:24px;">Aucun VISA transformable enregistré</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="vt" items="${visasTransformables}">
                                    <tr>
                                        <td><strong>${vt.numeroReference}</strong></td>
                                        <td>${vt.passeport.numeroPasse}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${vt.valide}">
                                                    <span class="badge badge-success">Valide</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">Invalide</span>
                                                </c:otherwise>
                                            </c:choose>
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

    <!-- DEMANDES DU DEMANDEUR -->
    <div class="card mt-3">
        <div class="card-header">
            <h3>📋 Demandes associées</h3>
        </div>
        <div class="card-body" style="padding: 0;">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>N°</th>
                            <th>Type demande</th>
                            <th>Type VISA</th>
                            <th>Date</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty demandes}">
                                <tr><td colspan="6" class="text-muted" style="text-align:center; padding:24px;">Aucune demande pour ce demandeur</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="dem" items="${demandes}">
                                    <tr>
                                        <td><strong>#${dem.id}</strong></td>
                                        <td>${dem.typeDemande.libelle}</td>
                                        <td>${dem.typeVisa.libelle}</td>
                                        <td class="text-muted">
                                            <fmt:parseDate value="${dem.dateDemande}" pattern="yyyy-MM-dd'T'HH:mm" var="demDate" type="both" />
                                            <fmt:formatDate value="${demDate}" pattern="dd/MM/yyyy" />
                                        </td>
                                        <td><span class="badge ${dem.statutBadgeClass}">${dem.statutLabel}</span></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/demandes/${dem.id}" class="btn btn-outline btn-sm">Voir</a>
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
