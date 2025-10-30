<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <a href="${pageContext.request.contextPath}/reclamos?accion=listar" class="btn btn-outline-secondary">Regresar</a>
    </div>
    <div class="card">
        <div class="card-body">
            <c:if test="${not empty mensajeError}">
                <div class="alert alert-danger">${mensajeError}</div>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/reclamos">
                <input type="hidden" name="accion" value="registrar"/>
                <div class="mb-3">
                    <label for="idCategoria" class="form-label">Categoría</label>
                    <select class="form-select" id="idCategoria" name="idCategoria" required>
                        <option value="" disabled selected>Seleccione una categoría</option>
                        <c:forEach var="categoria" items="${categorias}">
                            <option value="${categoria.idCategoria}"><c:out value="${categoria.nombreCategoria}"/></option>
                        </c:forEach>
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
