<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel principal - Administrador</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/VistaAdministrador.jsp">Admin Reclamos</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin?accion=panel">Panel</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin?accion=reportes">Reportes</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin?accion=usuarios">Usuarios</a></li>
            </ul>
            <span class="navbar-text me-3">Administrador: <c:out value="${sessionScope.usuarioAutenticado.nombre}"/></span>
            <form class="d-inline" method="post" action="${pageContext.request.contextPath}/autenticacion">
                <input type="hidden" name="accion" value="logout"/>
                <button class="btn btn-outline-light btn-sm" type="submit">Cerrar sesión</button>
            </form>
        </div>
    </div>
</nav>
<div class="container py-4">
    <div class="row">
        <div class="col-12">
            <div class="alert alert-secondary" role="alert">
                Seleccione la opción deseada en el menú superior para gestionar reclamos, usuarios o reportes.
            </div>
        </div>
    </div>
    <div class="row g-3">
        <div class="col-md-4">
            <div class="card border-dark">
                <div class="card-body text-center">
                    <h5 class="card-title">Panel de atención</h5>
                    <p class="card-text">Revise los reclamos y actualice su estado.</p>
                    <a href="${pageContext.request.contextPath}/admin?accion=panel" class="btn btn-dark">Ir al panel</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-info">
                <div class="card-body text-center">
                    <h5 class="card-title">Reportes</h5>
                    <p class="card-text">Visualice el resumen por estado y categoría.</p>
                    <a href="${pageContext.request.contextPath}/admin?accion=reportes" class="btn btn-info">Ver reportes</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-warning">
                <div class="card-body text-center">
                    <h5 class="card-title">Gestión de usuarios</h5>
                    <p class="card-text">Administre las cuentas y roles de los usuarios.</p>
                    <a href="${pageContext.request.contextPath}/admin?accion=usuarios" class="btn btn-warning">Gestionar usuarios</a>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
