package ModeloDAO;

import Config_jvl.ClsConexion;
import Interfaces.ISeguimientoDAO;
import Modelo_jvl.ClsSeguimiento_jvl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class SeguimientoDAOImpl implements ISeguimientoDAO {

    private static final String SQL_INSERT = "INSERT INTO seguimientos(idReclamo, idUsuario, fecha, observacion, nuevoEstado) VALUES(?,?,?,?,?)";
    private static final String SQL_SELECT_BY_RECLAMO = "SELECT idSeguimiento, idReclamo, idUsuario, fecha, observacion, nuevoEstado FROM seguimientos WHERE idReclamo = ? ORDER BY fecha DESC";

    private final ClsConexion conexion;

    public SeguimientoDAOImpl() {
        this.conexion = new ClsConexion();
    }

    @Override
    public boolean registrarSeguimiento(ClsSeguimiento_jvl seguimiento) {
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return false;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_INSERT)) {
            ps.setInt(1, seguimiento.getIdReclamo());
            ps.setInt(2, seguimiento.getIdUsuario());
            Timestamp fecha = seguimiento.getFecha() != null ? seguimiento.getFecha() : new Timestamp(System.currentTimeMillis());
            ps.setTimestamp(3, fecha);
            ps.setString(4, seguimiento.getObservacion());
            ps.setString(5, seguimiento.getNuevoEstado());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error registrarSeguimiento: " + e.getMessage());
        }
        return false;
    }

    @Override
    public List<ClsSeguimiento_jvl> listarPorReclamo(int idReclamo) {
        List<ClsSeguimiento_jvl> seguimientos = new ArrayList<>();
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return seguimientos;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_SELECT_BY_RECLAMO)) {
            ps.setInt(1, idReclamo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    seguimientos.add(mapearSeguimiento(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error listarPorReclamo: " + e.getMessage());
        }
        return seguimientos;
    }

    private ClsSeguimiento_jvl mapearSeguimiento(ResultSet rs) throws SQLException {
        ClsSeguimiento_jvl seguimiento = new ClsSeguimiento_jvl();
        seguimiento.setIdSeguimiento(rs.getInt("idSeguimiento"));
        seguimiento.setIdReclamo(rs.getInt("idReclamo"));
        seguimiento.setIdUsuario(rs.getInt("idUsuario"));
        seguimiento.setFecha(rs.getTimestamp("fecha"));
        seguimiento.setObservacion(rs.getString("observacion"));
        seguimiento.setNuevoEstado(rs.getString("nuevoEstado"));
        return seguimiento;
    }
}
