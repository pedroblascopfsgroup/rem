package es.capgemini.pfs.favoritos.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.favoritos.dao.FavoritosDao;
import es.capgemini.pfs.favoritos.dto.DtoFavoritos;
import es.capgemini.pfs.favoritos.model.Favoritos;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

/**
 * Clase de implementacion de FavoritosDao.
 * @author jbosnjak
 *
 */
@Repository("FavoritosDao")
public class FavoritosDaoImpl extends AbstractEntityDao<Favoritos, Long> implements FavoritosDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Favoritos> obtenerFavoritosOrdenados() {
        UsuarioSecurity user = (UsuarioSecurity) SecurityUtils.getCurrentUser();
        String query = "select distinct fav from Favoritos fav ";
        query += " where fav.usuario.id = ?";
        query += " and ( ";
        //expediente
        query += "(fav.expediente.id in (select exp.id from Expediente exp where exp.auditoria.borrado = 0))";
        //persona
        query += "or (fav.persona.id in (select per.id from Persona per where per.auditoria.borrado = 0))";
        //procedimiento
        query += "or (fav.procedimiento.id in (select prc.id from Procedimiento prc where prc.auditoria.borrado = 0))";
        //asuntos
        query += "or (fav.asunto.id in (select asu.id from Asunto asu where asu.auditoria.borrado = 0))";
        //query += " ) ";
        //contratos
        query += "or (fav.contrato.id in (select cnt.id from Contrato cnt where cnt.auditoria.borrado = 0))";
        query += " ) ";
        query += " and fav.auditoria.borrado = false order by fav.id desc ";
        return getHibernateTemplate().find(query, user.getId());
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Favoritos> obtenerFavoritosEntidad(Long idEntidad, String tipoEntidad) {
        String query = "select distinct fav from Favoritos fav ";
        query += " where fav.entidadInformacion.codigo = " + tipoEntidad;
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad)) {
            query += " and fav.asunto.id = ?";
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
            query += " and fav.expediente.id = ?";
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad)) {
            query += " and fav.persona.id = ?";
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad)) {
            query += " and fav.procedimiento.id = ?";
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(tipoEntidad)) {
            query += " and fav.contrato.id = ?";
        }
        query += " and fav.auditoria.borrado = false ";
        return getHibernateTemplate().find(query, idEntidad);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public void buscarYBorrarFavorito(DtoFavoritos dto) {
        logger.debug("BUSCO SI YA ESTA EL FAVORITO");
        String buscarQuery = "from Favoritos fav  where fav.usuario.id = " + dto.getIdUsuario();
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(dto.getEntidadInformacion())) {
            buscarQuery += " and fav.asunto.id = ?";
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(dto.getEntidadInformacion())) {
            buscarQuery += " and fav.expediente.id = ?";
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(dto.getEntidadInformacion())) {
            buscarQuery += " and fav.persona.id = ?";
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(dto.getEntidadInformacion())) {
            buscarQuery += " and fav.procedimiento.id = ?";
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(dto.getEntidadInformacion())) {
            buscarQuery += " and fav.contrato.id = ?";
        }
        buscarQuery += " and fav.auditoria.borrado = false ";
        List<Favoritos> favoritos = getHibernateTemplate().find(buscarQuery, dto.getIdInformacion());
        if (favoritos.size() > 0) {
            delete(favoritos.get(0));
        }
    }
}
