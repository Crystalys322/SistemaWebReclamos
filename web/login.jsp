<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String caracteres = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    java.util.Random random = new java.util.Random();
    StringBuilder captchaBuilder = new StringBuilder();
    for (int i = 0; i < 6; i++) {
        captchaBuilder.append(caracteres.charAt(random.nextInt(caracteres.length())));
    }
    String captchaGenerado = captchaBuilder.toString();
    session.setAttribute("captcha", captchaGenerado);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Ingreso al sistema de reclamos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center" style="min-height: 100vh;">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow-sm">
                <div class="card-header text-center">
                    <h4>Portal de Reclamos</h4>
                    <p class="text-muted mb-0">Ingrese sus credenciales</p>
                </div>
                <div class="card-body">
                    <c:if test="${not empty mensajeError}">
                        <div class="alert alert-danger" role="alert">
                            ${mensajeError}
                        </div>
                    </c:if>
                    <form method="post" action="${pageContext.request.contextPath}/autenticacion">
                        <input type="hidden" name="accion" value="login"/>
                        <div class="mb-3">
                            <label for="correo" class="form-label">Correo electrónico</label>
                            <input type="email" id="correo" name="correo" class="form-control" required autofocus>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Contraseña</label>
                            <input type="password" id="password" name="password" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Captcha de verificación</label>
                            <div class="input-group">
                                <span class="input-group-text fw-bold bg-secondary text-white" style="letter-spacing: 3px;">
                                    <%= captchaGenerado %>
                                </span>
                                <input type="text" name="captcha" class="form-control" placeholder="Ingrese el código" required>
                            </div>
                            <small class="form-text text-muted">Se valida el dispositivo y el captcha para mayor seguridad.</small>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">Iniciar sesión</button>
                        </div>
                    </form>
                </div>
                <div class="card-footer text-center text-muted">
                    &copy; <c:out value="${pageContext.request.serverName}"/> - Sistema de Reclamos
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
