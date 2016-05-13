package es.pfsgroup.plugin.recovery.masivo.dto;

import java.util.Map;

import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.plugin.recovery.masivo.model.MSVFileItem;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;

public class MSVResolucionesDto {
	
	private Long idResolucion;
	
	private Long idAsunto;
	
	private Long comboTipoJuicioNew;
	
	private Long comboTipoResolucionNew;
	
	private String plaza;
	
	private String auto;
	
	private String juzgado;
		
	private String asunto;
	
	private Double principal;
	
	private Long idTarea;
	
	private Long idFichero;
	
	private Long idProcedimiento;
	
	private String estadoResolucion;

    private MSVFileItem adjunto;

    private EXTAdjuntoAsunto adjuntoFinal;

    private TareaNotificacion tareaNotificacion;
    
    private Long categoria;
    
    private String idsFicheros;
	
	public String getEstadoResolucion() {
		return estadoResolucion;
	}

	public void setEstadoResolucion(String estadoResolucion) {
		this.estadoResolucion = estadoResolucion;
	}

	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

	private Map<String,String> camposDinamicos;

	public String getAsunto() {
		return asunto;
	}

	public void setAsunto(String asunto) {
		this.asunto = asunto;
	}

	public String getAuto() {
		return auto;
	}

	public void setAuto(String auto) {
		this.auto = auto;
	}

	public Long getIdResolucion() {
		return idResolucion;
	}

	public void setIdResolucion(Long idResolucion) {
		this.idResolucion = idResolucion;
	}

	public Long getIdAsunto() {
		return idAsunto;
	}

	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}

	public Long getComboTipoJuicioNew() {
		return comboTipoJuicioNew;
	}

	public void setComboTipoJuicioNew(Long comboTipoJuicioNew) {
		this.comboTipoJuicioNew = comboTipoJuicioNew;
	}

	public Long getComboTipoResolucionNew() {
		return comboTipoResolucionNew;
	}

	public void setComboTipoResolucionNew(Long comboTipoResolucionNew) {
		this.comboTipoResolucionNew = comboTipoResolucionNew;
	}

	public String getPlaza() {
		return plaza;
	}

	public void setPlaza(String plaza) {
		this.plaza = plaza;
	}

	public String getJuzgado() {
		return juzgado;
	}

	public void setJuzgado(String juzgado) {
		this.juzgado = juzgado;
	}

	public Map<String,String> getCamposDinamicos() {
		return camposDinamicos;
	}

	public void setCamposDinamicos(Map<String,String> camposDinamicos) {
		this.camposDinamicos = camposDinamicos;
	}

	public Double getPrincipal() {
		return principal;
	}

	public void setPrincipal(Double principal) {
		this.principal = principal;
	}

	public Long getIdTarea() {
		return idTarea;
	}

	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}

	public Long getIdFichero() {
		return idFichero;
	}

	public void setIdFichero(Long idFichero) {
		this.idFichero = idFichero;
	}
	
	public MSVFileItem getAdjunto() {
		return adjunto;
	}

	public void setAdjunto(MSVFileItem adjunto) {
		this.adjunto = adjunto;
	}
	
	public EXTAdjuntoAsunto getAdjuntoFinal() {
		return adjuntoFinal;
	}

	public void setAdjuntoFinal(EXTAdjuntoAsunto adjuntoFinal) {
		this.adjuntoFinal = adjuntoFinal;
	}
	
	public TareaNotificacion getTareaNotificacion() {
		return tareaNotificacion;
	}

	public void setTareaNotificacion(TareaNotificacion tareaNotificacion) {
		this.tareaNotificacion = tareaNotificacion;
	}
	
	public Long getCategoria() {
		return categoria;
	}
	
	public void setCategoria(Long categoria) {
		this.categoria = categoria;
	}

	public String getIdsFicheros() {
		return idsFicheros;
	}

	public void setIdsFicheros(String idsFicheros) {
		this.idsFicheros = idsFicheros;
	}
	
}
