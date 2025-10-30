<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="Modelo_jvl.ClsReclamo_jvl" %>
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
    List<ClsReclamo_jvl> reclamos = (List<ClsReclamo_jvl>) request.getAttribute("reclamos");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis reclamos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Mis reclamos</h2>
        <div>
            <a href="<%= ctx %>/VistaUsuario.jsp" class="btn btn-outline-secondary">Inicio</a>
            <a href="<%= ctx %>/reclamos?accion=formulario" class="btn btn-primary">Nuevo reclamo</a>
        </div>
    </div>
    <% if (reclamos == null || reclamos.isEmpty()) { %>
        <div class="alert alert-info">Todavía no has registrado reclamos.</div>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle">
                <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Categoría</th>
                    <th>Descripción</th>
                    <th>Fecha</th>
                    <th>Estado</th>
                    <th>Seguimiento</th>
                </tr>
                </thead>
                <tbody>
                <% for (ClsReclamo_jvl reclamo : reclamos) {
                       String fecha = reclamo.getFechaRegistro() != null ? sdf.format(reclamo.getFechaRegistro()) : "-";
                       String estado = reclamo.getEstado() != null ? reclamo.getEstado() : "";
                %>
                    <tr>
                        <td><%= reclamo.getIdReclamo() %></td>
                        <td><%= reclamo.getIdCategoria() %></td>
                        <td style="max-width: 260px;"><%= escapeHtml(reclamo.getDescripcion()) %></td>
                        <td><%= fecha %></td>
                        <td><span class="badge text-bg-secondary"><%= escapeHtml(estado) %></span></td>
                        <td>
                            <a class="btn btn-sm btn-outline-primary" href="<%= ctx %>/reclamos?accion=seguimiento&idReclamo=<%= reclamo.getIdReclamo() %>">Ver seguimiento</a>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
