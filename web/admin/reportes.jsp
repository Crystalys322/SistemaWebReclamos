<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%!
    private String escapeHtml(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }

    private String escapeJs(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("\\", "\\\\")
                   .replace("'", "\\'")
                   .replace("\r", "\\r")
                   .replace("\n", "\\n");
    }
%>
<%
    String ctx = request.getContextPath();
    Map<String, Integer> resumenEstado = (Map<String, Integer>) request.getAttribute("resumenEstado");
    Map<String, Integer> resumenCategoria = (Map<String, Integer>) request.getAttribute("resumenCategoria");

    String labelsEstado = "";
    String dataEstado = "";
    if (resumenEstado != null && !resumenEstado.isEmpty()) {
        StringBuilder labels = new StringBuilder();
        StringBuilder data = new StringBuilder();
        int index = 0;
        for (Map.Entry<String, Integer> entry : resumenEstado.entrySet()) {
            if (index++ > 0) {
                labels.append(",");
                data.append(",");
            }
            String key = entry.getKey();
            Integer value = entry.getValue();
            labels.append("'").append(escapeJs(key)).append("'");
            data.append(value != null ? value : 0);
        }
        labelsEstado = labels.toString();
        dataEstado = data.toString();
    }

    String labelsCategoria = "";
    String dataCategoria = "";
    if (resumenCategoria != null && !resumenCategoria.isEmpty()) {
        StringBuilder labels = new StringBuilder();
        StringBuilder data = new StringBuilder();
        int index = 0;
        for (Map.Entry<String, Integer> entry : resumenCategoria.entrySet()) {
            if (index++ > 0) {
                labels.append(",");
                data.append(",");
            }
            String key = entry.getKey();
            Integer value = entry.getValue();
            labels.append("'").append(escapeJs(key)).append("'");
            data.append(value != null ? value : 0);
        }
        labelsCategoria = labels.toString();
        dataCategoria = data.toString();
    }
%>
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
        <a href="<%= ctx %>/VistaAdministrador.jsp" class="btn btn-outline-secondary">Regresar</a>
    </div>
    <div class="row g-4">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">Resumen por estado</div>
                <div class="card-body">
                    <% if (resumenEstado == null || resumenEstado.isEmpty()) { %>
                        <div class="alert alert-info">No hay datos disponibles.</div>
                    <% } else { %>
                        <canvas id="chartEstado" height="220"></canvas>
                        <table class="table table-sm mt-3">
                            <thead><tr><th>Estado</th><th>Total</th></tr></thead>
                            <tbody>
                            <% for (Map.Entry<String, Integer> entry : resumenEstado.entrySet()) { %>
                                <tr>
                                    <td><%= escapeHtml(entry.getKey()) %></td>
                                    <td><%= entry.getValue() != null ? entry.getValue() : 0 %></td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">Resumen por categoría</div>
                <div class="card-body">
                    <% if (resumenCategoria == null || resumenCategoria.isEmpty()) { %>
                        <div class="alert alert-info">No hay datos disponibles.</div>
                    <% } else { %>
                        <canvas id="chartCategoria" height="220"></canvas>
                        <table class="table table-sm mt-3">
                            <thead><tr><th>Categoría</th><th>Total</th></tr></thead>
                            <tbody>
                            <% for (Map.Entry<String, Integer> entry : resumenCategoria.entrySet()) { %>
                                <tr>
                                    <td><%= escapeHtml(entry.getKey()) %></td>
                                    <td><%= entry.getValue() != null ? entry.getValue() : 0 %></td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>
<% if (resumenEstado != null && !resumenEstado.isEmpty()) { %>
<script>
    const labelsEstado = [<%= labelsEstado %>];
    const dataEstado = [<%= dataEstado %>];
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
<% } %>
<% if (resumenCategoria != null && !resumenCategoria.isEmpty()) { %>
<script>
    const labelsCategoria = [<%= labelsCategoria %>];
    const dataCategoria = [<%= dataCategoria %>];
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
                    ticks: {
                        precision: 0
                    }
                }
            }
        }
    });
</script>
<% } %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
