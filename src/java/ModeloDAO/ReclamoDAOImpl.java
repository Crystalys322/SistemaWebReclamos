package ModeloDAO;

import Config_jvl.ClsConexion;
import Interfaces.IReclamoDAO;
import Modelo_jvl.ClsReclamo_jvl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReclamoDAOImpl implements IReclamoDAO {

    private static final String SQL_INSERT = "INSERT INTO reclamos(idUsuario, idCategoria, descripcion, fechaRegistro, estado) VALUES(?,?,?,?,?)";
    private static final String SQL_SELECT_BY_USER = "SELECT idReclamo, idUsuario, idCategoria, descripcion, fechaRegistro, estado FROM reclamos WHERE idUsuario = ? ORDER BY fechaRegistro DESC";
    private static final String SQL_SELECT_ALL = "SELECT idReclamo, idUsuario, idCategoria, descripcion, fechaRegistro, estado FROM reclamos ORDER BY fechaRegistro DESC";
    private static final String SQL_UPDATE_STATE = "UPDATE reclamos SET estado = ? WHERE idReclamo = ?";
    private static final String SQL_REPORT_STATE = "SELECT estado, COUNT(*) AS total FROM reclamos GROUP BY estado";
    private static final String SQL_REPORT_CATEGORY = "SELECT c.nombreCategoria AS categoria, COUNT(*) AS total FROM reclamos r INNER JOIN categorias c ON r.idCategoria = c.idCategoria GROUP BY c.nombreCategoria";

    private final ClsConexion conexion;

    public ReclamoDAOImpl() {
        this.conexion = new ClsConexion();
    }

    @Override
    public boolean registrarReclamo(ClsReclamo_jvl reclamo) {
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return false;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_INSERT)) {
            ps.setInt(1, reclamo.getIdUsuario());
            ps.setInt(2, reclamo.getIdCategoria());
            ps.setString(3, reclamo.getDescripcion());
            Timestamp timestamp = reclamo.getFechaRegistro() != null ? reclamo.getFechaRegistro() : new Timestamp(System.currentTimeMillis());
            ps.setTimestamp(4, timestamp);
            ps.setString(5, reclamo.getEstado());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error registrarReclamo: " + e.getMessage());
        }
        return false;
    }

    @Override
    public List<ClsReclamo_jvl> listarPorUsuario(int idUsuario) {
        List<ClsReclamo_jvl> reclamos = new ArrayList<>();
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return reclamos;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_SELECT_BY_USER)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reclamos.add(mapearReclamo(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error listarPorUsuario: " + e.getMessage());
        }
        return reclamos;
    }

    @Override
    public List<ClsReclamo_jvl> listarTodos() {
        List<ClsReclamo_jvl> reclamos = new ArrayList<>();
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return reclamos;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_SELECT_ALL);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                reclamos.add(mapearReclamo(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error listarTodos: " + e.getMessage());
        }
        return reclamos;
    }

    @Override
    public boolean actualizarEstado(int idReclamo, String nuevoEstado) {
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return false;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_UPDATE_STATE)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idReclamo);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error actualizarEstado: " + e.getMessage());
        }
        return false;
    }

    @Override
    public Map<String, Integer> obtenerResumenPorEstado() {
        Map<String, Integer> resumen = new HashMap<>();
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return resumen;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_REPORT_STATE);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                resumen.put(rs.getString("estado"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            System.out.println("Error obtenerResumenPorEstado: " + e.getMessage());
        }
        return resumen;
    }

    @Override
    public Map<String, Integer> obtenerResumenPorCategoria() {
        Map<String, Integer> resumen = new HashMap<>();
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return resumen;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_REPORT_CATEGORY);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                resumen.put(rs.getString("categoria"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            System.out.println("Error obtenerResumenPorCategoria: " + e.getMessage());
        }
        return resumen;
    }

    private ClsReclamo_jvl mapearReclamo(ResultSet rs) throws SQLException {
        ClsReclamo_jvl reclamo = new ClsReclamo_jvl();
        reclamo.setIdReclamo(rs.getInt("idReclamo"));
        reclamo.setIdUsuario(rs.getInt("idUsuario"));
        reclamo.setIdCategoria(rs.getInt("idCategoria"));
        reclamo.setDescripcion(rs.getString("descripcion"));
        reclamo.setFechaRegistro(rs.getTimestamp("fechaRegistro"));
        reclamo.setEstado(rs.getString("estado"));
        return reclamo;
    }
}
