package es.pfsgroup.plugin.recovery.mejoras.asunto.manager;

import java.util.*;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.EXTAsuntoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecision;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecisionFinalizar;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.procedimiento.dao.EXTProcedimientoDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.registro.ModificacionAsuntoListener;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.model.Provisiones;
import es.pfsgroup.plugin.recovery.mejoras.asunto.api.MEJFinalizarAsuntoApi;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJFinalizarAsuntoDto;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

@Component
public class MEJFinalizarAsuntoManager implements MEJFinalizarAsuntoApi {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private Executor executor;

	@Autowired
	ApiProxyFactory proxyFactory;
	
	@Autowired
	private EXTAsuntoDao asuntoDao;
	
	@Autowired
	private EXTProcedimientoDao procedimientoDao;
	
	@Autowired
    private JBPMProcessManager jbpmUtil;	
	
	@Autowired
	private ModificacionAsuntoListener mejModAsuntoREG;

	@Override
	@BusinessOperation(MEJ_FINALIZAR_ASUNTO)
	@Transactional(readOnly = false)
	public void finalizarAsunto(MEJFinalizarAsuntoDto dto) {

		Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "id",
				dto.getIdAsunto());
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS,
				"auditoria.borrado", false);

		EXTAsunto asunto = genericDao.get(EXTAsunto.class, filtroId,
				filtroBorrado);
		
		Provisiones prov = genericDao.get(Provisiones.class, genericDao.createFilter(FilterType.EQUALS, "asunto.id", asunto.getId()), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		// Buscamos el estado procedimiento cerrado para asignarselo después al
		// procedimiento
		DDEstadoProcedimiento ep = genericDao.get(DDEstadoProcedimiento.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo",
						DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO));
		boolean error = false;
		for (Procedimiento proc : asunto.getProcedimientos()) {

			MEJDtoDecisionProcedimiento dtoDecisionProcedimiento = new MEJDtoDecisionProcedimiento();

			dtoDecisionProcedimiento.setIdProcedimiento(proc.getId());
			dtoDecisionProcedimiento.setFinalizar(true);
			dtoDecisionProcedimiento.setParalizar(false);
			dtoDecisionProcedimiento.setFechaParalizacion(dto
					.getFechaFinalizacion());
			dtoDecisionProcedimiento.setComentarios(dto.getObservaciones());
			
			//dtoDecisionProcedimiento.setCausaDecision(getCodigoCausaDecisionByDescripcion(dto.getMotivoFinalizacion()));
			dtoDecisionProcedimiento.setCausaDecisionFinalizar(getCodigoCausaDecisionByDescripcion(dto.getMotivoFinalizacion()));
			
			dtoDecisionProcedimiento.setStrEstadoDecision("02");

			DecisionProcedimiento decisionProcedimiento = (DecisionProcedimiento) executor
					.execute("decisionProcedimientoManager.getInstance",
							proc.getId());

			dtoDecisionProcedimiento
					.setDecisionProcedimiento(decisionProcedimiento);
			try {
				executor.execute(
						ExternaBusinessOperation.BO_DEC_PRC_MGR_ACEPTAR_PROPUESTA,
						dtoDecisionProcedimiento);

				// Cambiamos el estado del procedimiento a cerrado
				//proc.setEstadoProcedimiento(ep);
				genericDao.save(Procedimiento.class, proc);
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Ha habido un error al cerrar los procedimientos. "
						+ e);
				error = true;
			}
		}

		// Cuando haya finalizado todos los procedimientos, ahora ya se puede
		// cambiar el estado del asunto
		// Comprobamos que no haya habido ningún error
		if (!error) {
			//Estado Asunto por defecto = "Cerrado"
			DDEstadoAsunto estado = genericDao.get(DDEstadoAsunto.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo",
							DDEstadoAsunto.ESTADO_ASUNTO_CERRADO));
			
			//Se evalúa si existen provisiones -> Se establece estado = "Gestion finalizada"
			if ( prov != null && (Checks.esNulo(prov.getFechaBaja() )) ){
				estado = genericDao.get(DDEstadoAsunto.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDEstadoAsunto.ESTADO_ASUNTO_GESTION_FINALIZADA));
			}

			asunto.setEstadoAsunto(estado);
			try {
				genericDao.save(EXTAsunto.class, asunto);

				// Ahora vamos a eliminar todas las tareas asociadas al asunto
				Long idAsunto = asunto.getId();

				// Primero borramos las tareas externas del asunto
				Set<TareaNotificacion> listadoN = asunto.getTareas();
				for (TareaNotificacion tn : listadoN) {
					if (!Checks.esNulo(tn.getTareaExterna()))
						genericDao.deleteById(TareaExterna.class, tn
								.getTareaExterna().getId());
				}

				// Borramos todas las notificaciones del asunto
				List<TareaNotificacion> listadoNotificaciones = genericDao
						.getList(TareaNotificacion.class, genericDao
								.createFilter(FilterType.EQUALS, "asunto.id",
										idAsunto));
				for (TareaNotificacion tn : listadoNotificaciones) {
					genericDao.deleteById(TareaNotificacion.class, tn.getId());
				}

			} catch (Exception e) {
				e.printStackTrace();
				logger.error(e);
			}
		} else {
			logger.error("El asunto no se ha cerrado correctamente.");
		}

	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.mejoras.asunto.api.MEJFinalizarAsuntoApi#cancelaAsunto(es.capgemini.pfs.asunto.model.Asunto, java.util.Date)
	 */
	@Override
	@BusinessOperation(MEJ_CANCELAR_ASUNTO)
	public void cancelaAsunto(Asunto asunto, Date fechaCancelacion) {
		DDEstadoAsunto esAsuCancelado = genericDao.get(DDEstadoAsunto.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo",
						DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO));
		DDEstadoProcedimiento esPrcCerrado = genericDao.get(DDEstadoProcedimiento.class, 
				genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO));
		List<Procedimiento> procedimientos = asunto.getProcedimientos();
		for (Procedimiento procedimiento : procedimientos) {
			if ((!DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO.equals(procedimiento.getEstadoProcedimiento().getCodigo())) &&
				(!DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO.equals(procedimiento.getEstadoProcedimiento().getCodigo())))	 {
					procedimiento.setEstadoProcedimiento(esPrcCerrado);
					procedimientoDao.saveOrUpdate(procedimiento);
				}
		}

		if (DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO.equals(asunto.getEstadoAsunto().getCodigo())) { 
			
			Map<String, Object> mapCancelacion = new HashMap<String, Object>();
			mapCancelacion.put(ModificacionAsuntoListener.ID_ASUNTO, asunto.getId());
			mapCancelacion.put("FechaCancelacion", fechaCancelacion);

			mejModAsuntoREG.fireEvent(mapCancelacion);
			
			asunto.setEstadoAsunto(esAsuCancelado);	
			asuntoDao.saveOrUpdate(asunto);
		}

	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.mejoras.asunto.api.MEJFinalizarAsuntoApi#paralizaAsunto(es.capgemini.pfs.asunto.model.Asunto, java.util.Date)
	 */
	@Override
	@BusinessOperation(MEJ_PARALIZAR_ASUNTO)
	public void paralizaAsunto(Asunto asunto, Date fechaParalizacion) {
		List<Procedimiento> procedimientos = asunto.getProcedimientos();
		for (Procedimiento procedimiento : procedimientos) {
			if ((!DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO.equals(procedimiento.getEstadoProcedimiento().getCodigo())) &&
				(!DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO.equals(procedimiento.getEstadoProcedimiento().getCodigo()))) {
				
				MEJProcedimiento mejPrc = genericDao.get(MEJProcedimiento.class, 
						genericDao.createFilter(FilterType.EQUALS, "id", procedimiento.getId()));			
				
				Long idProcessBPM = mejPrc.getProcessBPM();
				if (!Checks.esNulo(idProcessBPM))
					jbpmUtil.aplazarProcesosBPM(idProcessBPM, fechaParalizacion);
                mejPrc.setEstaParalizado(true);
                mejPrc.setFechaUltimaParalizacion(fechaParalizacion);
                genericDao.save(MEJProcedimiento.class, mejPrc);
			}
		}
	}	
	
	/**
	 * M�todo que devuelve el c�digo de causa decisi�n a partir de la descripci�n de la causa
	 * @param descripcion
	 * @return codigo
	 */
	private String getCodigoCausaDecisionByDescripcion(String descripcion){
		if(!Checks.esNulo(descripcion)){
			
			//DDCausaDecision causa = genericDao.get(DDCausaDecision.class, genericDao.createFilter(FilterType.EQUALS, "descripcion", descripcion));
			DDCausaDecisionFinalizar causa = genericDao.get(DDCausaDecisionFinalizar.class, genericDao.createFilter(FilterType.EQUALS, "descripcion", descripcion));
			if(!Checks.esNulo(causa))
				return causa.getCodigo();
			return "";
		}
		return null;
	}

	// TODO Este método se creó en Lindorff, 
	// revisar y ver si se saca de aquí y del coreextension, de momento llamamos al cancelaAsunto 
	@Override
	public void cancelaAsuntoConMotivo(Asunto asunto, Date fechaCancelacion, String motivo) {
		this.cancelaAsunto(asunto, fechaCancelacion);		
	}

}
