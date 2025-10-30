<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Área de Usuario - Sistema de Reclamos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/VistaUsuario.jsp">Reclamos</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/reclamos?accion=listar">Mis reclamos</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/reclamos?accion=formulario">Registrar reclamo</a></li>
            </ul>
            <span class="navbar-text me-3">Hola, <c:out value="${sessionScope.usuarioAutenticado.nombre}"/></span>
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
            <div class="alert alert-info" role="alert">
                Bienvenido al portal de usuarios. Utilice el menú superior para registrar un reclamo o hacer seguimiento a los ya enviados.
            </div>
        </div>
    </div>
    <div class="row g-3">
        <div class="col-md-4">
            <div class="card border-primary">
                <div class="card-body text-center">
                    <h5 class="card-title">Registrar Reclamo</h5>
                    <p class="card-text">Complete el formulario con el detalle del inconveniente.</p>
                    <a href="${pageContext.request.contextPath}/reclamos?accion=formulario" class="btn btn-primary">Nuevo reclamo</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-success">
                <div class="card-body text-center">
                    <h5 class="card-title">Mis Reclamos</h5>
                    <p class="card-text">Revise el estado actual y los seguimientos de sus solicitudes.</p>
                    <a href="${pageContext.request.contextPath}/reclamos?accion=listar" class="btn btn-success">Ver listado</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-secondary">
                <div class="card-body text-center">
                    <h5 class="card-title">Soporte</h5>
                    <p class="card-text">Si necesita ayuda adicional contacte a soporte.</p>
                    <a href="mailto:soporte@example.com" class="btn btn-secondary">Contactar</a>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
