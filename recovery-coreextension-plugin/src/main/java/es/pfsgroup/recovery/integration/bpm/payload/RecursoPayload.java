package es.pfsgroup.recovery.integration.bpm.payload;

import java.util.Date;

import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;
import es.pfsgroup.recovery.integration.DataContainerPayload;

public class RecursoPayload {
	
	public final static String KEY_RECURSO = "@rec";

	private static final String CAMPO_ESGESTOR = String.format("%s.esGestor", KEY_RECURSO);
	private static final String CAMPO_ESSUPERVISOR = String.format("%s.esSupervisor", KEY_RECURSO);
	private static final String CAMPO_RESULTADORESOLUCION = String.format("%s.resultadoResolucion", KEY_RECURSO);
	private static final String CAMPO_CAUSARECURSO = String.format("%s.causaRecurso", KEY_RECURSO);
	private static final String CAMPO_TIPORECURSO = String.format("%s.tipoRecurso", KEY_RECURSO);
	private static final String CAMPO_ACTOR = String.format("%s.actor", KEY_RECURSO);
	private static final String CAMPO_FECHARECURSO = String.format("%s.fechaRecurso", KEY_RECURSO);
	private static final String CAMPO_FECHAIMPUGNACION = String.format("%s.fechaImpugnacion", KEY_RECURSO);
	private static final String CAMPO_FECHAVISTA = String.format("%s.fechaVista", KEY_RECURSO);
	private static final String CAMPO_FECHARESOLUCION = String.format("%s.fechaResolucion", KEY_RECURSO);
	private static final String CAMPO_OBSERVACIONES = String.format("%s.observaciones", KEY_RECURSO);
	private static final String CAMPO_CONF_IMPUGNACION = String.format("%s.confirmarImpugnacion", KEY_RECURSO);
	private static final String CAMPO_CONF_VISTA = String.format("%s.confirmarVista", KEY_RECURSO);
	private static final String CAMPO_SUSPENSIVO = String.format("%s.suspensivo", KEY_RECURSO);
	

	private final DataContainerPayload data;
	private final ProcedimientoPayload procedimiento;

	public RecursoPayload(DataContainerPayload data) {
		this.data = data;
		this.procedimiento = new ProcedimientoPayload(data);
	}
	
	public RecursoPayload(String tipo, MEJRecurso recurso) {
		this(new DataContainerPayload(null, null), recurso);
	}
	
	public RecursoPayload(DataContainerPayload data, MEJRecurso recurso) {
		this.data = data;
		this.procedimiento = new ProcedimientoPayload(data, recurso.getProcedimiento());
		build(recurso);
	}

	public ProcedimientoPayload getProcedimiento() {
		return procedimiento;
	}

	public void build(MEJRecurso recurso) {
		
		setSourceId(recurso.getId());
		setGuid(recurso.getGuid());
		
		/*
		if (recurso.getTareaNotificacion()!=null) {
			EXTTareaNotificacion tareaNotificacion = setup4sync(recurso.getTareaNotificacion());
			payload.addGuid(Payload.KEY_TAR_TAREA, tareaNotificacion.getGuid());
			payload.addSourceId(Payload.KEY_TAR_TAREA, tareaNotificacion.getId());
		}*/
		
		if (recurso.getActor()!=null) {
			setActor(recurso.getActor().getCodigo());
		}
		if (recurso.getTipoRecurso()!=null) {
			setTipoRecurso(recurso.getTipoRecurso().getCodigo());
		}
		if (recurso.getCausaRecurso()!=null) {
			setCausaRecurso(recurso.getCausaRecurso().getCodigo());
		}
		if (recurso.getResultadoResolucion()!=null) {
			setResultadoResolucion(recurso.getResultadoResolucion().getCodigo());
		}
		if (recurso.getTareaNotificacion()!=null) {
			EXTTareaNotificacion tarNotif = (EXTTareaNotificacion)recurso.getTareaNotificacion();
			setGuidTARTarea(tarNotif.getGuid());
		}

		data.addFecha(CAMPO_FECHARECURSO, recurso.getFechaRecurso());
		data.addFecha(CAMPO_FECHAIMPUGNACION, recurso.getFechaImpugnacion());
		data.addFecha(CAMPO_FECHAVISTA, recurso.getFechaVista());
		data.addFecha(CAMPO_FECHARESOLUCION, recurso.getFechaResolucion());
		data.addExtraInfo(CAMPO_OBSERVACIONES, recurso.getObservaciones());
		
		data.addFlag(CAMPO_CONF_IMPUGNACION, recurso.getConfirmarImpugnacion());
		data.addFlag(CAMPO_CONF_VISTA, recurso.getConfirmarVista());
		data.addFlag(CAMPO_SUSPENSIVO, recurso.getSuspensivo());
		
	}

	private void setGuidTARTarea(String guid) {
		data.addGuid(String.format("%s%s", KEY_RECURSO, TareaExternaPayload.KEY_TAR_TAREA), guid);
	}

	private void setResultadoResolucion(String codigo) {
		data.addCodigo(CAMPO_RESULTADORESOLUCION, codigo);
	}
	public String getResuladoResolucion() {
		return data.getCodigo(CAMPO_RESULTADORESOLUCION);	}

	private void setCausaRecurso(String codigo) {
		data.addCodigo(CAMPO_CAUSARECURSO, codigo);
	}

	public String getCausaRecurso() {
		return data.getCodigo(CAMPO_CAUSARECURSO);
	}

	private void setTipoRecurso(String codigo) {
		data.addCodigo(CAMPO_TIPORECURSO, codigo);
	}
	public String getTipoRecurso() {
		return data.getCodigo(CAMPO_TIPORECURSO);
	}

	private void setActor(String codigo) {
		data.addCodigo(CAMPO_ACTOR, codigo);		
	}
	public String getActor() {
		return data.getCodigo(CAMPO_ACTOR);
	}

	private void setSourceId(Long id) {
		data.addSourceId(KEY_RECURSO, id);
	}
	public Long getIdOrigen() {
		return data.getIdOrigen(KEY_RECURSO);
	}
	
	private void setGuid(String guid) {
		data.addGuid(KEY_RECURSO, guid);
	}
	public String getGuid() {
		return data.getGuid(KEY_RECURSO);
	}

	public void setEsGestor(boolean esGestor) {
		data.addFlag(CAMPO_ESGESTOR, esGestor);
	}
	public boolean esGestor() {
		return data.getFlag().containsKey(CAMPO_ESGESTOR) ? data.getFlag(CAMPO_ESGESTOR) : false;
	}
	
	public void setEsSupervisor(boolean esSupervisor) {
		data.addFlag(CAMPO_ESSUPERVISOR, esSupervisor);
	}
	public boolean esSupervisor() {
		return data.getFlag().containsKey(CAMPO_ESSUPERVISOR) ? data.getFlag(CAMPO_ESSUPERVISOR) : false;
	}

	public Date getFechaImpugnacion() {
		return data.getFecha(CAMPO_FECHAIMPUGNACION);
	}

	public Date getFechaRecurso() {
		return data.getFecha(CAMPO_FECHARECURSO);
	}

	public Date getFechaVista() {
		return data.getFecha(CAMPO_FECHAVISTA);
	}

	public Date getFechaResolucion() {
		return data.getFecha(CAMPO_FECHARESOLUCION);
	}

	public String getObservaciones() {
		return data.getExtraInfo(CAMPO_OBSERVACIONES);
	}

	public Boolean getConfirmarVista() {
		return data.getFlag(CAMPO_CONF_VISTA);
	}

	public Boolean getConfirmarImpugnacion() {
		return data.getFlag(CAMPO_CONF_IMPUGNACION);
	}

	public Boolean isSuspensivo() {
		return data.getFlag(CAMPO_SUSPENSIVO);
	}

}
