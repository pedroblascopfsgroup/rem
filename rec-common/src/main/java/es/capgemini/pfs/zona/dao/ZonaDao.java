package es.capgemini.pfs.zona.dao;

import java.util.List;
import java.util.Set;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;

/**
 * Interfaz dao para las Zonas.
 * @author pamuller
 *
 */
public interface ZonaDao extends AbstractDao<DDZona, Long> {

    /**
     * Obtiene todas las zonas de un nivel.
     *
     * @param idNivel id nivel
     * @param codigoZonasUsuario zonas del usuario
     * @return zonas
     */
    List<DDZona> buscarZonasPorCodigoNivel(Long idNivel, Set<String> codigoZonasUsuario);

    /**
     * Obtiene la zona correspondiente a un centro.
     *
     * @param centro String
     * @return Zona
     */
    DDZona getZonaPorCentro(String centro);

    /**
     * @param codigo String
     * @return Zona
     */
    DDZona getZonaPorCodigo(String codigo);

    /**
     * @param descripcion String
     * @return Zona
     */
    DDZona getZonaPorDescripcion(String descripcion);

    /**
     * Actualiza las zonas del usuario itinerante.
     * @param idUsuario Usuario que se quiere actualizar
     * @param idZona Zona que se debe actualizar
     */
    void updateZonaUsuarioItinerante(Long idUsuario, Long idZona);

    /**
     * Retorna todas las zonas con los códigos pasados.
     * @param codigos Set String
     * @return List Zona
     */
    List<DDZona> findZonasBycodigo(Set<String> codigos);

    /**
     * Obtiene las zonas relacionadas con el perfil de la tabla ZON_PEF_USU.
     * @param idPerfil id idPerfil
     * @return zonas
     */
    List<DDZona> buscarZonasPorPerfil(Long idPerfil);

    /**
     * Obtiene las zonas relacionadas con el código del perfil de la tabla ZON_PEF_USU.
     * @param codPerfil codigo 
     * @return zonas
     */
    List<DDZona> buscarZonasPorCodigoPerfil(String codPerfil);
    
    /**
     * Consulta si para esa zona existe ese perfil
     * @param idZona
     * @param idPerfil
     * @return
     */
    Boolean existePerfilZona(Long idZona, Long idPerfil);
    
    List<DDZona> getZonasJerarquiaByCodDesc(Integer idNivel, Set<String> codigoZonasUsuario, String codDesc);
    
    /**
     * Método que devuelve las zonas a partir del usuario y el perfil
     * @param idUsuario
     * @param codPerfil
     * @return
     */
    List<DDZona> getZonaPorUsuarioPerfil(Long idUsuario, String codPerfil);
    
    /**
     * 
     * Guarda un nuevo registro en ZON_PEF_USU, si no existe ya (se comrpueba que no haya ya un registro con la zona,
     * el perfil, y el usuario pasados por parametro)
     * @param zona
     * @param usuario
     * @param codPerfil
     */
    void guardarNuevoZonaPerfilUsuario(DDZona zona, Usuario usuario, String codPerfil);
    
    /**
     * Devuelve la primera zona usuario perfil existe dado un perfil y una zona. Navegando en el árbol desde el nodo que se le pasa hacia los padres, comprobando que tengan dicho perfil
     * @param idPerfil
     * @param codigoZona
     */
    public List<ZonaUsuarioPerfil> getZonasPerfilesUsuariosPrimerNivelExistente(Long idPerfil, String codigoZona);
    
    
    /**
     * Devuelve true o false según si la zon pef usu que se le pasa es la de nivel más bajo dado el perfil y la zona
     * @param zonPefUsu
     */
    public boolean userEstaEnElNivelMasBajoZonaPerfil(ZonaUsuarioPerfil zonPefUsu);
}
