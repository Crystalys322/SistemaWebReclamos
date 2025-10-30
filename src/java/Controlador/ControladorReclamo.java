package Controlador;

import Interfaces.ICategoriaDAO;
import Interfaces.IReclamoDAO;
import Interfaces.ISeguimientoDAO;
import ModeloDAO.CategoriaDAOImpl;
import ModeloDAO.ReclamoDAOImpl;
import ModeloDAO.SeguimientoDAOImpl;
import Modelo_jvl.ClsReclamo_jvl;
import Modelo_jvl.ClsSeguimiento_jvl;
import Modelo_jvl.ClsUsuario_jvl;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ControladorReclamo", urlPatterns = {"/reclamos"})
public class ControladorReclamo extends HttpServlet {

    private final IReclamoDAO reclamoDAO = new ReclamoDAOImpl();
    private final ICategoriaDAO categoriaDAO = new CategoriaDAOImpl();
    private final ISeguimientoDAO seguimientoDAO = new SeguimientoDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioAutenticado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        ClsUsuario_jvl usuario = (ClsUsuario_jvl) session.getAttribute("usuarioAutenticado");
        String accion = request.getParameter("accion");
        if ("formulario".equalsIgnoreCase(accion)) {
            mostrarFormularioRegistro(request, response);
        } else if ("seguimiento".equalsIgnoreCase(accion)) {
            mostrarSeguimiento(request, response, usuario);
        } else {
            listarReclamosUsuario(request, response, usuario);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioAutenticado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        ClsUsuario_jvl usuario = (ClsUsuario_jvl) session.getAttribute("usuarioAutenticado");
        String accion = request.getParameter("accion");
        if ("registrar".equalsIgnoreCase(accion)) {
            registrarReclamo(request, response, usuario);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no soportada");
        }
    }

    private void mostrarFormularioRegistro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("categorias", categoriaDAO.listarCategorias());
        request.getRequestDispatcher("usuario/formularioReclamo.jsp").forward(request, response);
    }

    private void mostrarSeguimiento(HttpServletRequest request, HttpServletResponse response, ClsUsuario_jvl usuario) throws ServletException, IOException {
        String idReclamoParam = request.getParameter("idReclamo");
        try {
            int idReclamo = Integer.parseInt(idReclamoParam);
            List<ClsReclamo_jvl> reclamosUsuario = reclamoDAO.listarPorUsuario(usuario.getIdUsuario());
            boolean pertenece = reclamosUsuario.stream().anyMatch(r -> r.getIdReclamo() == idReclamo);
            if (!pertenece) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tiene acceso a este seguimiento");
                return;
            }
            List<ClsSeguimiento_jvl> seguimientos = seguimientoDAO.listarPorReclamo(idReclamo);
            request.setAttribute("seguimientos", seguimientos);
            request.getRequestDispatcher("usuario/seguimientoReclamo.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Identificador de reclamo inválido");
        }
    }

    private void listarReclamosUsuario(HttpServletRequest request, HttpServletResponse response, ClsUsuario_jvl usuario) throws ServletException, IOException {
        List<ClsReclamo_jvl> reclamos = reclamoDAO.listarPorUsuario(usuario.getIdUsuario());
        request.setAttribute("reclamos", reclamos);
        request.getRequestDispatcher("usuario/listaReclamos.jsp").forward(request, response);
    }

    private void registrarReclamo(HttpServletRequest request, HttpServletResponse response, ClsUsuario_jvl usuario) throws IOException, ServletException {
        String descripcion = request.getParameter("descripcion");
        String idCategoriaParam = request.getParameter("idCategoria");
        if (descripcion == null || descripcion.trim().isEmpty() || idCategoriaParam == null) {
            request.setAttribute("mensajeError", "Debe completar todos los campos.");
            mostrarFormularioRegistro(request, response);
            return;
        }
        try {
            int idCategoria = Integer.parseInt(idCategoriaParam);
            ClsReclamo_jvl reclamo = new ClsReclamo_jvl();
            reclamo.setIdUsuario(usuario.getIdUsuario());
            reclamo.setIdCategoria(idCategoria);
            reclamo.setDescripcion(descripcion.trim());
            reclamo.setFechaRegistro(new Timestamp(System.currentTimeMillis()));
            reclamo.setEstado("Pendiente");

            boolean registrado = reclamoDAO.registrarReclamo(reclamo);
            if (registrado) {
                response.sendRedirect("reclamos?accion=listar");
            } else {
                request.setAttribute("mensajeError", "No se pudo registrar el reclamo, intente nuevamente.");
                mostrarFormularioRegistro(request, response);
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("mensajeError", "Categoría inválida.");
            mostrarFormularioRegistro(request, response);
        }
    }
}
