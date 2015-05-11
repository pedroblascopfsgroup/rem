package es.pfsgroup.plugin.recovery.mejoras.favoritos.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.mejoras.favoritos.dto.MEJDtoFavoritos;
import es.pfsgroup.plugin.recovery.mejoras.favoritos.model.MEJFavoritos;

/**
 * Dao de favoritos.
 * @author jbosnjak
 *
 */
public interface MEJFavoritosDao extends AbstractDao<MEJFavoritos, Long> {

    /**
     * obtiene la lista de favoritos.
     * @return lista de favoritos
     */
    List<MEJFavoritos> obtenerFavoritosOrdenados();

    /**
     * obtiene los favoritos de una entidad.
     * @param idEntidad id
     * @param tipoEntidad tipoEntidad
     * @return lista de favoritos
     */
    List<MEJFavoritos> obtenerFavoritosEntidad(Long idEntidad, String tipoEntidad);

    /**
     * Busca un favorito para el usuario actual y si ya existe lo saca de la lista.
     * @param dto trae los datos para el método.
     */
    void buscarYBorrarFavorito(MEJDtoFavoritos dto);

}
