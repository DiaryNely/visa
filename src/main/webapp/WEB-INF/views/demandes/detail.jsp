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
    <script>
        function loadPieces() {
            var demandeId = ${demande.id};
            var url = '${pageContext.request.contextPath}/demandes/' + demandeId + '/pieces';

            console.log('Chargement des pièces depuis:', url);

            fetch(url)
                .then(function(response) {
                    console.log('Réponse reçue:', response.status);
                    return response.json();
                })
                .then(function(pieces) {
                    console.log('Pièces chargées:', pieces);

                    if (!pieces || pieces.length === 0) {
                        document.getElementById('piecesList').innerHTML = '<p class="text-muted">Aucune pièce justificative.</p>';
                        return;
                    }

                    var html = '<table style="width: 100%; border-collapse: collapse;">';
                    html += '<thead><tr style="border-bottom: 1px solid #ddd;">';
                    html += '<th style="text-align: left; padding: 10px;">Pièce</th>';
                    html += '<th style="text-align: left; padding: 10px;">Obligatoire</th>';
                    html += '<th style="text-align: left; padding: 10px;">Statut du scan</th>';
                    html += '<th style="text-align: left; padding: 10px;">Date du scan</th>';
                    html += '<th style="text-align: left; padding: 10px;">Actions</th>';
                    html += '</tr></thead>';
                    html += '<tbody>';

                    var toutScanne = true;
                    for (var i = 0; i < pieces.length; i++) {
                        var p = pieces[i];
                        console.log('Pièce', i, ':', p);

                        var statutClass = 'badge-warning';
                        var statutLabel = p.statutScan === 'SCANNEE' ? 'Scannée' : 'En attente';
                        if (p.statutScan === 'SCANNEE') {
                            statutClass = 'badge-success';
                        } else {
                            toutScanne = false;
                        }

                        html += '<tr style="border-bottom: 1px solid #eee;">';
                        html += '<td style="padding: 10px;">' + (p.piece ? p.piece.libelle : 'N/A') + '</td>';
                        html += '<td style="padding: 10px;">' + (p.piece && p.piece.obligatoire ? 'Oui' : 'Non') + '</td>';
                        html += '<td style="padding: 10px;"><span class="badge ' + statutClass + '">' + statutLabel + '</span></td>';
                        html += '<td style="padding: 10px;">' + (p.dateScan ? p.dateScan : '-') + '</td>';
                        html += '<td style="padding: 10px;">';
                        // Tant que le dossier n'est pas verrouillé, permettre l'upload/modification des PDFs
                        // - Pièces non scannées: toujours modifiables
                        // - Pièces scannées: modifiables pendant le scan, mais pas après "Terminer scan"
                        var dossierVerrouille = ${demande.estVerrouille} === true;
                        var scanTermine = '${demande.statutScan}' === 'SCAN_TERMINE' || '${demande.statutScan}' === 'DOSSIER_VERROUILLE';
                        var pieceNonScannee = p.statutScan !== 'SCANNEE';
                        var peutModifier = !dossierVerrouille && (pieceNonScannee || !scanTermine);

                        if (peutModifier) {
                            html += '<form action="${pageContext.request.contextPath}/demandes/pieces/' + p.id + '/scan-ajax" method="post" enctype="multipart/form-data" style="display:inline;" onsubmit="return submitPieceScan(event, this, ' + p.id + ');">';
                            html += '<input type="file" name="file" accept="application/pdf" style="display:inline; margin-right:6px;">';
                            if (p.statutScan === 'SCANNEE') {
                                html += '<button type="submit" class="btn btn-sm btn-primary">🔄 Rescanner</button>';
                            } else {
                                html += '<button type="submit" class="btn btn-sm btn-primary">📱 Scanner</button>';
                            }
                            html += '</form>';
                            if (p.cheminFichier) {
                                html += ' <a href="' + p.cheminFichier + '" target="_blank" class="btn btn-sm btn-outline">Voir</a>';
                            }
                        } else if (p.statutScan === 'SCANNEE') {
                            html += '<span class="text-muted">✅ Scanné (non modifiable)</span>';
                            if (p.cheminFichier) {
                                html += ' <a href="' + p.cheminFichier + '" target="_blank" class="btn btn-sm btn-outline">Voir</a>';
                            }
                        } else {
                            html += '<span class="text-muted">En attente</span>';
                        }
                        html += '</td>';
                        html += '</tr>';
                    }

                    html += '</tbody>';
                    html += '</table>';
                    document.getElementById('piecesList').innerHTML = html;

                    // Afficher le bouton "Terminer scan" de manière permanente pendant le scan
                    console.log('Tout scanné?', toutScanne);
                    if (pieces.length > 0 && !${demande.estVerrouille}) {
                        document.getElementById('scanActions').style.display = 'block';
                    } else {
                        document.getElementById('scanActions').style.display = 'none';
                    }
                })
                .catch(function(err) {
                    console.error('Erreur:', err);
                    document.getElementById('piecesList').innerHTML = '<p class="alert alert-error">Erreur lors du chargement des pièces: ' + err.message + '</p>';
                });
        }

        function showScanMessage(message, alertClass) {
            var container = document.getElementById('scanMessage');
            container.className = 'alert ' + alertClass;
            container.textContent = message;
            container.style.display = 'block';
        }

        function submitPieceScan(event, form, pieceId) {
            event.preventDefault();

            var fileInput = form.querySelector('input[type="file"]');
            if (!fileInput || !fileInput.files || fileInput.files.length === 0) {
                showScanMessage('Veuillez choisir un fichier PDF avant de scanner la pièce.', 'alert-error');
                return false;
            }

            // Client-side validation: file type and size
            var file = fileInput.files[0];
            var MAX_UPLOAD_SIZE = 10 * 1024 * 1024; // 10MB - keep in sync with server config
            if (file.size > MAX_UPLOAD_SIZE) {
                showScanMessage('Le fichier est trop volumineux (max 10MB).', 'alert-error');
                return false;
            }

            var formData = new FormData(form);
            fetch(form.action, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                }
            })
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Erreur lors de l\'upload du scan');
                }
                return response.json();
            })
            .then(function(data) {
                if (data && data.success) {
                    showScanMessage(data.message || 'Pièce scannée avec succès.', 'alert-success');
                    loadPieces();
                } else {
                    showScanMessage((data && data.message) ? data.message : 'Le scan a échoué.', 'alert-error');
                }
            })
            .catch(function(err) {
                console.error('Erreur upload scan:', err);
                showScanMessage(err.message || 'Erreur lors du scan.', 'alert-error');
            });

            return false;
        }

        // Charger les pièces au chargement de la page
        window.addEventListener('load', loadPieces);
    </script>

    <!-- STATUT DE SCAN -->
    <div class="card mt-3">
        <div class="card-header">
            <h3>📁 Gestion du scan des pièces justificatives</h3>
        </div>
        <div class="card-body">
            <div class="detail-item mb-3">
                <div class="label">Statut du scan</div>
                <div class="value">
                    <c:choose>
                        <c:when test="${empty demande.statutScan}">
                            <span class="badge badge-info">En cours de scan</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge ${demande.statutScanBadgeClass}" style="font-size: 0.9rem; padding: 8px 16px;">
                                ${demande.statutScanLabel}
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <c:if test="${demande.estVerrouille == true}">
                <div class="alert alert-info">
                    🔒 Le dossier est verrouillé depuis le ${demande.dateScanTermine}. Aucune modification n'est possible.
                </div>
                <div class="mt-3">
                    <form action="${pageContext.request.contextPath}/demandes/${demande.id}/deverrouiller" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-warning">🔓 Déverrouiller le dossier (ADMIN)</button>
                    </form>
                </div>
            </c:if>
            <c:if test="${demande.estVerrouille != true}">
                <div id="scanMessage" class="mb-2"></div>
                <div id="piecesContainer" class="mt-3">
                    <h4>Pièces justificatives</h4>
                    <div id="piecesList" class="checklist-box">
                        <p class="text-muted">Chargement des pièces...</p>
                    </div>
                </div>
                <div id="scanActions" class="mt-3" style="display: none;">
                    <form action="${pageContext.request.contextPath}/demandes/${demande.id}/scan-termine" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-success btn-lg">✅ Scan terminé - Verrouiller le dossier</button>
                    </form>
                </div>
            </c:if>
        </div>
    </div>

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

<script>
    function loadPieces() {
        var demandeId = ${demande.id};
        var url = '${pageContext.request.contextPath}/demandes/' + demandeId + '/pieces';
        
        console.log('Chargement des pièces depuis:', url);
        
        fetch(url)
            .then(function(response) { 
                console.log('Réponse reçue:', response.status);
                return response.json(); 
            })
            .then(function(pieces) {
                console.log('Pièces chargées:', pieces);
                
                if (!pieces || pieces.length === 0) {
                    document.getElementById('piecesList').innerHTML = '<p class="text-muted">Aucune pièce justificative.</p>';
                    return;
                }

                var html = '<table style="width: 100%; border-collapse: collapse;">';
                html += '<thead><tr style="border-bottom: 1px solid #ddd;">';
                html += '<th style="text-align: left; padding: 10px;">Pièce</th>';
                html += '<th style="text-align: left; padding: 10px;">Obligatoire</th>';
                html += '<th style="text-align: left; padding: 10px;">Statut du scan</th>';
            // Client-side validation: file type and size
            var file = fileInput.files[0];
            var MAX_UPLOAD_SIZE = 10 * 1024 * 1024; // 10MB - keep in sync with server config
            if (file.size > MAX_UPLOAD_SIZE) {
                showScanMessage('Le fichier est trop volumineux (max 10MB).', 'alert-error');
                return false;
            }

            var formData = new FormData(form);

            fetch(form.action, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                }
            })
                    html += '<td style="padding: 10px;">' + (p.piece ? p.piece.libelle : 'N/A') + '</td>';
                    html += '<td style="padding: 10px;">' + (p.piece && p.piece.obligatoire ? 'Oui' : 'Non') + '</td>';
                    html += '<td style="padding: 10px;"><span class="badge ' + statutClass + '">' + statutLabel + '</span></td>';
                    html += '<td style="padding: 10px;">' + (p.dateScan ? p.dateScan : '-') + '</td>';
                    html += '<td style="padding: 10px;">';
                    // Tant que le dossier n'est pas verrouillé, permettre l'upload/modification des PDFs
                    // - Pièces non scannées: toujours modifiables
                    // - Pièces scannées: modifiables pendant le scan, mais pas après "Terminer scan"
                    var dossierVerrouille = ${demande.estVerrouille} === true;
                    var scanTermine = '${demande.statutScan}' === 'SCAN_TERMINE' || '${demande.statutScan}' === 'DOSSIER_VERROUILLE';
                    var pieceNonScannee = p.statutScan !== 'SCANNEE';
                    var peutModifier = !dossierVerrouille && (pieceNonScannee || !scanTermine);
                    
                    if (peutModifier) {
                        html += '<form action="${pageContext.request.contextPath}/demandes/pieces/' + p.id + '/scan-ajax" method="post" enctype="multipart/form-data" style="display:inline;" onsubmit="return submitPieceScan(event, this, ' + p.id + ');">';
                        html += '<input type="file" name="file" accept="application/pdf" style="display:inline; margin-right:6px;">';
                        if (p.statutScan === 'SCANNEE') {
                            html += '<button type="submit" class="btn btn-sm btn-primary">🔄 Rescanner</button>';
                        } else {
                            html += '<button type="submit" class="btn btn-sm btn-primary">📱 Scanner</button>';
                        }
                        html += '</form>';
                        if (p.cheminFichier) {
                            html += ' <a href="' + p.cheminFichier + '" target="_blank" class="btn btn-sm btn-outline">Voir</a>';
                        }
                    } else if (p.statutScan === 'SCANNEE') {
                        html += '<span class="text-muted">✅ Scanné (non modifiable)</span>';
                        if (p.cheminFichier) {
                            html += ' <a href="' + p.cheminFichier + '" target="_blank" class="btn btn-sm btn-outline">Voir</a>';
                        }
                    } else {
                        html += '<span class="text-muted">En attente</span>';
                    }
                    html += '</td>';
                    html += '</tr>';
                }

                html += '</tbody>';
                html += '</table>';
                document.getElementById('piecesList').innerHTML = html;

                // Afficher le bouton "Terminer scan" de manière permanente pendant le scan
                console.log('Tout scanné?', toutScanne);
                if (pieces.length > 0 && !${demande.estVerrouille}) {
                    document.getElementById('scanActions').style.display = 'block';
                } else {
                    document.getElementById('scanActions').style.display = 'none';
                }
            })
            .catch(function(err) {
                console.error('Erreur:', err);
                document.getElementById('piecesList').innerHTML = '<p class="alert alert-error">Erreur lors du chargement des pièces: ' + err.message + '</p>';
            });
    }

    function showScanMessage(message, alertClass) {
        var container = document.getElementById('scanMessage');
        container.className = 'alert ' + alertClass;
        container.textContent = message;
        container.style.display = 'block';
    }

    function submitPieceScan(event, form, pieceId) {
        event.preventDefault();

        var fileInput = form.querySelector('input[type="file"]');
        if (!fileInput || !fileInput.files || fileInput.files.length === 0) {
            showScanMessage('Veuillez choisir un fichier PDF avant de scanner la pièce.', 'alert-error');
            return false;
        }

        var formData = new FormData(form);
        fetch(form.action, {
            method: 'POST',
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Accept': 'application/json'
            }
        })
        .then(function(response) {
            if (!response.ok) {
                throw new Error('Erreur lors de l\'upload du scan');
            }
            return response.json();
        })
        .then(function(data) {
            if (data && data.success) {
                showScanMessage(data.message || 'Pièce scannée avec succès.', 'alert-success');
                loadPieces();
            } else {
                showScanMessage((data && data.message) ? data.message : 'Le scan a échoué.', 'alert-error');
            }
        })
        .catch(function(err) {
            console.error('Erreur upload scan:', err);
            showScanMessage(err.message || 'Erreur lors du scan.', 'alert-error');
        });

        return false;
    }

    // Charger les pièces au chargement de la page
    window.addEventListener('load', loadPieces);
</script>

<jsp:include page="../layout/footer.jsp" />
