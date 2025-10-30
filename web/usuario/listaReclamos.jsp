<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
            <a href="${pageContext.request.contextPath}/VistaUsuario.jsp" class="btn btn-outline-secondary">Inicio</a>
            <a href="${pageContext.request.contextPath}/reclamos?accion=formulario" class="btn btn-primary">Nuevo reclamo</a>
        </div>
    </div>
    <c:if test="${empty reclamos}">
        <div class="alert alert-info">Todavía no has registrado reclamos.</div>
    </c:if>
    <c:if test="${not empty reclamos}">
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
                <c:forEach var="reclamo" items="${reclamos}">
                    <tr>
                        <td><c:out value="${reclamo.idReclamo}"/></td>
                        <td><c:out value="${reclamo.idCategoria}"/></td>
                        <td style="max-width: 260px;"><c:out value="${reclamo.descripcion}"/></td>
                        <td><fmt:formatDate value="${reclamo.fechaRegistro}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td><span class="badge text-bg-secondary"><c:out value="${reclamo.estado}"/></span></td>
                        <td>
                            <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/reclamos?accion=seguimiento&idReclamo=${reclamo.idReclamo}">Ver seguimiento</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
