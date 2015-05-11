package es.capgemini.pfs.procesosJudiciales.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.dao.EXTTareaExternaDao;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;

@Repository("EXTTareaExternaDao")
public class EXTTareaExternaDaoImpl extends AbstractEntityDao<EXTTareaExterna, Long> implements EXTTareaExternaDao {

	@Autowired
	private EXTGrupoUsuariosDao grupoUsuarioDao;
	
    @Override
    public List<EXTTareaExterna> buscaTareasPorTipoGestorYProcedimiento(Long idProcedimiento) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public List<? extends TareaExterna> obtenerTareasGestorConfeccionExpediente(Long idProcedimiento) {

        List<TareaExterna> ls = null;
        try {
            ls = getHibernateTemplate()
                    .find("from TareaExterna where tareaPadre.procedimiento.id = ? AND tareaPadre.subtipoTarea.codigoSubtarea = ? AND detenida = 0 AND auditoria.borrado = 0 ORDER BY tareaPadre.auditoria.fechaCrear DESC",
                            new Object[] { idProcedimiento, EXTSubtipoTarea.CODIGO_TAREA_GESTOR_CONFECCION_EXPTE });
        } catch (DataAccessException e) {
            logger.error(e);
        }
        return ls;
    }

    @Override
    public List<? extends TareaExterna> obtenerTareasSupervisorConfeccionExpediente(Long idProcedimiento) {
        List<TareaExterna> ls = null;
        try {
            ls = getHibernateTemplate()
                    .find("from TareaExterna where tareaPadre.procedimiento.id = ? AND tareaPadre.subtipoTarea.codigoSubtarea = ? AND detenida = 0 AND auditoria.borrado = 0 ORDER BY tareaPadre.auditoria.fechaCrear DESC",
                            new Object[] { idProcedimiento, EXTSubtipoTarea.CODIGO_TAREA_SUPERVISOR_CONFECCION_EXPTE });
        } catch (DataAccessException e) {
            logger.error(e);
        }
        return ls;
    }

    @Override
    public List<? extends TareaExterna> obtenerTareasPorSubtipoTareaYProcedimiento(Long idProcedimiento, String codSubTarea) {
        List<TareaExterna> ls = null;
        try {
            Query q = getHibernateTemplate()
                    .getSessionFactory()
                    .getCurrentSession()
                    .createQuery(
                            "select tex from TareaExterna tex where tex.tareaPadre.procedimiento.id = :idP AND tex.tareaPadre.subtipoTarea.codigoSubtarea = :cod AND detenida = 0 AND auditoria.borrado = 0 ORDER BY tareaPadre.auditoria.fechaCrear DESC");
            q.setParameter("idP", idProcedimiento);
            q.setParameter("cod", codSubTarea);

            ls = q.list();
            // ls = getHibernateTemplate()
            // .getSessionFactory().getCurrentSession().createQuery(queryString)find(
            // "from TareaExterna where tareaPadre.procedimiento.id = ? AND tareaPadre.subtipoTarea.codigoSubtarea = ? AND detenida = 0 AND auditoria.borrado = 0 ORDER BY tareaPadre.auditoria.fechaCrear DESC",
            // new Object[] { idProcedimiento,codSubTarea });
        } catch (DataAccessException e) {
            logger.error(e);
        }
        return ls;
    }

    @Override
    public List<? extends TareaExterna> obtenerTareasPorUsuarioYProcedimientoConOptimizacion(Long idUsuario, Long idProcedimiento) {
    	List<Long> id = new ArrayList<Long>();
    	id.add(idProcedimiento);
    	return obtenerTareasPorUsuarioYProcedimientoConOptimizacion(idUsuario, id);
    }
    
    @Override
    public List<? extends TareaExterna> obtenerTareasPorUsuarioYProcedimientoConOptimizacion(Long idUsuario, List<Long> idProcedimientos) {
    	Usuario u = new Usuario();
    	String hqlUsuario = "";
    	if (!Checks.esNulo(idUsuario)) {
    		u.setId(idUsuario);
    		hqlUsuario = " (usuarioPendiente=:usu or usuarioPendiente in (select grp.grupo.id from EXTGrupoUsuarios grp where grp.usuario.id=:usu)) and ";
    	}
    	/*List<Long> grupos = grupoUsuarioDao.buscaGruposUsuario(u);
    	grupos.add(idUsuario); // incluimos el usuario
    	StringBuilder listaIdUsuarios = new StringBuilder();
    	String sep = "";
    	for (Long str : grupos) {
    		listaIdUsuarios.append(sep).append(str);
    	    sep = ",";
    	}
    	 */
    	Query q = getHibernateTemplate()
                .getSessionFactory()
                .getCurrentSession()
                .createQuery(
                        "select tex from TareaExterna tex where tex.tareaPadre.id in (select id from VTARTareaVsUsuario where " + hqlUsuario + " tipoEntidadCodigo = :ent and idEntidad in (:id))");
    	if (!Checks.esNulo(idUsuario)) {
    		q.setParameter("usu", idUsuario);
    	}
        q.setParameter("ent", DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
        q.setParameterList("id", idProcedimientos);
        
        return q.list();
    }

}
