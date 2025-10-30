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
    <title>Panel de Reclamos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Gestión de reclamos</h2>
        <div>
            <a href="<%= ctx %>/VistaAdministrador.jsp" class="btn btn-outline-secondary">Regresar</a>
        </div>
    </div>
    <% if (reclamos == null || reclamos.isEmpty()) { %>
        <div class="alert alert-info">No existen reclamos registrados.</div>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle">
                <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>ID Usuario</th>
                    <th>ID Categoría</th>
                    <th>Descripción</th>
                    <th>Fecha</th>
                    <th>Estado</th>
                    <th>Actualizar estado</th>
                    <th>Registrar seguimiento</th>
                </tr>
                </thead>
                <tbody>
                <% for (ClsReclamo_jvl reclamo : reclamos) {
                       String fecha = reclamo.getFechaRegistro() != null ? sdf.format(reclamo.getFechaRegistro()) : "-";
                       String estado = reclamo.getEstado() != null ? reclamo.getEstado() : "";
                %>
                    <tr>
                        <td><%= reclamo.getIdReclamo() %></td>
                        <td><%= reclamo.getIdUsuario() %></td>
                        <td><%= reclamo.getIdCategoria() %></td>
                        <td style="max-width: 260px;"><%= escapeHtml(reclamo.getDescripcion()) %></td>
                        <td><%= fecha %></td>
                        <td><span class="badge text-bg-primary"><%= escapeHtml(estado) %></span></td>
                        <td>
                            <form action="<%= ctx %>/admin" method="post" class="d-flex gap-2">
                                <input type="hidden" name="accion" value="actualizarEstado"/>
                                <input type="hidden" name="idReclamo" value="<%= reclamo.getIdReclamo() %>"/>
                                <select class="form-select form-select-sm" name="estado" required>
                                    <option value="Pendiente" <%= "Pendiente".equalsIgnoreCase(estado) ? "selected" : "" %>>Pendiente</option>
                                    <option value="En atención" <%= "En atención".equalsIgnoreCase(estado) ? "selected" : "" %>>En atención</option>
                                    <option value="Resuelto" <%= "Resuelto".equalsIgnoreCase(estado) ? "selected" : "" %>>Resuelto</option>
                                </select>
                                <button type="submit" class="btn btn-sm btn-primary">Guardar</button>
                            </form>
                        </td>
                        <td>
                            <form action="<%= ctx %>/admin" method="post" class="row g-1">
                                <input type="hidden" name="accion" value="registrarSeguimiento"/>
                                <input type="hidden" name="idReclamo" value="<%= reclamo.getIdReclamo() %>"/>
                                <div class="col-12">
                                    <textarea class="form-control form-control-sm" name="observacion" placeholder="Detalle" required></textarea>
                                </div>
                                <div class="col-8">
                                    <select class="form-select form-select-sm" name="estado" required>
                                        <option value="Pendiente">Pendiente</option>
                                        <option value="En atención">En atención</option>
                                        <option value="Resuelto">Resuelto</option>
                                    </select>
                                </div>
                                <div class="col-4 d-grid">
                                    <button type="submit" class="btn btn-sm btn-success">Registrar</button>
                                </div>
                            </form>
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
