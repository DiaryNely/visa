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
                    <div class="form-section-title">🌐 VISA Transformable (optionnel)</div>
                    <div class="alert alert-info mb-2">
                        ℹ️ Si le demandeur possède un VISA transformable obtenu à l'étranger, renseignez sa référence ci-dessous.
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Numéro de référence du VISA transformable</label>
                            <input type="text" name="numeroReferenceVisa" class="form-control" placeholder="Ex: VT-2024-001234">
                        </div>
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

<jsp:include page="../layout/footer.jsp" />
