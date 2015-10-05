package es.capgemini.pfs.despachoExterno.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Definición del DAO para despachos externos.
 * @author pamuller
 *
 */
public interface DespachoExternoDao extends AbstractDao<DespachoExterno, Long> {

    /**
     * Busca los gestores de un despacho.
     * @param idDespacho el id del despacho.
     * @return la lista de gestores.
     */
    List<GestorDespacho> buscarGestoresDespacho(Long idDespacho);

    /**
     * Busca los supervisores de un despacho.
     * @param idDespacho el id del despacho.
     * @return la lista de supervisores.
     */
    List<GestorDespacho> buscarSupervisoresDespacho(Long idDespacho);

    /**
     * Busca los supervisores.
     * @return la lista de supervisores.
     */
    List<Usuario> buscarAllSupervisores();

    /**
     * devuelve una lista de despachos filtrado por zonas
     * @param zonas
     * @param tipoDespacho
     * @return
     */
    List<DespachoExterno> buscarDespachosPorTipoZona(String zonas, String tipoDespacho);

    /**
     * Recupera todos los gestores que pertenecen a un grupo de despachos
     * @param listadoDespachos
     * @return
     */
    List<Usuario> getGestoresListadoDespachos(String listadoDespachos);

    /**
     * Recupera todos los supervisores que pertenecen a un grupo de despachos
     * @param listadoDespachos
     * @return
     */
    List<Usuario> getSupervisoresListadoDespachos(String listadoDespachos);
    
    /**
     * Devuelve los despachos de un usuario y tipo
     * @param idUsuario
     * @param ddTipoDespachoExterno Constante de DDTipoDespachoExterno
     * @return
     */
    List<GestorDespacho> buscaDespachosPorUsuarioYTipo(Long idUsuario, String ddTipoDespachoExterno);

    /**
     * Devuelve los despachos de un usuario
     * @param idUsuario
     * @return
     */
    List<GestorDespacho> buscaDespachosPorUsuario(Long idUsuario);
}
