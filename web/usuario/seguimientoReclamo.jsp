<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <a href="${pageContext.request.contextPath}/reclamos?accion=listar" class="btn btn-outline-secondary">Regresar</a>
    </div>
    <div class="card">
        <div class="card-body">
            <c:if test="${empty seguimientos}">
                <div class="alert alert-info mb-0">Aún no se han registrado seguimientos para este reclamo.</div>
            </c:if>
            <c:if test="${not empty seguimientos}">
                <div class="timeline">
                    <c:forEach var="seguimiento" items="${seguimientos}">
                        <div class="border-start border-3 border-primary ps-3 pb-3 mb-3">
                            <div class="d-flex justify-content-between">
                                <strong>Estado: <c:out value="${seguimiento.nuevoEstado}"/></strong>
                                <small class="text-muted">
                                    <fmt:formatDate value="${seguimiento.fecha}" pattern="dd/MM/yyyy HH:mm"/>
                                </small>
                            </div>
                            <p class="mb-1"><c:out value="${seguimiento.observacion}"/></p>
                            <span class="badge text-bg-light">Registrado por usuario ID <c:out value="${seguimiento.idUsuario}"/></span>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
