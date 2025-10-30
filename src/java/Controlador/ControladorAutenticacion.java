package Controlador;

import Interfaces.IUsuarioDAO;
import ModeloDAO.UsuarioDAOImpl;
import Modelo_jvl.ClsRol_jvl;
import Modelo_jvl.ClsUsuario_jvl;
import java.io.IOException;
import java.util.Optional;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ControladorAutenticacion", urlPatterns = {"/autenticacion"})
public class ControladorAutenticacion extends HttpServlet {

    private final IUsuarioDAO usuarioDAO = new UsuarioDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if ("login".equalsIgnoreCase(accion)) {
            procesarLogin(request, response);
        } else if ("logout".equalsIgnoreCase(accion)) {
            procesarLogout(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no soportada");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if ("logout".equalsIgnoreCase(accion)) {
            procesarLogout(request, response);
        } else {
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void procesarLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        String captchaIngresado = request.getParameter("captcha");
        String captchaGenerado = (String) session.getAttribute("captcha");

        if (captchaGenerado == null || captchaIngresado == null || !captchaGenerado.equalsIgnoreCase(captchaIngresado.trim())) {
            request.setAttribute("mensajeError", "Captcha inválido, inténtelo nuevamente.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (correo == null || correo.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("mensajeError", "Credenciales incompletas.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        Optional<ClsUsuario_jvl> usuarioOpt = usuarioDAO.obtenerPorCredenciales(correo, password);
        if (!usuarioOpt.isPresent()) {
            request.setAttribute("mensajeError", "Usuario o contraseña incorrectos.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        ClsUsuario_jvl usuario = usuarioOpt.get();
        String ipRemota = request.getRemoteAddr();
        String ipAutorizada = usuario.getIpAutorizada();
        if (ipAutorizada != null && !ipAutorizada.isEmpty() && !ipAutorizada.equals(ipRemota)) {
            request.setAttribute("mensajeError", "Ingreso desde un equipo/IP no autorizado.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (ipAutorizada == null || ipAutorizada.isEmpty()) {
            usuarioDAO.actualizarIpAutorizada(usuario.getIdUsuario(), ipRemota);
            usuario.setIpAutorizada(ipRemota);
        }

        Optional<ClsRol_jvl> rolOpt = usuarioDAO.obtenerRolPorId(usuario.getIdRol());
        String nombreRol = rolOpt.map(ClsRol_jvl::getNombreRol).orElse("");
        session.setAttribute("usuarioAutenticado", usuario);
        session.setAttribute("rolAutenticado", nombreRol);

        if (nombreRol.equalsIgnoreCase("ADMINISTRADOR") || nombreRol.equalsIgnoreCase("ADMIN")) {
            response.sendRedirect("VistaAdministrador.jsp");
        } else {
            response.sendRedirect("VistaUsuario.jsp");
        }
    }

    private void procesarLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("login.jsp");
    }
}
