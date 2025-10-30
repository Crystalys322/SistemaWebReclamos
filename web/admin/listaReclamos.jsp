<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
            <a href="${pageContext.request.contextPath}/VistaAdministrador.jsp" class="btn btn-outline-secondary">Regresar</a>
        </div>
    </div>
    <c:if test="${empty reclamos}">
        <div class="alert alert-info">No existen reclamos registrados.</div>
    </c:if>
    <c:if test="${not empty reclamos}">
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
                <c:forEach var="reclamo" items="${reclamos}">
                    <tr>
                        <td><c:out value="${reclamo.idReclamo}"/></td>
                        <td><c:out value="${reclamo.idUsuario}"/></td>
                        <td><c:out value="${reclamo.idCategoria}"/></td>
                        <td style="max-width: 260px;"><c:out value="${reclamo.descripcion}"/></td>
                        <td>
                            <fmt:formatDate value="${reclamo.fechaRegistro}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                        <td><span class="badge text-bg-primary"><c:out value="${reclamo.estado}"/></span></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin" method="post" class="d-flex gap-2">
                                <input type="hidden" name="accion" value="actualizarEstado"/>
                                <input type="hidden" name="idReclamo" value="${reclamo.idReclamo}"/>
                                <select class="form-select form-select-sm" name="estado" required>
                                    <option value="Pendiente" <c:if test="${reclamo.estado eq 'Pendiente'}">selected</c:if>>Pendiente</option>
                                    <option value="En atención" <c:if test="${reclamo.estado eq 'En atención'}">selected</c:if>>En atención</option>
                                    <option value="Resuelto" <c:if test="${reclamo.estado eq 'Resuelto'}">selected</c:if>>Resuelto</option>
                                </select>
                                <button type="submit" class="btn btn-sm btn-primary">Guardar</button>
                            </form>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin" method="post" class="row g-1">
                                <input type="hidden" name="accion" value="registrarSeguimiento"/>
                                <input type="hidden" name="idReclamo" value="${reclamo.idReclamo}"/>
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
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
