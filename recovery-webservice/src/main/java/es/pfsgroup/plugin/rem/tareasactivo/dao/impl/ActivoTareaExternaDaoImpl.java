package es.pfsgroup.plugin.rem.tareasactivo.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.plugin.rem.tareasactivo.dao.ActivoTareaExternaDao;
import es.pfsgroup.recovery.ext.impl.multigestor.model.EXTGrupoUsuarios;

/**
 * Clase de acceso a datos de los trámites de Activo.
 * @author Daniel Gutiérrez
 */
@Repository("EXTActivoTareaNotificacionDao")
public class ActivoTareaExternaDaoImpl extends AbstractEntityDao<TareaExterna, Long> implements ActivoTareaExternaDao{
	
	@Autowired
	private MSVRawSQLDao rawDao;

	/**
	 * Devuelve las tareas asociadas a un trámite y que se encuentren activas para un usuario en particular
	 * @param idTramite el id del trámite
	 * @param usuarioLogado usuario logado en la aplicación, en caso de estar vacío devolverá todos
	 * @return la lista de tareas del trámite
	 */
    @Override
	public List<TareaExterna> getTareasTramite(Long idTramite, Usuario usuarioLogado, List<EXTGrupoUsuarios> grupos){
		
    	List<TareaExterna> listaTareas = new ArrayList<TareaExterna>();
		List<TareaExterna> listaTareasUsuarios = new ArrayList<TareaExterna>();
		List<TareaExterna> listaTareasSupervisor = new ArrayList<TareaExterna>();
		
		ArrayList<Long> usuarioYGrupo = new ArrayList<Long>();
		usuarioYGrupo.add(usuarioLogado.getId());
		if (!Checks.esNulo(grupos)){
			for (EXTGrupoUsuarios grupoUsuario : grupos){
				usuarioYGrupo.add(grupoUsuario.getGrupo().getId());
			}
		}
	
		
		// Obtenemos las tareas pendientes del usuario.
		HQLBuilder hb = new HQLBuilder("select tex from TareaExterna tex join tex.tareaPadre tac");			 

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.tramite.id", idTramite);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.tareaFinalizada", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.auditoria.borrado", false);
		HQLBuilder.addFiltroWhereInSiNotNull(hb, "tac.usuario.id", usuarioYGrupo);
		
		listaTareasUsuarios = HibernateQueryUtils.list(this, hb);
		
		
		// Obtenemos las tareas de las que el usuario es supervisor.
		HQLBuilder hbSupervisor = new HQLBuilder("select tex from TareaExterna tex join tex.tareaPadre tac ");			 

		HQLBuilder.addFiltroIgualQueSiNotNull(hbSupervisor, "tac.tramite.id", idTramite);
		HQLBuilder.addFiltroIgualQueSiNotNull(hbSupervisor, "tac.tareaFinalizada", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hbSupervisor, "tac.auditoria.borrado", false);
		HQLBuilder.addFiltroWhereInSiNotNull(hbSupervisor, "tac.supervisor.id", usuarioYGrupo);
		listaTareasSupervisor = HibernateQueryUtils.list(this, hbSupervisor);
		
		//Unimos los dos listados
		listaTareasUsuarios.addAll(listaTareasSupervisor);
		
		//Borramos duplicados (por si el usuario es el mismo que el supervisor)
		listaTareas = new ArrayList<TareaExterna>(new HashSet<TareaExterna>(listaTareasUsuarios));
		
		return listaTareas;
	}

	/**
	 * Devuelve las tareas asociadas a un trámite y que se encuentren activas
	 * @param idTramite el id del trámite
	 * @return la lista de tareas del trámite
	 */
    @Override
	public List<TareaExterna> getTareasTramiteTodas(Long idTramite){
	    
		List<TareaExterna> listaTareas = new ArrayList<TareaExterna>();
		
		// Obtenemos las tareas pendientes del usuario.
		HQLBuilder hb = new HQLBuilder("select tex from TareaExterna tex join tex.tareaPadre tac");			 
	
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.tramite.id", idTramite);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.tareaFinalizada", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.auditoria.borrado", false);
		
		listaTareas = HibernateQueryUtils.list(this, hb);
		
		return listaTareas;
	}


	/**
	 * Devuelve las tareas asociadas a un trámite
	 * @param idTramite el id del trámite
	 * @return la lista de tareas del trámite
	 */
    @Override
	public List<TareaExterna> getTareasTramiteHistorico(Long idTramite){
		
		List<TareaExterna> listaTareas = new ArrayList<TareaExterna>();
		HQLBuilder hb = new HQLBuilder("select tex from TareaExterna tex join tex.tareaPadre tac ");			 
		//HQLBuilder hb = new HQLBuilder("select tac from TareaActivo");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.tramite.id", idTramite);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.tareaFinalizada", false);
		hb.orderBy("tac.id", HQLBuilder.ORDER_ASC);
		
		listaTareas = HibernateQueryUtils.list(this, hb);
		
		if (listaTareas.isEmpty()) {
			HQLBuilder hql = new HQLBuilder("select tex from TareaExterna tex join tex.tareaPadre tac ");			 
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "tac.tramite.id", idTramite);
			hql.orderBy("tac.id", HQLBuilder.ORDER_ASC);
			
			listaTareas = HibernateQueryUtils.list(this, hql);
		}
		return listaTareas;
	}


	/**
	 * Devuelve las tareas asociadas a un trámite de un tipo de trámite
	 * @param idTramite el id del trámite
	 * @param idTareaProcedimiento el id del tipo de procedimiento
	 * @return la lista de tareas
	 */
    @Override
	public List<TareaExterna> getTareasTramiteTipo(Long idTramite, Long idTareaProcedimiento) {
		List<TareaExterna> listaTareas = new ArrayList<TareaExterna>();
		HQLBuilder hb = new HQLBuilder("select tex from TareaExterna tex join tex.tareaPadre tac ");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.tramite.id", idTramite);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tex.tareaProcedimiento.id", idTareaProcedimiento);
		hb.orderBy("tex.id", HQLBuilder.ORDER_DESC);
		
		listaTareas = HibernateQueryUtils.list(this, hb);
		
		return listaTareas;
	}
	
	/**
	 * Devuelve las tareas asociadas a un trámite de un tipo de trámite
	 * @param idTramite el id del trámite
	 * @param idTareaProcedimiento el id del tipo de procedimiento
	 * @return la lista de tareas
	 */
    @Override
    public List<TareaExterna> getTareasTramiteCodigoTipo(Long idTramite, String codigoTareaProcedimiento){
		List<TareaExterna> listaTareas = new ArrayList<TareaExterna>();
		HQLBuilder hb = new HQLBuilder("select tex from TareaExterna tex join tex.tareaPadre tac ");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.tramite.id", idTramite);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tex.tareaProcedimiento.codigo", codigoTareaProcedimiento);
		
		listaTareas = HibernateQueryUtils.list(this, hb);
		
		return listaTareas;
	}
    
    @Override
    @SuppressWarnings("unchecked")
    public List<TareaExternaValor> getByTareaExterna(Long idTareaExterna) {
        String hql = "from TareaExternaValor where tareaExterna.id= ?";

        List<TareaExternaValor> list = getHibernateTemplate().find(hql, new Object[] { idTareaExterna });
        return list;
    }
    
    @Override
    public List<Long> getTareasExternasIdByOfertaId(Long idOferta) {
    	
    	Map<String, Object> params = new HashMap<String, Object>();
		params.put("idOferta", idOferta);
		
		rawDao.addParams(params);
    	
    	List<Object> objetosLista = 
    			rawDao.getExecuteSQLList("SELECT TEX_ID "
    			+ "FROM TEX_TAREA_EXTERNA TEX "
    			+ "JOIN TAC_TAREAS_ACTIVOS TAC ON TAC.TAR_ID = TEX.TAR_ID "
    			+ "JOIN ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID "
    			+ "JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.TBJ_ID = TRA.TBJ_ID "
    			+ "WHERE ECO.OFR_ID = :idOferta");
    	
    	List<Long> tareasExternasId = new ArrayList<Long>();
    	
    	for(Object o:objetosLista){
    		String objetoString = o.toString();
    		tareasExternasId.add(Long.valueOf(objetoString));
    	}
    	
		return tareasExternasId;
    }
	/**
	 * Devuelve las tareas activas asociadas a un trámite de un tipo de trámite
	 * @param idTramite el id del trámite
	 * @param idTareaProcedimiento el id del tipo de procedimiento
	 * @return la lista de tareas activas
	 */
    @Override
    public List<Long> getTareasByIdOfertaCodigoTarea(Long idOferta,String codigoTareaProcedimiento) {
    	
    	//String idOfertaStr = String.valueOf(idOferta);
    	
    	Map<String, Object> params = new HashMap<String, Object>();
		params.put("idOferta", idOferta);
		params.put("codigoTareaProcedimiento", codigoTareaProcedimiento);
		
		rawDao.addParams(params);

    	List<Object> objetosLista = rawDao.getExecuteSQLList("SELECT TEX.TAR_ID "
    			+ "FROM TEX_TAREA_EXTERNA TEX "
    			+ "JOIN TAC_TAREAS_ACTIVOS TAC ON TAC.TAR_ID = TEX.TAR_ID "
    			+ "JOIN ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID "
    			+ "JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.TBJ_ID = TRA.TBJ_ID "
    			+ "JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID "
    			+ "WHERE ECO.OFR_ID = (SELECT OFR_ID FROM OFR_OFERTAS WHERE OFR_NUM_OFERTA= :idOferta) "
    			+ "AND UPPER(TAP.TAP_CODIGO) = UPPER (:codigoTareaProcedimiento) "
				+ "ORDER BY TEX.FECHACREAR DESC");
    	
    	List<Long> tareasExternasId = new ArrayList<Long>();
    	
    	for(Object o:objetosLista){
    		String objetoString = o.toString();
    		tareasExternasId.add(Long.valueOf(objetoString));
    	}
    	
		return tareasExternasId;
    }
    
    /**
	 * Devuelve las tareas activas asociadas a un trabajo de un tipo de trámite
	 * @param tbjNumTrabajo el número de trabajo (TBJ_NUM_TRABAJO)
	 * @param codigoTareaProcedimiento el codigo del tipo de procedimiento
	 * @return la lista de tareas activas
	 */
    @Override
    public List<Long> getTareasBytbjNumTrabajoCodigoTarea(Long tbjNumTrabajo,String codigoTareaProcedimiento) {
    	
    	//String idTrabajoStr = String.valueOf(tbjNumTrabajo);
    	
    	Map<String, Object> params = new HashMap<String, Object>();
		params.put("idTrabajo", tbjNumTrabajo);
		params.put("codigoTareaProcedimiento", codigoTareaProcedimiento);
		
		rawDao.addParams(params);
		
    	List<Object> objetosLista = rawDao.getExecuteSQLList("SELECT TEX.TAR_ID "
    			+ "FROM TEX_TAREA_EXTERNA TEX "
    			+ "JOIN TAC_TAREAS_ACTIVOS TAC ON TAC.TAR_ID = TEX.TAR_ID "
    			+ "JOIN ACT_TBJ_TRABAJO TBJ ON TBJ.ACT_ID = TAC.ACT_ID "
    			+ "JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID "
    			+ "JOIN TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID "
    			+ "WHERE TBJ.TBJ_NUM_TRABAJO = :idTrabajo "
    			+ "AND TBJ.BORRADO = 0 "
    			+ "AND TAP.BORRADO = 0 "
    			+ "AND TAR.BORRADO = 0 "
    			+ "AND TAR.TAR_TAREA_FINALIZADA = 0 "
    			+ "AND UPPER(TAP.TAP_CODIGO) = UPPER (:codigoTareaProcedimiento)");
    	
    	List<Long> tareasExternasId = new ArrayList<Long>();
    	
    	for(Object o:objetosLista){
    		String objetoString = o.toString();
    		tareasExternasId.add(Long.valueOf(objetoString));
    	}
    	
		return tareasExternasId;
    }

}