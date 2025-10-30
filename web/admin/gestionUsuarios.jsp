<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo_jvl.ClsUsuario_jvl" %>
<%@ page import="Modelo_jvl.ClsRol_jvl" %>
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
    List<ClsUsuario_jvl> usuarios = (List<ClsUsuario_jvl>) request.getAttribute("usuarios");
    List<ClsRol_jvl> roles = (List<ClsRol_jvl>) request.getAttribute("roles");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Usuarios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Gestión de usuarios</h2>
        <a href="<%= ctx %>/VistaAdministrador.jsp" class="btn btn-outline-secondary">Regresar</a>
    </div>
    <div class="row g-4">
        <div class="col-lg-7">
            <div class="card">
                <div class="card-header">Usuarios registrados</div>
                <div class="card-body">
                    <% if (usuarios == null || usuarios.isEmpty()) { %>
                        <div class="alert alert-info">Aún no hay usuarios registrados.</div>
                    <% } else { %>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover align-middle">
                                <thead class="table-dark">
                                <tr>
                                    <th>#</th>
                                    <th>Nombre</th>
                                    <th>Correo</th>
                                    <th>Rol</th>
                                    <th>IP autorizada</th>
                                    <th>Acciones</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% for (ClsUsuario_jvl usuario : usuarios) {
                                       String rolNombre = "";
                                       if (roles != null) {
                                           for (ClsRol_jvl rol : roles) {
                                               if (rol.getIdRol() == usuario.getIdRol()) {
                                                   rolNombre = rol.getNombreRol();
                                                   break;
                                               }
                                           }
                                       }
                                %>
                                    <tr>
                                        <td><%= usuario.getIdUsuario() %></td>
                                        <td><%= escapeHtml(usuario.getNombre()) %></td>
                                        <td><%= escapeHtml(usuario.getCorreo()) %></td>
                                        <td><%= escapeHtml(rolNombre) %></td>
                                        <td><%= escapeHtml(usuario.getIpAutorizada()) %></td>
                                        <td class="text-nowrap">
                                            <button type="button" class="btn btn-sm btn-outline-primary" data-accion="editar"
                                                    data-id="<%= usuario.getIdUsuario() %>"
                                                    data-nombre="<%= escapeHtml(usuario.getNombre()) %>"
                                                    data-correo="<%= escapeHtml(usuario.getCorreo()) %>"
                                                    data-password="<%= escapeHtml(usuario.getPassword()) %>"
                                                    data-rol="<%= usuario.getIdRol() %>"
                                                    data-ip="<%= escapeHtml(usuario.getIpAutorizada()) %>">Editar</button>
                                            <form action="<%= ctx %>/admin" method="post" class="d-inline">
                                                <input type="hidden" name="accion" value="eliminarUsuario"/>
                                                <input type="hidden" name="idUsuario" value="<%= usuario.getIdUsuario() %>"/>
                                                <button type="submit" class="btn btn-sm btn-outline-danger"
                                                        onclick="return confirm('¿Está seguro de eliminar al usuario?');">Eliminar</button>
                                            </form>
                                        </td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
        <div class="col-lg-5">
            <div class="card">
                <div class="card-header">Registrar / actualizar usuario</div>
                <div class="card-body">
                    <form method="post" action="<%= ctx %>/admin" id="formUsuario">
                        <input type="hidden" name="accion" value="guardarUsuario"/>
                        <input type="hidden" name="idUsuario" id="idUsuario"/>
                        <div class="mb-3">
                            <label for="nombre" class="form-label">Nombre</label>
                            <input type="text" class="form-control" id="nombre" name="nombre" required>
                        </div>
                        <div class="mb-3">
                            <label for="correo" class="form-label">Correo</label>
                            <input type="email" class="form-control" id="correo" name="correo" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Contraseña</label>
                            <input type="text" class="form-control" id="password" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label for="idRol" class="form-label">Rol</label>
                            <select class="form-select" id="idRol" name="idRol" required>
                                <option value="" disabled selected>Seleccione un rol</option>
                                <% if (roles != null) { %>
                                    <% for (ClsRol_jvl rol : roles) { %>
                                        <option value="<%= rol.getIdRol() %>"><%= escapeHtml(rol.getNombreRol()) %></option>
                                    <% } %>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="ipAutorizada" class="form-label">IP autorizada (opcional)</label>
                            <input type="text" class="form-control" id="ipAutorizada" name="ipAutorizada" placeholder="0.0.0.0">
                        </div>
                        <div class="d-flex justify-content-between">
                            <button type="submit" class="btn btn-success">Guardar</button>
                            <button type="reset" class="btn btn-outline-secondary" id="btnLimpiar">Limpiar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const form = document.getElementById('formUsuario');
    const btnLimpiar = document.getElementById('btnLimpiar');
    document.querySelectorAll('[data-accion="editar"]').forEach(btn => {
        btn.addEventListener('click', () => {
            form.idUsuario.value = btn.dataset.id;
            form.nombre.value = btn.dataset.nombre;
            form.correo.value = btn.dataset.correo;
            form.password.value = btn.dataset.password;
            form.idRol.value = btn.dataset.rol;
            form.ipAutorizada.value = btn.dataset.ip;
            form.nombre.focus();
        });
    });
    btnLimpiar.addEventListener('click', () => {
        form.idUsuario.value = '';
        form.idRol.selectedIndex = 0;
    });
</script>
</body>
</html>
