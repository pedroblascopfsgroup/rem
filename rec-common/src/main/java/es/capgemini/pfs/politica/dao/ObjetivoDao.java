package es.capgemini.pfs.politica.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.Objetivo;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * Dao para los objetivos.
 * @author aesteban
*/
public interface ObjetivoDao extends AbstractDao<Objetivo, Long> {

    /**
     * Devuelve los objetivos pendientes.
     * @return una lista de objetivos pendientes.
     */
    List<Objetivo> getObjetivosPendientes();

    /**
     * Marca un objetivo como cumplido.
     * @param o el objetivo
     */
    void marcarComoCumplido(Objetivo o);

    /**
     * Marca un objetivo como incumplido.
     * @param o el objetivo
     */
    void marcarComoIncumplido(Objetivo o);

    /**
     * Busca los objetivos pendientes para el gestor.
     * @param usuario usuario
     * @param zonas lista de zonas
     * @return lista de objetivos
     */
    List<Objetivo> buscarObjetivosPendientesGestor(Usuario usuario, List<DDZona> zonas);
    
    /**
     * Busca los objetivos pendientes para el gestor.
     * @param usuario usuario
     * @return lista de objetivos
     */
    List<Objetivo> buscarObjetivosPendientesGestor(Usuario usuario);

    /**
     * Obtiene la cantidad de objetivos pendientes para el gestor.
     * @param usuario Usuario
     * @param zonas lista de zonas
     * @return integer
     */
    Integer cantidadObjetivosPendientesGestor(Usuario usuario, List<DDZona> zonas);
    
    /**
     * Obtiene la cantidad de objetivos pendientes para el gestor.
     * @param usuario Usuario
     * @return integer
     */
    Long cantidadObjetivosPendientesGestor(Usuario usuario);

    /**
     * Devuelve los objetivos activos (confirmados, propuestos) de una política dada
     * @param idPolitica
     * @return
     */
    List<Objetivo> getObjetivosActivos(Long idPolitica);
}
