package Interfaces;

import Modelo_jvl.ClsReclamo_jvl;
import java.util.List;
import java.util.Map;

public interface IReclamoDAO {

    boolean registrarReclamo(ClsReclamo_jvl reclamo);

    List<ClsReclamo_jvl> listarPorUsuario(int idUsuario);

    List<ClsReclamo_jvl> listarTodos();

    boolean actualizarEstado(int idReclamo, String nuevoEstado);

    Map<String, Integer> obtenerResumenPorEstado();

    Map<String, Integer> obtenerResumenPorCategoria();
}
