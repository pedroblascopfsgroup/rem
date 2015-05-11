package es.pfsgroup.plugin.recovery.mejoras.favoritos.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.plugin.recovery.mejoras.favoritos.dao.MEJFavoritosDao;
import es.pfsgroup.plugin.recovery.mejoras.favoritos.dto.MEJDtoFavoritos;
import es.pfsgroup.plugin.recovery.mejoras.favoritos.model.MEJFavoritos;

/**
 * Clase de implementacion de FavoritosDao.
 * @author jbosnjak
 *
 */
@Repository("MEJFavoritosDao")
public class MEJFavoritosDaoImpl extends AbstractEntityDao<MEJFavoritos, Long> implements MEJFavoritosDao {

	public static final String CODIGO_ENTIDAD_BIEN = "8";
	public static final String CODIGO_ENTIDAD_ASUNTOND = "9";
	
    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<MEJFavoritos> obtenerFavoritosOrdenados() {
        UsuarioSecurity user = (UsuarioSecurity) SecurityUtils.getCurrentUser();
        String query = "select distinct fav from MEJFavoritos fav ";
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
        //bienes
        query += "or (fav.bien.id in (select bie.id from Bien bie where bie.auditoria.borrado = 0))";
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
    public List<MEJFavoritos> obtenerFavoritosEntidad(Long idEntidad, String tipoEntidad) {
        String query = "select distinct fav from MEJFavoritos fav ";
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
        } else if (CODIGO_ENTIDAD_BIEN.equals(tipoEntidad)) {
            query += " and fav.bien.id = ?";
        }
        query += " and fav.auditoria.borrado = false ";
        return getHibernateTemplate().find(query, idEntidad);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public void buscarYBorrarFavorito(MEJDtoFavoritos dto) {
        logger.debug("BUSCO SI YA ESTA EL FAVORITO");
        String buscarQuery = "from MEJFavoritos fav  where fav.usuario.id = " + dto.getIdUsuario();
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
        } else if (CODIGO_ENTIDAD_BIEN.equals(dto.getEntidadInformacion())) {
            buscarQuery += " and fav.bien.id = ?";
        } else if (CODIGO_ENTIDAD_ASUNTOND.equals(dto.getEntidadInformacion())) {
            buscarQuery += " and fav.asunto.id = ?";
        }
        buscarQuery += " and fav.auditoria.borrado = false ";
        List<MEJFavoritos> MEJfavoritos = getHibernateTemplate().find(buscarQuery, dto.getIdInformacion());
        if (MEJfavoritos.size() > 0) {
            delete(MEJfavoritos.get(0));
        }
    }
    
    
}
