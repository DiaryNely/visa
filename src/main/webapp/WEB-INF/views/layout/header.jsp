<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VISA Management - Ministère de l'Intérieur</title>
    <meta name="description" content="Système de gestion des demandes de VISA transformable - Ministère de l'Intérieur">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css?v=20260423a">
</head>
<body>
<div class="admin-wrapper">
    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="sidebar-brand-icon">🏛</div>
            <div>
                <h2>VISA Manager</h2>
                <small>Ministère de l'Intérieur</small>
            </div>
        </div>

        <nav class="sidebar-nav">
            <div class="sidebar-section">
                <div class="sidebar-section-title">Principal</div>
                <a href="${pageContext.request.contextPath}/" class="sidebar-link ${activePage == 'dashboard' ? 'active' : ''}">
                    <span class="icon">📊</span>
                    <span>Tableau de bord</span>
                </a>
            </div>

            <div class="sidebar-section">
                <div class="sidebar-section-title">Gestion</div>
                <a href="${pageContext.request.contextPath}/demandes" class="sidebar-link ${activePage == 'demandes' ? 'active' : ''}">
                    <span class="icon">📋</span>
                    <span>Demandes</span>
                </a>
                <a href="${pageContext.request.contextPath}/demandeurs" class="sidebar-link ${activePage == 'demandeurs' ? 'active' : ''}">
                    <span class="icon">👥</span>
                    <span>Demandeurs</span>
                </a>
            </div>

            <div class="sidebar-section">
                <div class="sidebar-section-title">Actions rapides</div>
                <a href="${pageContext.request.contextPath}/demandes/nouveau" class="sidebar-link">
                    <span class="icon">➕</span>
                    <span>Nouvelle demande</span>
                </a>
                <a href="${pageContext.request.contextPath}/demandeurs/nouveau" class="sidebar-link">
                    <span class="icon">🆕</span>
                    <span>Nouveau demandeur</span>
                </a>
            </div>
        </nav>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content">
