package Controlador;

import Interfaces.IReclamoDAO;
import Interfaces.ISeguimientoDAO;
import Interfaces.IUsuarioDAO;
import ModeloDAO.ReclamoDAOImpl;
import ModeloDAO.SeguimientoDAOImpl;
import ModeloDAO.UsuarioDAOImpl;
import Modelo_jvl.ClsReclamo_jvl;
import Modelo_jvl.ClsSeguimiento_jvl;
import Modelo_jvl.ClsUsuario_jvl;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ControladorAdministrador", urlPatterns = {"/admin"})
public class ControladorAdministrador extends HttpServlet {

    private final IReclamoDAO reclamoDAO = new ReclamoDAOImpl();
    private final ISeguimientoDAO seguimientoDAO = new SeguimientoDAOImpl();
    private final IUsuarioDAO usuarioDAO = new UsuarioDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!tieneAccesoAdministrador(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null || accion.isEmpty() || "panel".equalsIgnoreCase(accion)) {
            mostrarPanel(request, response);
        } else if ("reportes".equalsIgnoreCase(accion)) {
            mostrarReportes(request, response);
        } else if ("usuarios".equalsIgnoreCase(accion)) {
            listarUsuarios(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Acción no encontrada");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!tieneAccesoAdministrador(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        if ("actualizarEstado".equalsIgnoreCase(accion)) {
            actualizarEstado(request, response);
        } else if ("registrarSeguimiento".equalsIgnoreCase(accion)) {
            registrarSeguimiento(request, response, session);
        } else if ("guardarUsuario".equalsIgnoreCase(accion)) {
            guardarUsuario(request, response);
        } else if ("eliminarUsuario".equalsIgnoreCase(accion)) {
            eliminarUsuario(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no soportada");
        }
    }

    private void mostrarPanel(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ClsReclamo_jvl> reclamos = reclamoDAO.listarTodos();
        request.setAttribute("reclamos", reclamos);
        request.getRequestDispatcher("admin/listaReclamos.jsp").forward(request, response);
    }

    private void mostrarReportes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, Integer> resumenEstado = reclamoDAO.obtenerResumenPorEstado();
        Map<String, Integer> resumenCategoria = reclamoDAO.obtenerResumenPorCategoria();
        request.setAttribute("resumenEstado", resumenEstado);
        request.setAttribute("resumenCategoria", resumenCategoria);
        request.getRequestDispatcher("admin/reportes.jsp").forward(request, response);
    }

    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("usuarios", usuarioDAO.listarUsuarios());
        request.setAttribute("roles", usuarioDAO.listarRoles());
        request.getRequestDispatcher("admin/gestionUsuarios.jsp").forward(request, response);
    }

    private void actualizarEstado(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idReclamoParam = request.getParameter("idReclamo");
        String nuevoEstado = request.getParameter("estado");
        try {
            int idReclamo = Integer.parseInt(idReclamoParam);
            reclamoDAO.actualizarEstado(idReclamo, nuevoEstado);
            response.sendRedirect("admin?accion=panel");
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Identificador de reclamo inválido");
        }
    }

    private void registrarSeguimiento(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        String idReclamoParam = request.getParameter("idReclamo");
        String observacion = request.getParameter("observacion");
        String estado = request.getParameter("estado");
        try {
            int idReclamo = Integer.parseInt(idReclamoParam);
            ClsUsuario_jvl usuario = (ClsUsuario_jvl) session.getAttribute("usuarioAutenticado");
            ClsSeguimiento_jvl seguimiento = new ClsSeguimiento_jvl();
            seguimiento.setIdReclamo(idReclamo);
            seguimiento.setIdUsuario(usuario.getIdUsuario());
            seguimiento.setFecha(new Timestamp(System.currentTimeMillis()));
            seguimiento.setObservacion(observacion);
            seguimiento.setNuevoEstado(estado);
            if (seguimientoDAO.registrarSeguimiento(seguimiento)) {
                reclamoDAO.actualizarEstado(idReclamo, estado);
            }
            response.sendRedirect("admin?accion=panel");
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Identificador de reclamo inválido");
        }
    }

    private void guardarUsuario(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idUsuarioParam = request.getParameter("idUsuario");
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        String idRolParam = request.getParameter("idRol");
        String ipAutorizada = request.getParameter("ipAutorizada");

        if (nombre == null || nombre.trim().isEmpty() || correo == null || correo.trim().isEmpty()
                || password == null || password.trim().isEmpty() || idRolParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Datos de usuario incompletos");
            return;
        }

        try {
            int idRol = Integer.parseInt(idRolParam);
            ClsUsuario_jvl usuario = new ClsUsuario_jvl();
            usuario.setNombre(nombre.trim());
            usuario.setCorreo(correo.trim());
            usuario.setPassword(password.trim());
            usuario.setIdRol(idRol);
            usuario.setIpAutorizada(ipAutorizada != null ? ipAutorizada.trim() : "");

            boolean resultado;
            if (idUsuarioParam != null && !idUsuarioParam.isEmpty()) {
                int idUsuario = Integer.parseInt(idUsuarioParam);
                usuario.setIdUsuario(idUsuario);
                Optional<ClsUsuario_jvl> existente = usuarioDAO.obtenerPorId(idUsuario);
                if (!existente.isPresent()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Usuario no encontrado");
                    return;
                }
                resultado = usuarioDAO.actualizarUsuario(usuario);
            } else {
                resultado = usuarioDAO.registrarUsuario(usuario);
            }

            if (resultado) {
                response.sendRedirect("admin?accion=usuarios");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo guardar el usuario");
            }
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Rol inválido");
        }
    }

    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idUsuarioParam = request.getParameter("idUsuario");
        try {
            int idUsuario = Integer.parseInt(idUsuarioParam);
            usuarioDAO.eliminarUsuario(idUsuario);
            response.sendRedirect("admin?accion=usuarios");
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Identificador de usuario inválido");
        }
    }

    private boolean tieneAccesoAdministrador(HttpSession session) {
        if (session == null) {
            return false;
        }
        String rol = (String) session.getAttribute("rolAutenticado");
        return rol != null && (rol.equalsIgnoreCase("ADMINISTRADOR") || rol.equalsIgnoreCase("ADMIN"));
    }
}
