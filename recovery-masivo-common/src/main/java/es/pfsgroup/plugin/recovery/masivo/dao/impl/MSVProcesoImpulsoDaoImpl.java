package es.pfsgroup.plugin.recovery.masivo.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVProcesoImpulsoDao;

@SuppressWarnings("rawtypes")
@Repository("MSVProcesoImpulsoDao")
public class MSVProcesoImpulsoDaoImpl extends AbstractEntityDao implements
		MSVProcesoImpulsoDao {

	final static String CNT_EXTRA_CODIGO_PROPIETARIO = "char_extra3";

	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public String getPropietario(Long idContrato) {
		String resultado = "";
		
		try {
			Query q = getSession()
					.createQuery(
							" select iac.value FROM EXTInfoAdicionalContrato iac where iac.contrato.id =:contratoId "
									+ " and iac.tipoInfoContrato.codigo =:codigo ");
			q.setParameter("contratoId", idContrato);
			q.setParameter("codigo", CNT_EXTRA_CODIGO_PROPIETARIO);
			String codigoEntidadPropietaria = (String) q.uniqueResult();
			
			if (codigoEntidadPropietaria != null) {
				Query q2 = getSession().createQuery(
						"select pro.descripcionLarga FROM LINEntidadPropietaria pro where pro.codigo = :codigo ");
				q2.setParameter("codigo", codigoEntidadPropietaria);
				resultado = (String) q2.uniqueResult();
			}
		} catch (DataAccessResourceFailureException e) {
			logger.error("[MSVProcesoImpulsoDaoImpl:getPropietario]: DataAccessResourceFailureException: " + e.getLocalizedMessage() );
			//e.printStackTrace();
		} catch (HibernateException e) {
			logger.error("[MSVProcesoImpulsoDaoImpl:getPropietario]: HibernateException: " + e.getLocalizedMessage() );
			//e.printStackTrace();
		} catch (IllegalStateException e) {
			logger.error("[MSVProcesoImpulsoDaoImpl:getPropietario]: IllegalStateException: " + e.getLocalizedMessage() );
			//e.printStackTrace();
		}
		
		return resultado;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<EXTTareaExterna> obtenerListaTareasExternasAImpulsar(
			Long idTipoProcedimiento, Long idTareaProcedimiento, Long idDespacho) {

		List<EXTTareaExterna> listaResultado = new ArrayList<EXTTareaExterna>();
		
		try {
			Query q = getSession().createQuery(
				" FROM EXTTareaExterna tex where " 
						+ " tex.tareaPadre.procedimiento.tipoProcedimiento.id = :idTipoProcedimiento "
						+ " and tex.tareaProcedimiento.id = :idTareaProcedimiento "
						+ " and tex.tareaPadre.procedimiento.estaParalizado = 0 "
						+ " and tex.tareaPadre.procedimiento.asunto.id in ("
						+ "     select gaa.asunto.id from EXTGestorAdicionalAsunto gaa " 
						+ "            where gaa.gestor.despachoExterno.id = :idDespacho "
						+ "            and gaa.tipoGestor.codigo = '" + EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO + "')"
						+ " and tex.auditoria.borrado = 0 "
						+ " and tex.tareaPadre.procedimiento.auditoria.borrado = 0"
						+ " and tex.tareaPadre.auditoria.borrado = 0"
						+ " and tex.tareaPadre.tareaFinalizada is null"
						);
			q.setParameter("idTipoProcedimiento", idTipoProcedimiento);
			q.setParameter("idTareaProcedimiento", idTareaProcedimiento);
			q.setParameter("idDespacho", idDespacho);
			listaResultado =  q.list();
			
			// Sacar de la lista las tareas que pertenezcan a procedimientos paralizados
			//for (EXTTareaExterna tareaExterna : listaResultado) {
				//Obtener MEJProcedimiento a partir de 
			//}
			
		} catch (DataAccessResourceFailureException e) {
			logger.error("[MSVProcesoImpulsoDaoImpl:obtenerListaTareasExternasAImpulsar]: DataAccessResourceFailureException: " + e.getLocalizedMessage() );
			//e.printStackTrace();
		} catch (HibernateException e) {
			logger.error("[MSVProcesoImpulsoDaoImpl:obtenerListaTareasExternasAImpulsar]: HibernateException: " + e.getLocalizedMessage() );
			//e.printStackTrace();
		} catch (IllegalStateException e) {
			logger.error("[MSVProcesoImpulsoDaoImpl:obtenerListaTareasExternasAImpulsar]: IllegalStateException: " + e.getLocalizedMessage() );
			//e.printStackTrace();
		}
		return listaResultado;
	}

	@Override
	public String getInputPorDefecto(String descTarea) {
		String resultado = "";
		
		try {
			Query q = getSession()
					.createSQLQuery(
							" select tai.TAI_TIN_DESCRIPCION FROM DD_TAI_TAREA_INPUT tai where tai.TAI_TAR_DESCRIPCION =:descTarea ");
			q.setParameter("descTarea", descTarea);
			resultado = (String) q.uniqueResult();
		} catch (DataAccessResourceFailureException e) {
			logger.error("[MSVProcesoImpulsoDaoImpl:getInputPorDefecto]: DataAccessResourceFailureException: " + e.getLocalizedMessage() );
			//e.printStackTrace();
		} catch (HibernateException e) {
			logger.error("[MSVProcesoImpulsoDaoImpl:getInputPorDefecto]: HibernateException: " + e.getLocalizedMessage() );
			//e.printStackTrace();
		} catch (IllegalStateException e) {
			logger.error("[MSVProcesoImpulsoDaoImpl:getInputPorDefecto]: IllegalStateException: " + e.getLocalizedMessage() );
			//e.printStackTrace();
		}
		
		return resultado;	
	}

}
