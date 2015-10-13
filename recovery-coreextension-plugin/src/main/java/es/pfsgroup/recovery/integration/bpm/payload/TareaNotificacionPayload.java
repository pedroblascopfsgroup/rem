package es.pfsgroup.recovery.integration.bpm.payload;

import java.util.Date;

import es.capgemini.pfs.integration.IntegrationClassCastException;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.integration.DataContainerPayload;

public class TareaNotificacionPayload {
	
	public final static String KEY = "@tar";
	
	private static final String CAMPO_FECHAINICIO = String.format("%s.fechaIni", KEY);
	private static final String CAMPO_FECHAFIN = String.format("%s.fechaFin", KEY);
	private static final String CAMPO_FECHAVENC = String.format("%s.fechaVenc", KEY);
	private static final String CAMPO_FECHAVENCREAL = String.format("%s.fechaVencR", KEY);
	private static final String CAMPO_PLAZO = String.format("%s.plazo", KEY);
	private static final String CAMPO_STA = String.format("%s.sta", KEY);
	private static final String CAMPO_TAREA = String.format("%s.tarea", KEY);
	private static final String CAMPO_TIPO_ENTIDAD = String.format("%s.tipoEntidad", KEY);
	private static final String CAMPO_ID_ENTIDAD = String.format("%s.idEntidad", KEY);
	private static final String CAMPO_BORRADO = String.format("%s.borrado", KEY);

	private static final String CAMPO_PRORROGA_CAUSA = String.format("%s.prorroga.causa", KEY);
	private static final String CAMPO_PRORROGA_RESPUESTA = String.format("%s.prorroga.respuesta", KEY);
	private static final String CAMPO_PRORROGA_FECHA = String.format("%s.prorroga.fecha", KEY);
	private static final String CAMPO_PRORROGA_TAR_ASOCIADA = String.format("%s.prorroga.tarAsoc", KEY);
	
	private final DataContainerPayload data;

	private final AsuntoPayload asunto;

	public TareaNotificacionPayload(DataContainerPayload data) {
		this.data = data;
		this.asunto = new AsuntoPayload(data);
	}

	public DataContainerPayload getData() {
		return data;
	}
	
	public TareaNotificacionPayload(String tipo, TareaNotificacion tarea) {
		this(new DataContainerPayload(null, null), tarea);
	}

	public TareaNotificacionPayload(DataContainerPayload data, TareaNotificacion tarea) {
		this.data = data;
		this.asunto = new AsuntoPayload(data, tarea.getAsunto());
		build(tarea);
	}
	
	public AsuntoPayload getAsunto() {
		return asunto;
	}

	public void setId(Long valor) {
		data.addSourceId(KEY, valor);
	}
	public Long getId() {
		return data.getIdOrigen(KEY);
	}

	public void setGuid(String valor) {
		data.addGuid(KEY, valor);
	}
	public String getGuid() {
		return data.getGuid(KEY);
	}

	public void build(TareaNotificacion tarea) {
		EXTTareaNotificacion tarNotif = EXTTareaNotificacion.instanceOf(tarea);
		if (tarNotif==null) {
			throw new IntegrationClassCastException(EXTTareaNotificacion.class, tarea.getClass(), String.format("No se puede recuperar SYS_GUID para la Tarea notificación %d.", tarea.getId()));
		}
		
		setId(tarNotif.getId());
		setGuid(tarNotif.getGuid());

		setIdEntidadInformacion(tarNotif.getIdEntidad());
		
		if (tarNotif.getTipoEntidad().getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO)) {
			MEJProcedimiento prc = MEJProcedimiento.instanceOf(tarNotif.getProcedimiento());
			this.setGuidEntidad(prc.getGuid());
		} else if (tarNotif.getTipoEntidad().getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO)) {
			EXTAsunto asunto = EXTAsunto.instanceOf(tarNotif.getAsunto());
			this.setGuidEntidad(asunto.getGuid());
		}
		
		setTipoEntidad(tarNotif.getTipoEntidad().getCodigo());
		setSTACodigo(tarNotif.getSubtipoTarea().getCodigoSubtarea());
		setTarea(tarNotif.getTarea());
		setPlazo(tarNotif.getPlazo());
		setDescripcion(tarNotif.getDescripcionTarea());
		setFechaInicio(tarNotif.getFechaInicio());
		setFechaFin(tarNotif.getFechaFin());
		setFechaVencimiento(tarNotif.getFechaVenc());
		setFechaVencimientoReal(tarNotif.getFechaVencReal());
		setBorrada(tarNotif.getAuditoria().isBorrado());

		if (tarNotif.getProrroga()!=null) {
			this.setProrrogaFecha(tarNotif.getProrroga().getFechaPropuesta());
			TareaNotificacion tarNotifAsoc = tarNotif.getProrroga().getTareaAsociada();
			EXTTareaNotificacion tarAsociada = EXTTareaNotificacion.instanceOf(tarNotifAsoc);
			this.setGuidTareaAsociadaProrroga(tarAsociada.getGuid());
			this.setIdTareaAsociadaProrroga(tarAsociada.getId());
			if (tarNotif.getProrroga().getCausaProrroga()!=null)
				this.setProrrogaCausa(tarNotif.getProrroga().getCausaProrroga().getCodigo());
			if (tarNotif.getProrroga().getRespuestaProrroga()!=null)
				this.setProrrogaRespuesta(tarNotif.getProrroga().getRespuestaProrroga().getCodigo());
		}

	}

	private void setPlazo(Long plazo) {
		data.addNumber(CAMPO_PLAZO, plazo);
	}
	public Long getPlazo() {
		return data.getValLong(CAMPO_PLAZO);
	}

	private void setSTACodigo(String codigoSubtarea) {
		data.addCodigo(CAMPO_STA, codigoSubtarea);
	}
	public String getSTACodigo() {
		return data.getCodigo(CAMPO_STA);
	}

	private void setTarea(String valor) {
		data.addCodigo(CAMPO_TAREA, valor);
	}
	public String getTarea() {
		return data.getCodigo(CAMPO_TAREA);
	}

	private void setTipoEntidad(String codigo) {
		data.addCodigo(CAMPO_TIPO_ENTIDAD, codigo);
	}
	public String getTipoEntidad() {
		return data.getCodigo(CAMPO_TIPO_ENTIDAD);
	}

	private void setIdEntidadInformacion(Long idEntidad) {
		data.addSourceId(CAMPO_ID_ENTIDAD, idEntidad);
	}
	public Long getIdEntidadInformacion() {
		return data.getIdOrigen(CAMPO_ID_ENTIDAD);
	}

	private void setGuidEntidad(String guid) {
		data.addGuid(CAMPO_ID_ENTIDAD, guid);
	}
	public String getGuidEntidad() {
		return data.getGuid(CAMPO_ID_ENTIDAD);
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
	
	private void setGuidTareaAsociadaProrroga(String valor) {
		data.addGuid(CAMPO_PRORROGA_TAR_ASOCIADA, valor);
	}

	public String getGuidTareaAsociadaProrroga() {
		return data.getGuid(CAMPO_PRORROGA_TAR_ASOCIADA);
	}

	private void setIdTareaAsociadaProrroga(Long valor) {
		data.addSourceId(CAMPO_PRORROGA_TAR_ASOCIADA, valor);
	}

	public Long getIdTareaAsociadaProrroga() {
		return data.getIdOrigen(CAMPO_PRORROGA_TAR_ASOCIADA);
	}
	
	private void setProrrogaFecha(Date fecha) {
		data.addFecha(CAMPO_PRORROGA_FECHA, fecha);
	}

	public Date getProrrogaFecha() {
		return data.getFecha(CAMPO_PRORROGA_FECHA);
	}
	
	private void setProrrogaCausa(String valor) {
		data.addCodigo(CAMPO_PRORROGA_CAUSA, valor);
	}

	public String getProrrogaCausa() {
		return data.getCodigo(CAMPO_PRORROGA_CAUSA);
	}

	private void setProrrogaRespuesta(String valor) {
		data.addCodigo(CAMPO_PRORROGA_RESPUESTA, valor);
	}

	public String getProrrogaRespuesta() {
		return data.getCodigo(CAMPO_PRORROGA_RESPUESTA);
	}
	
	public boolean contieneProrroga() {
		return data.getCodigo().containsKey(CAMPO_PRORROGA_CAUSA) 
				//&& data.getCodigo().containsKey(CAMPO_PRORROGA_RESPUESTA)
				&& data.getFecha().containsKey(CAMPO_PRORROGA_FECHA);
	}

	private void setBorrada(boolean valor) {
		data.addFlag(CAMPO_BORRADO, valor);
	}

	public boolean getBorrada() {
		return data.getFlag(CAMPO_BORRADO);
	}
	
	
}
