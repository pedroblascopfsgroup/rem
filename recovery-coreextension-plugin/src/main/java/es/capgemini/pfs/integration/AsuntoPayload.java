package es.capgemini.pfs.integration;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.sun.net.ssl.internal.ssl.SSLContextImpl;

import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

public class AsuntoPayload extends DataContainerPayload {
	
	public static final String JBPM_TAR_GUID_ORIGEN = "tar-guid-origen";
	public static final String JBPM_TRANSICION = "transicion";
	
	public final static String KEY_ASUNTO = "asu";
	public final static String KEY_PROCEDIMIENTO = "prc";
	public final static String KEY_PROCEDIMIENTO_PADRE = "prc.padre";
	public final static String KEY_TAP_TAREA = "tap";
	public final static String KEY_TEX_TAREA = "tex";
	public final static String KEY_TAR_TAREA = "tar";
	public final static String KEY_TFI_FORM_ITEM = "tfi";

	@JsonCreator
	public AsuntoPayload(@JsonProperty("tipo") String tipo,
			@JsonProperty("codigo") Map<String, String> codigo,
			@JsonProperty("guid") Map<String, String> guid,
			@JsonProperty("idOrigen") Map<String, Long> idOrigen,
			@JsonProperty("fecha") Map<String, Date> fecha,
			@JsonProperty("flag") Map<String, Boolean> flag,
			@JsonProperty("valBDec") Map<String, BigDecimal> valBDec,
			@JsonProperty("valDouble") Map<String, Double> valDouble,
			@JsonProperty("valInt") Map<String, Integer> valInt,
			@JsonProperty("valLong") Map<String, Long> valLong
			) {
		super(tipo, codigo, guid, idOrigen, fecha, flag, valBDec, valDouble, valInt, valLong);
	}

	public AsuntoPayload(String tipo, EXTAsunto asunto) {
		super(tipo);
		build(asunto);
	}
	
	public void build(EXTAsunto asunto) {
		addGuid(KEY_ASUNTO, asunto.getGuid());
		addSourceId(KEY_ASUNTO, asunto.getId());
	}
	
	
	public void build(MEJProcedimiento procedimiento, MEJProcedimiento procedimientoPadre) {
		if (procedimiento!=null) {
			addSourceId(KEY_PROCEDIMIENTO, procedimiento.getId());
			addCodigo(KEY_PROCEDIMIENTO, procedimiento.getTipoProcedimiento().getCodigo());
			addGuid(KEY_PROCEDIMIENTO, procedimiento.getGuid());
			if (procedimiento.getTipoActuacion()!=null) {
				addCodigo(String.format("%s.tipoActuacion", KEY_PROCEDIMIENTO), procedimiento.getTipoActuacion().getCodigo()); 
			}
			if (procedimiento.getTipoReclamacion()!=null) {
				addCodigo(String.format("%s.tipoReclamacion", KEY_PROCEDIMIENTO), procedimiento.getTipoReclamacion().getCodigo()); 
			}
			
			//codClienteEntidad
			StringBuilder personasAfectadas = new StringBuilder();
			List<Persona> personas = procedimiento.getPersonasAfectadas();
			for(Persona per : personas) {
				if (personasAfectadas.length()>0) personasAfectadas.append("-");
				personasAfectadas.append(per.getCodClienteEntidad());
			}
			addExtraInfo(String.format("%s.personasAfectadas", KEY_PROCEDIMIENTO), personasAfectadas.toString());
			
			addNumber(String.format("%s.porcentajeRecuperacion", KEY_PROCEDIMIENTO), procedimiento.getPorcentajeRecuperacion());
			addNumber(String.format("%s.plazoRecuperacion", KEY_PROCEDIMIENTO), procedimiento.getPlazoRecuperacion());
			addNumber(String.format("%s.saldoOriginalVencido", KEY_PROCEDIMIENTO), procedimiento.getSaldoOriginalVencido());
			addNumber(String.format("%s.saldoOriginalNoVencido", KEY_PROCEDIMIENTO), procedimiento.getSaldoOriginalNoVencido());
			addNumber(String.format("%s.saldoRecuperacion", KEY_PROCEDIMIENTO), procedimiento.getSaldoRecuperacion());
			addExtraInfo(String.format("%s.procEnJuzgado", KEY_PROCEDIMIENTO), procedimiento.getCodigoProcedimientoEnJuzgado());
			if (procedimiento.getJuzgado()!=null) {
				addCodigo(String.format("%s.juzgado", KEY_PROCEDIMIENTO), procedimiento.getJuzgado().getCodigo());
			}
			addFecha(String.format("%s.recopilacion", KEY_PROCEDIMIENTO), procedimiento.getFechaRecopilacion());
			addExtraInfo(String.format("%s.observaciones", KEY_PROCEDIMIENTO), procedimiento.getObservacionesRecopilacion());
		}
		if (procedimientoPadre!=null) {
			addSourceId(KEY_PROCEDIMIENTO_PADRE, procedimientoPadre.getId());
			addCodigo(KEY_PROCEDIMIENTO_PADRE, procedimientoPadre.getTipoProcedimiento().getCodigo());
			addGuid(KEY_PROCEDIMIENTO_PADRE, procedimientoPadre.getGuid());
		}
	}
	
	public void build(TareaExterna tarea) {
		EXTTareaNotificacion tarNotif = (EXTTareaNotificacion)tarea.getTareaPadre();
		TareaProcedimiento tareaProcedimiento = tarea.getTareaProcedimiento();
		
		// Tarea
		addSourceId(KEY_TEX_TAREA, tarea.getId());
		addCodigo(KEY_TAP_TAREA, tareaProcedimiento.getCodigo());

		build(tarNotif);
	}

	public void build(EXTTareaNotificacion tarNotif) {
		// Tarea
		addSourceId(KEY_TAR_TAREA, tarNotif.getId());
		addGuid(KEY_TAR_TAREA, tarNotif.getGuid());

		setDescripcion(tarNotif.getDescripcionTarea());
		addFecha("fechaIni", tarNotif.getFechaInicio());
		addFecha("fechaFin", tarNotif.getFechaFin());
		addFecha("fechaVenc", tarNotif.getFechaVenc());
		addFecha("fechaVencReal", tarNotif.getFechaVencReal());
	}
	
	public void load(EXTTareaNotificacion tarNotif) {
		tarNotif.setGuid(this.getGuidTARTarea());
		tarNotif.setFechaInicio(getFecha().get("fechaIni"));
		tarNotif.setFechaFin(getFecha().get("fechaFin"));
		tarNotif.setFechaVenc(getFecha().get("fechaVenc"));
		tarNotif.setFechaVencReal(getFecha().get("fechaVencReal"));
	}
	
	@JsonIgnore
	public Long getIdAsunto() {
		return getIdOrigen().get(KEY_ASUNTO);
	}
	
	@JsonIgnore
	public String getGuidAsunto() {
		return getGuid().get(KEY_ASUNTO);
	}
	
	@JsonIgnore
	public Long getIdTEXTarea() {
		return getIdOrigen().get(KEY_TEX_TAREA);
	}

	@JsonIgnore
	public Long getIdTARTarea() {
		return getIdOrigen().get(KEY_TAR_TAREA);
	}
	
	@JsonIgnore
	public String getCodigoTAPTarea() {
		return getCodigo().get(KEY_TAP_TAREA);
	}
	
	@JsonIgnore
	public String getGuidTARTarea() {
		return getGuid().get(KEY_TAR_TAREA);
	}
	
	@JsonIgnore
	public Long getIdProcedimiento() {
		return getIdOrigen().get(KEY_PROCEDIMIENTO);
	}

	@JsonIgnore
	public Long getIdProcedimientoPadre() {
		return getIdOrigen().get(KEY_PROCEDIMIENTO_PADRE);
	}

	@JsonIgnore
	public String getCodigoProcedimiento() {
		return getCodigo().get(KEY_PROCEDIMIENTO);
	}

	@JsonIgnore
	public String getCodigoProcedimientoPadre() {
		return getCodigo().get(KEY_PROCEDIMIENTO_PADRE);
	}
	
	@JsonIgnore
	public String getGuidProcedimiento() {
		return getGuid().get(KEY_PROCEDIMIENTO);
	}

	@JsonIgnore
	public String getGuidProcedimientoPadre() {
		return getGuid().get(KEY_PROCEDIMIENTO_PADRE);
	}

}
