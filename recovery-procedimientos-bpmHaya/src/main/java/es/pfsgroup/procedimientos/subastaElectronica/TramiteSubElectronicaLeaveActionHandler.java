package es.pfsgroup.procedimientos.subastaElectronica;

import java.util.Date;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;

public class TramiteSubElectronicaLeaveActionHandler extends PROGenericLeaveActionHandler {

	/**
	 * Serial ID
	 */
	private static final long serialVersionUID = 1L;
	
	private final String SALIDA_ETIQUETA = "DecisionRama_%d";
	private final String SALIDA_SI = "si";
	private final String SALIDA_NO = "no";
	private final String CODIGO_STA_LETRADO = "814";
	
	@SuppressWarnings("unused")
	private ExecutionContext executionContext;
	
	@Autowired
	protected GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private UsuarioApi usuarioApi;
	
	@Autowired
	TramitesElectronicosApi tramitesElectronicos;
	
	
	
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass,
			ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);

		personalizamosTramiteSubastaElectronica(executionContext);
	}

	

	private void personalizamosTramiteSubastaElectronica(ExecutionContext executionContext) {
		
		
		if (executionContext.getNode().getName().contains("RevisarDocumentacion")) {
			estableceContexto(executionContext);
		}
		
		if (executionContext.getNode().getName().contains("DictarInstruccionesSubastaYPagoTasa")) {
			estableceNotificacion(executionContext);
		}

	}
	
	/**
	 * Realiza la lógica principal de la clase.
	 * 
	 * @param executionContext
	 */
	private void estableceContexto(ExecutionContext executionContext) {
		Boolean[] valoresRamas = getValoresRamas(executionContext);
		for (int i = 0; i < valoresRamas.length; i++) {
			String variableName = String.format(SALIDA_ETIQUETA, i + 1);
			String valor = (valoresRamas[i]) ? SALIDA_SI : SALIDA_NO;
			executionContext.setVariable(variableName, valor);
		}
	}
	
	private void estableceNotificacion(ExecutionContext executionContext){
		Procedimiento prc = getProcedimiento(executionContext);
		String nombreTarea = executionContext.getNode().getName();
		crearNotificacionManual(prc,nombreTarea,"Se han dictado instrucciones y la autorización para proceder al pago de la tasa",CODIGO_STA_LETRADO);
	}
	
	private void crearNotificacionManual(Procedimiento prc, String nombreTarea, String descripcion, String codigoGestor){
		
		EXTTareaNotificacion notificacion = new EXTTareaNotificacion();
		notificacion.setProcedimiento(prc);
		notificacion.setAsunto(prc.getAsunto());
		notificacion.setEstadoItinerario(genericDao.get(DDEstadoItinerario.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoItinerario.ESTADO_ASUNTO)));
		
		SubtipoTarea subtipoTarea = genericDao.get(SubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", codigoGestor));
		
		if (subtipoTarea == null) {
			throw new GenericRollbackException("tareaNotificacion.subtipoTareaInexistente", codigoGestor);
		}

		notificacion.setEspera(Boolean.FALSE);
		notificacion.setAlerta(Boolean.FALSE);
		notificacion.setTarea(descripcion);
		notificacion.setDescripcionTarea(descripcion);
		notificacion.setCodigoTarea(subtipoTarea.getTipoTarea().getCodigoTarea());
		notificacion.setSubtipoTarea(subtipoTarea);
		
		DDTipoEntidad tipoEntidad = (DDTipoEntidad)diccionarioApi.dameValorDiccionarioByCod(DDTipoEntidad.class, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
		
		notificacion.setTipoEntidad(tipoEntidad);
		
		Date ahora = new Date(System.currentTimeMillis());
		
		notificacion.setFechaInicio(ahora);
		notificacion.setFechaVenc(ahora);
		notificacion.setFechaVencReal(ahora);
		notificacion.setFechaFin(ahora);
		notificacion.setTareaFinalizada(true);
		notificacion.setEmisor(usuarioApi.getUsuarioLogado().getApellidoNombre());
		
		Auditoria audit = new Auditoria();
		audit.setUsuarioCrear(usuarioApi.getUsuarioLogado().getApellidoNombre());
		audit.setFechaCrear(ahora);
		audit.setFechaBorrar(ahora);
		audit.setUsuarioBorrar(usuarioApi.getUsuarioLogado().getApellidoNombre());
		audit.setBorrado(true);
		
		notificacion.setAuditoria(audit);
		notificacion = genericDao.save(EXTTareaNotificacion.class, notificacion);

		TareaExterna tex = new TareaExterna();
		tex.setAuditoria(audit);
		tex.setTareaPadre(notificacion);
		
		if(!Checks.esNulo(nombreTarea)){
			tex.setTareaProcedimiento(genericDao.get(TareaProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", nombreTarea)));
		} else {
			tex.setTareaProcedimiento(genericDao.get(TareaProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "P458_DictarInstruccionesSubastaYPagoTasa")));
		}
		
		tex.setDetenida(false);
		
		genericDao.save(TareaExterna.class, tex);
		
	}

	/**
	 * Este método consultará todos los datos para determinar que
	 * caracteristicas tiene, y así devolver la rama correspondiente A, B, C
	 * 
	 * @return Array con los valores para decidir, uno por cada Rama en orden
	 *         0-Primera rama, 1-Segunda rama,...
	 */
	protected Boolean[] getValoresRamas(ExecutionContext executionContext) {
		Procedimiento proc = getProcedimiento(executionContext);

		Boolean[] valores = (Boolean[]) tramitesElectronicos.bpmGetValoresRamasRevisarDocumentacion(proc, getTareaExterna(executionContext));
		
		return valores;
	}

}
