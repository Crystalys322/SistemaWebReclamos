<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <a href="${pageContext.request.contextPath}/VistaAdministrador.jsp" class="btn btn-outline-secondary">Regresar</a>
    </div>
    <div class="row g-4">
        <div class="col-lg-7">
            <div class="card">
                <div class="card-header">Usuarios registrados</div>
                <div class="card-body">
                    <c:if test="${empty usuarios}">
                        <div class="alert alert-info">Aún no hay usuarios registrados.</div>
                    </c:if>
                    <c:if test="${not empty usuarios}">
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
                                <c:forEach var="usuario" items="${usuarios}">
                                    <tr>
                                        <td><c:out value="${usuario.idUsuario}"/></td>
                                        <td><c:out value="${usuario.nombre}"/></td>
                                        <td><c:out value="${usuario.correo}"/></td>
                                        <td>
                                            <c:forEach var="rol" items="${roles}">
                                                <c:if test="${rol.idRol == usuario.idRol}">
                                                    <c:out value="${rol.nombreRol}"/>
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                        <td><c:out value="${usuario.ipAutorizada}"/></td>
                                        <td class="text-nowrap">
                                            <button type="button" class="btn btn-sm btn-outline-primary" data-accion="editar"
                                                    data-id="${usuario.idUsuario}"
                                                    data-nombre="${usuario.nombre}"
                                                    data-correo="${usuario.correo}"
                                                    data-password="${usuario.password}"
                                                    data-rol="${usuario.idRol}"
                                                    data-ip="${usuario.ipAutorizada}">Editar</button>
                                            <form action="${pageContext.request.contextPath}/admin" method="post" class="d-inline">
                                                <input type="hidden" name="accion" value="eliminarUsuario"/>
                                                <input type="hidden" name="idUsuario" value="${usuario.idUsuario}"/>
                                                <button type="submit" class="btn btn-sm btn-outline-danger"
                                                        onclick="return confirm('¿Está seguro de eliminar al usuario?');">Eliminar</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        <div class="col-lg-5">
            <div class="card">
                <div class="card-header">Registrar / actualizar usuario</div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin" id="formUsuario">
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
                                <c:forEach var="rol" items="${roles}">
                                    <option value="${rol.idRol}"><c:out value="${rol.nombreRol}"/></option>
                                </c:forEach>
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
