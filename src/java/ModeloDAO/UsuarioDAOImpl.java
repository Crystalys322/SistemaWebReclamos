package ModeloDAO;

import Config_jvl.ClsConexion;
import Interfaces.IUsuarioDAO;
import Modelo_jvl.ClsRol_jvl;
import Modelo_jvl.ClsUsuario_jvl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class UsuarioDAOImpl implements IUsuarioDAO {

    private static final String SQL_SELECT_BY_CREDENTIALS = "SELECT idUsuario, nombre, correo, password, idRol, ipAutorizada FROM usuarios WHERE correo = ? AND password = ? AND estado = 'ACTIVO'";
    private static final String SQL_SELECT_BY_ID = "SELECT idUsuario, nombre, correo, password, idRol, ipAutorizada FROM usuarios WHERE idUsuario = ?";
    private static final String SQL_SELECT_ALL = "SELECT idUsuario, nombre, correo, password, idRol, ipAutorizada FROM usuarios";
    private static final String SQL_INSERT = "INSERT INTO usuarios(nombre, correo, password, idRol, ipAutorizada, estado) VALUES(?,?,?,?,?,?)";
    private static final String SQL_UPDATE = "UPDATE usuarios SET nombre = ?, correo = ?, password = ?, idRol = ?, ipAutorizada = ?, estado = ? WHERE idUsuario = ?";
    private static final String SQL_DELETE = "DELETE FROM usuarios WHERE idUsuario = ?";
    private static final String SQL_UPDATE_IP = "UPDATE usuarios SET ipAutorizada = ? WHERE idUsuario = ?";
    private static final String SQL_SELECT_ROLES = "SELECT idRol, nombreRol FROM roles";
    private static final String SQL_SELECT_ROL_BY_ID = "SELECT idRol, nombreRol FROM roles WHERE idRol = ?";

    private final ClsConexion conexion;

    public UsuarioDAOImpl() {
        this.conexion = new ClsConexion();
    }

    @Override
    public Optional<ClsUsuario_jvl> obtenerPorCredenciales(String correo, String password) {
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return Optional.empty();
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_SELECT_BY_CREDENTIALS)) {
            ps.setString(1, correo);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapearUsuario(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error obtenerPorCredenciales: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public Optional<ClsUsuario_jvl> obtenerPorId(int idUsuario) {
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return Optional.empty();
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_SELECT_BY_ID)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapearUsuario(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error obtenerPorId: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public List<ClsUsuario_jvl> listarUsuarios() {
        List<ClsUsuario_jvl> usuarios = new ArrayList<>();
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return usuarios;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_SELECT_ALL);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                usuarios.add(mapearUsuario(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error listarUsuarios: " + e.getMessage());
        }
        return usuarios;
    }

    @Override
    public boolean registrarUsuario(ClsUsuario_jvl usuario) {
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return false;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_INSERT)) {
            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getCorreo());
            ps.setString(3, usuario.getPassword());
            ps.setInt(4, usuario.getIdRol());
            ps.setString(5, usuario.getIpAutorizada());
            ps.setString(6, "ACTIVO");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error registrarUsuario: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean actualizarUsuario(ClsUsuario_jvl usuario) {
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return false;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_UPDATE)) {
            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getCorreo());
            ps.setString(3, usuario.getPassword());
            ps.setInt(4, usuario.getIdRol());
            ps.setString(5, usuario.getIpAutorizada());
            ps.setString(6, "ACTIVO");
            ps.setInt(7, usuario.getIdUsuario());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error actualizarUsuario: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean eliminarUsuario(int idUsuario) {
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return false;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_DELETE)) {
            ps.setInt(1, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error eliminarUsuario: " + e.getMessage());
        }
        return false;
    }

    @Override
    public List<ClsRol_jvl> listarRoles() {
        List<ClsRol_jvl> roles = new ArrayList<>();
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return roles;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_SELECT_ROLES);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                roles.add(mapearRol(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error listarRoles: " + e.getMessage());
        }
        return roles;
    }

    @Override
    public Optional<ClsRol_jvl> obtenerRolPorId(int idRol) {
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return Optional.empty();
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_SELECT_ROL_BY_ID)) {
            ps.setInt(1, idRol);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapearRol(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error obtenerRolPorId: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public boolean actualizarIpAutorizada(int idUsuario, String nuevaIp) {
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return false;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_UPDATE_IP)) {
            ps.setString(1, nuevaIp);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error actualizarIpAutorizada: " + e.getMessage());
        }
        return false;
    }

    private ClsUsuario_jvl mapearUsuario(ResultSet rs) throws SQLException {
        ClsUsuario_jvl usuario = new ClsUsuario_jvl();
        usuario.setIdUsuario(rs.getInt("idUsuario"));
        usuario.setNombre(rs.getString("nombre"));
        usuario.setCorreo(rs.getString("correo"));
        usuario.setPassword(rs.getString("password"));
        usuario.setIdRol(rs.getInt("idRol"));
        usuario.setIpAutorizada(rs.getString("ipAutorizada"));
        return usuario;
    }

    private ClsRol_jvl mapearRol(ResultSet rs) throws SQLException {
        ClsRol_jvl rol = new ClsRol_jvl();
        rol.setIdRol(rs.getInt("idRol"));
        rol.setNombreRol(rs.getString("nombreRol"));
        return rol;
    }
}
