<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo_jvl.ClsCategoria_jvl" %>
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
    List<ClsCategoria_jvl> categorias = (List<ClsCategoria_jvl>) request.getAttribute("categorias");
    String mensajeError = (String) request.getAttribute("mensajeError");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registrar reclamo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Nuevo reclamo</h2>
        <a href="<%= ctx %>/reclamos?accion=listar" class="btn btn-outline-secondary">Regresar</a>
    </div>
    <div class="card">
        <div class="card-body">
            <% if (mensajeError != null && !mensajeError.isEmpty()) { %>
                <div class="alert alert-danger"><%= escapeHtml(mensajeError) %></div>
            <% } %>
            <form method="post" action="<%= ctx %>/reclamos">
                <input type="hidden" name="accion" value="registrar"/>
                <div class="mb-3">
                    <label for="idCategoria" class="form-label">Categoría</label>
                    <select class="form-select" id="idCategoria" name="idCategoria" required>
                        <option value="" disabled selected>Seleccione una categoría</option>
                        <% if (categorias != null) { %>
                            <% for (ClsCategoria_jvl categoria : categorias) { %>
                                <option value="<%= categoria.getIdCategoria() %>"><%= escapeHtml(categoria.getNombreCategoria()) %></option>
                            <% } %>
                        <% } %>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="descripcion" class="form-label">Descripción del reclamo</label>
                    <textarea class="form-control" id="descripcion" name="descripcion" rows="5" required></textarea>
                </div>
                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary">Guardar reclamo</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
