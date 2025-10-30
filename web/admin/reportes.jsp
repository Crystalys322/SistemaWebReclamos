<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reportes de Reclamos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Reportes</h2>
        <a href="${pageContext.request.contextPath}/VistaAdministrador.jsp" class="btn btn-outline-secondary">Regresar</a>
    </div>
    <div class="row g-4">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">Resumen por estado</div>
                <div class="card-body">
                    <c:if test="${empty resumenEstado}">
                        <div class="alert alert-info">No hay datos disponibles.</div>
                    </c:if>
                    <c:if test="${not empty resumenEstado}">
                        <canvas id="chartEstado" height="220"></canvas>
                        <table class="table table-sm mt-3">
                            <thead><tr><th>Estado</th><th>Total</th></tr></thead>
                            <tbody>
                            <c:forEach var="entry" items="${resumenEstado}">
                                <tr>
                                    <td><c:out value="${entry.key}"/></td>
                                    <td><c:out value="${entry.value}"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">Resumen por categoría</div>
                <div class="card-body">
                    <c:if test="${empty resumenCategoria}">
                        <div class="alert alert-info">No hay datos disponibles.</div>
                    </c:if>
                    <c:if test="${not empty resumenCategoria}">
                        <canvas id="chartCategoria" height="220"></canvas>
                        <table class="table table-sm mt-3">
                            <thead><tr><th>Categoría</th><th>Total</th></tr></thead>
                            <tbody>
                            <c:forEach var="entry" items="${resumenCategoria}">
                                <tr>
                                    <td><c:out value="${entry.key}"/></td>
                                    <td><c:out value="${entry.value}"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
<c:if test="${not empty resumenEstado}">
<script>
    const labelsEstado = [<c:forEach var="entry" items="${resumenEstado}" varStatus="loop">'${entry.key}'<c:if test="${!loop.last}">,</c:if></c:forEach>];
    const dataEstado = [<c:forEach var="entry" items="${resumenEstado}" varStatus="loop">${entry.value}<c:if test="${!loop.last}">,</c:if></c:forEach>];
    new Chart(document.getElementById('chartEstado'), {
        type: 'doughnut',
        data: {
            labels: labelsEstado,
            datasets: [{
                data: dataEstado,
                backgroundColor: ['#0d6efd', '#ffc107', '#198754', '#dc3545', '#6f42c1']
            }]
        }
    });
</script>
</c:if>
<c:if test="${not empty resumenCategoria}">
<script>
    const labelsCategoria = [<c:forEach var="entry" items="${resumenCategoria}" varStatus="loop">'${entry.key}'<c:if test="${!loop.last}">,</c:if></c:forEach>];
    const dataCategoria = [<c:forEach var="entry" items="${resumenCategoria}" varStatus="loop">${entry.value}<c:if test="${!loop.last}">,</c:if></c:forEach>];
    new Chart(document.getElementById('chartCategoria'), {
        type: 'bar',
        data: {
            labels: labelsCategoria,
            datasets: [{
                label: 'Reclamos',
                data: dataCategoria,
                backgroundColor: '#0dcaf0'
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    precision: 0
                }
            }
        }
    });
</script>
</c:if>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
