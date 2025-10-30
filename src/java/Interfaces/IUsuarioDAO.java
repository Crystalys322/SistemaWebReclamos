package Interfaces;

import Modelo_jvl.ClsRol_jvl;
import Modelo_jvl.ClsUsuario_jvl;
import java.util.List;
import java.util.Optional;

public interface IUsuarioDAO {

    Optional<ClsUsuario_jvl> obtenerPorCredenciales(String correo, String password);

    Optional<ClsUsuario_jvl> obtenerPorId(int idUsuario);

    List<ClsUsuario_jvl> listarUsuarios();

    boolean registrarUsuario(ClsUsuario_jvl usuario);

    boolean actualizarUsuario(ClsUsuario_jvl usuario);

    boolean eliminarUsuario(int idUsuario);

    List<ClsRol_jvl> listarRoles();

    Optional<ClsRol_jvl> obtenerRolPorId(int idRol);

    boolean actualizarIpAutorizada(int idUsuario, String nuevaIp);
}
