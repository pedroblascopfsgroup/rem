package es.capgemini.pfs.favoritos;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.favoritos.dao.FavoritosDao;
import es.capgemini.pfs.favoritos.dto.DtoFavoritos;
import es.capgemini.pfs.favoritos.model.Favoritos;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase manager de la entidad Favoritos.
 *
 * @author jbosnjak
 *
 */

@Service
public class FavoritosManager {

    @Autowired
    private Executor executor;

    @Autowired
    private FavoritosDao favoritosDao;

    private static final int CANTIDAD_MAXIMA_FAVORITOS = 15;

    /**
     * graba un nuevo favorito en caso de que venga como parametro
     * y devuelve los favoritos para un usuario.
     * @param dto dto favoritos
     * @return favoritos
     */
    @BusinessOperation(ComunBusinessOperation.BO_FAVORITOS_MGR_MANTENER_FAVORITOS)
    @Transactional(readOnly = false)
    //TODO mejorar la performance de este metodo. saludos terricolas
    public List<Favoritos> mantenerFavoritos(DtoFavoritos dto) {
        //NUEVO PROCESO:
        if (dto.getEntidadInformacion() == null) {
            return favoritosDao.obtenerFavoritosOrdenados();
        }
        Usuario usu = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        dto.setIdUsuario(usu.getId());
        //BUSCARLO EN LA LISTA, SI ESTA SE BORRA
        favoritosDao.buscarYBorrarFavorito(dto);
        //SE INSERTA EL NUEVO
        Favoritos nuevoFav = crearFavorito(dto);
        this.saveOrUpdate(nuevoFav);
        List<Favoritos> favoritosActuales = favoritosDao.obtenerFavoritosOrdenados();
        //SI SON MAS DE 15 SE BORRA EL DE MENOS ID.
        if (favoritosActuales.size() > CANTIDAD_MAXIMA_FAVORITOS) {
            Favoritos yaNoEsFavorito = favoritosActuales.remove(favoritosActuales.size() - 1);
            favoritosDao.delete(yaNoEsFavorito);
        }
        //En caso de que no se inserte nada, como la primera vez, se devuelve la lista simplemente
        if (dto.getEntidadInformacion() == null || dto.getIdInformacion() == null) {
            return favoritosActuales;
        }

        return favoritosActuales;
    }

    /**
     * crea una entidad favorito.
     * @param dto dtoFavoritos
     */
    private Favoritos crearFavorito(DtoFavoritos dto) {
    	DDTipoEntidad tipoEntidad  = (DDTipoEntidad)executor.execute(
        		ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
        		DDTipoEntidad.class,
        		dto.getEntidadInformacion());

        Favoritos newFav = new Favoritos();
        newFav.setEntidadInformacion(tipoEntidad);
        newFav.setUsuario((Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO));
        newFav.setOrden(new Integer(1));
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad.getCodigo())) {
            Asunto asu = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, dto.getIdInformacion());
            newFav.setAsunto(asu);
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
            Persona per = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, dto.getIdInformacion());
            newFav.setPersona(per);
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {
            Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, dto.getIdInformacion());
            newFav.setExpediente(exp);
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) {
            Procedimiento prc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, dto.getIdInformacion());
            newFav.setProcedimiento(prc);
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(tipoEntidad.getCodigo())) {
            Contrato cnt = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, dto.getIdInformacion());
            newFav.setContrato(cnt);
        }
        return newFav;
    }

    /**
     * Guarda favoritos en la base de datos.
     * @param favoritos la tarea a guardar.
     */
    @BusinessOperation(ComunBusinessOperation.BO_FAVORITOS_MGR_SAVE_OR_UPDATE)
    public void saveOrUpdate(Favoritos favoritos) {
        favoritosDao.saveOrUpdate(favoritos);
    }

    /**
     * elimina todas la entradas de favoritos relacionadas con una entidad.
     * @param idEntidad id
     * @param tipoEntidad tipo entidad
     */
    @BusinessOperation(ComunBusinessOperation.BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD_ELIMINADA)
    @Transactional(readOnly = false)
    public void eliminarFavoritosPorEntidadEliminada(Long idEntidad, String tipoEntidad) {
        List<Favoritos> favoritos = favoritosDao.obtenerFavoritosEntidad(idEntidad, tipoEntidad);
        for (Favoritos fav : favoritos) {
            favoritosDao.delete(fav);
        }
    }

    /**
     * elimina todas la entradas de favoritos relacionadas con una entidad.
     * @param idUsuario id
     * @param idEntidad long
     * @param tipoEntidad string
     */
    @BusinessOperation(ComunBusinessOperation.BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD)
    @Transactional(readOnly = false)
    public void eliminarFavoritosUsuarioPorEntidad(Long idUsuario, Long idEntidad, String tipoEntidad) {
        DtoFavoritos dto = new DtoFavoritos();

        dto.setEntidadInformacion(tipoEntidad);
        dto.setIdInformacion(idEntidad);
        dto.setIdUsuario(idUsuario);

        favoritosDao.buscarYBorrarFavorito(dto);
    }
}
