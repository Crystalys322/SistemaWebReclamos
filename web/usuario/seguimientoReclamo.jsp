<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="Modelo_jvl.ClsSeguimiento_jvl" %>
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
%>
<%
    String ctx = request.getContextPath();
    List<ClsSeguimiento_jvl> seguimientos = (List<ClsSeguimiento_jvl>) request.getAttribute("seguimientos");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Seguimiento del reclamo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Seguimiento</h2>
        <a href="<%= ctx %>/reclamos?accion=listar" class="btn btn-outline-secondary">Regresar</a>
    </div>
    <div class="card">
        <div class="card-body">
            <% if (seguimientos == null || seguimientos.isEmpty()) { %>
                <div class="alert alert-info mb-0">Aún no se han registrado seguimientos para este reclamo.</div>
            <% } else { %>
                <div class="timeline">
                    <% for (ClsSeguimiento_jvl seguimiento : seguimientos) {
                           String estado = seguimiento.getNuevoEstado() != null ? seguimiento.getNuevoEstado() : "";
                           String fecha = seguimiento.getFecha() != null ? sdf.format(seguimiento.getFecha()) : "";
                           String observacion = seguimiento.getObservacion();
                    %>
                        <div class="border-start border-3 border-primary ps-3 pb-3 mb-3">
                            <div class="d-flex justify-content-between">
                                <strong>Estado: <%= escapeHtml(estado) %></strong>
                                <small class="text-muted"><%= escapeHtml(fecha) %></small>
                            </div>
                            <p class="mb-1"><%= escapeHtml(observacion) %></p>
                            <span class="badge text-bg-light">Registrado por usuario ID <%= seguimiento.getIdUsuario() %></span>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
