package es.pfsgroup.recovery.integration.bpm.payload;

import java.util.Date;

import es.capgemini.pfs.integration.IntegrationClassCastException;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.bpm.DiccionarioDeCodigos;

public class TareaExternaPayload {
	
	public final static String KEY_TAP_TAREA = "@tap";
	public final static String KEY_TEX_TAREA = "@tex";
	public final static String KEY_TAR_TAREA = "@tar";
	
	private static final String CAMPO_FECHAINICIO = String.format("%s.fechaIni", KEY_TAR_TAREA);
	private static final String CAMPO_FECHAFIN = String.format("%s.fechaFin", KEY_TAR_TAREA);;
	private static final String CAMPO_FECHAVENC = String.format("%s.fechaVenc", KEY_TAR_TAREA);;
	private static final String CAMPO_FECHAVENCREAL = String.format("%s.fechaVencR", KEY_TAR_TAREA);

	private static final String CAMPO_PREFIJOCAMPOFORMULARIO = String.format("%s.@tfi", KEY_TEX_TAREA);

	private final DataContainerPayload data;
	private final ProcedimientoPayload procedimiento;

	public TareaExternaPayload(DataContainerPayload data) {
		this.data = data;
		this.procedimiento = new ProcedimientoPayload(data);
	}
	
	public TareaExternaPayload(String tipo, TareaExterna tareaExterna) {
		this(new DataContainerPayload(null, null), tareaExterna);
	}

	public TareaExternaPayload(DataContainerPayload data, TareaExterna tareaExterna) {
		this.data = data;
		this.procedimiento = new ProcedimientoPayload(data, tareaExterna.getTareaPadre().getProcedimiento());
		build(tareaExterna);
	}

	public DataContainerPayload getData() {
		return data;
	}

	public ProcedimientoPayload getProcedimiento() {
		return procedimiento;
	}

	public Long getIdTEXTarea() {
		return data.getIdOrigen(KEY_TEX_TAREA);
	}

	public Long getIdTARTarea() {
		return data.getIdOrigen(KEY_TAR_TAREA);
	}
	
	public String getCodigoTAPTarea() {
		return data.getCodigo(KEY_TAP_TAREA);
	}

	private void setCodigoTAPTarea(String valor) {
		data.addCodigo(KEY_TAP_TAREA, valor);
	}
	
	public String getGuidTARTarea() {
		return data.getGuid(KEY_TAR_TAREA);
	}

	public void build(TareaExterna tarea) {
		EXTTareaNotificacion tarNotif = EXTTareaNotificacion.instanceOf(tarea.getTareaPadre());
		if (tarNotif==null) {
			throw new IntegrationClassCastException(EXTTareaNotificacion.class, tarea.getTareaPadre().getClass(), String.format("No se puede recuperar SYS_GUID para la Tarea externa %d.", tarea.getId()));
		}
		
		TareaProcedimiento tareaProcedimiento = tarea.getTareaProcedimiento();

		data.addSourceId(KEY_TEX_TAREA, tarea.getId());
		setCodigoTAPTarea(tareaProcedimiento.getCodigo());

		build(tarNotif);
	}

	public void build(EXTTareaNotificacion tarNotif) {
		// Tarea
		data.addSourceId(KEY_TAR_TAREA, tarNotif.getId());
		data.addGuid(KEY_TAR_TAREA, tarNotif.getGuid());

		setDescripcion(tarNotif.getDescripcionTarea());
		setFechaInicio(tarNotif.getFechaInicio());
		setFechaFin(tarNotif.getFechaFin());
		setFechaVencimiento(tarNotif.getFechaVenc());
		setFechaVencimientoReal(tarNotif.getFechaVencReal());

	}
	
	public void translate(DiccionarioDeCodigos diccionarioCodigos) {
		String valor;
		
		if (procedimiento != null) {
			procedimiento.translate(diccionarioCodigos);
		}
		
		//
		valor = getCodigoTAPTarea();
		valor = diccionarioCodigos.getCodigoTareaFinal(valor);
		setCodigoTAPTarea(valor);
		
	}

	private void setDescripcion(String descripcionTarea) {
		data.setDescripcion(descripcionTarea);
	}

	public String getDescripcion() {
		return data.getDescripcion();
	}
	
	private void setFechaVencimiento(Date fechaVenc) {
		data.addFecha(CAMPO_FECHAVENC, fechaVenc);
	}

	private void setFechaInicio(Date fechaInicio) {
		data.addFecha(CAMPO_FECHAINICIO, fechaInicio);
	}

	private void setFechaFin(Date fechaFin) {
		data.addFecha(CAMPO_FECHAFIN, fechaFin);
	}

	private void setFechaVencimientoReal(Date fechaVencReal) {
		data.addFecha(CAMPO_FECHAVENCREAL, fechaVencReal);
	}

	public Date getFechaInicio() {
		return data.getFecha(CAMPO_FECHAINICIO);
	}

	public Date getFechaFin() {
		return data.getFecha(CAMPO_FECHAFIN);
	}
	
	public Date getFechaVencimiento() {
		return data.getFecha(CAMPO_FECHAVENC);
	}
	
	public Date getFechaVencimientoReal() {
		return data.getFecha(CAMPO_FECHAVENCREAL);
	}
	
	public boolean contieneValorParaCampo(String campo) {
		return data.getExtraInfo().containsKey(String.format("%s.%s", CAMPO_PREFIJOCAMPOFORMULARIO, campo));
	}

	public String getValorCampoFormulario(String campo) {
		return (contieneValorParaCampo(campo)) 
				? data.getExtraInfo(String.format("%s.%s", CAMPO_PREFIJOCAMPOFORMULARIO, campo)) 
				: null; 
	}
	
	public void setValorCampoFormulario(String campo, String valor) {
		data.addExtraInfo(String.format("%s.%s", CAMPO_PREFIJOCAMPOFORMULARIO, campo), valor); 
	}

}
