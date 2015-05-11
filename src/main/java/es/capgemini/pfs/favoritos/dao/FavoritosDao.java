package es.capgemini.pfs.favoritos.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.favoritos.dto.DtoFavoritos;
import es.capgemini.pfs.favoritos.model.Favoritos;

/**
 * Dao de favoritos.
 * @author jbosnjak
 *
 */
public interface FavoritosDao extends AbstractDao<Favoritos, Long> {

    /**
     * obtiene la lista de favoritos.
     * @return lista de favoritos
     */
    List<Favoritos> obtenerFavoritosOrdenados();

    /**
     * obtiene los favoritos de una entidad.
     * @param idEntidad id
     * @param tipoEntidad tipoEntidad
     * @return lista de favoritos
     */
    List<Favoritos> obtenerFavoritosEntidad(Long idEntidad, String tipoEntidad);

    /**
     * Busca un favorito para el usuario actual y si ya existe lo saca de la lista.
     * @param dto trae los datos para el método.
     */
    void buscarYBorrarFavorito(DtoFavoritos dto);

}
