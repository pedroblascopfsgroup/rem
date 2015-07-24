package es.pfsgroup.recovery.integration.bpm;

import java.util.Date;

import es.capgemini.pfs.integration.IntegrationClassCastException;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.recovery.integration.DataContainerPayload;

public class TareaNotificacionPayload {
	
	public final static String KEY = "@tar";
	
	private static final String CAMPO_FECHAINICIO = String.format("%s.fechaIni", KEY);
	private static final String CAMPO_FECHAFIN = String.format("%s.fechaFin", KEY);
	private static final String CAMPO_FECHAVENC = String.format("%s.fechaVenc", KEY);
	private static final String CAMPO_FECHAVENCREAL = String.format("%s.fechaVencR", KEY);
	private static final String CAMPO_PLAZO = String.format("%s.plazo", KEY);
	private static final String CAMPO_STA = String.format("%s.sta", KEY);
	private static final String CAMPO_TIPO_ENTIDAD = String.format("%s.tipoEntidad", KEY);
	private static final String CAMPO_ID_ENTIDAD = String.format("%s.idEntidad", KEY);

	private final DataContainerPayload data;
	private final AsuntoPayload asunto;
	private final UsuarioPayload usuario;

	public TareaNotificacionPayload(DataContainerPayload data) {
		this.data = data;
		this.asunto = new AsuntoPayload(data);
		this.usuario = new UsuarioPayload(data);
	}
	
	public TareaNotificacionPayload(String tipo, TareaNotificacion tarea) {
		this(new DataContainerPayload(null, null), tarea);
	}

	public TareaNotificacionPayload(DataContainerPayload data, TareaNotificacion tarea) {
		this.data = data;
		this.asunto = new AsuntoPayload(data, tarea.getAsunto());
		this.usuario = new UsuarioPayload(data, tarea);
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
		setTipoEntidad(tarNotif.getTipoEntidad().getCodigo());
		setCodigoSTA(tarNotif.getSubtipoTarea().getCodigoSubtarea());
		setPlazo(tarNotif.getPlazo());
		setDescripcion(tarNotif.getDescripcionTarea());
		setFechaInicio(tarNotif.getFechaInicio());
		setFechaFin(tarNotif.getFechaFin());
		setFechaVencimiento(tarNotif.getFechaVenc());
		setFechaVencimientoReal(tarNotif.getFechaVencReal());
	}


	private void setPlazo(Long plazo) {
		data.addNumber(CAMPO_PLAZO, plazo);
	}
	public Long getPlazo() {
		return data.getValLong(CAMPO_PLAZO);
	}

	private void setCodigoSTA(String codigoSubtarea) {
		data.addCodigo(CAMPO_STA, codigoSubtarea);
	}
	public String getCodigoSTA() {
		return data.getCodigo(CAMPO_STA);
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
	
	public UsuarioPayload getUsuario() {
		return usuario;
	}
	
}
