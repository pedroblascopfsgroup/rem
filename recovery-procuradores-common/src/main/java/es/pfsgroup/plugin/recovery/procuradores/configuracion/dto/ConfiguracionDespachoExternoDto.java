package es.pfsgroup.plugin.recovery.procuradores.configuracion.dto;

public class ConfiguracionDespachoExternoDto {

	Long id;

	Long idDespacho;
	
	Long idCategorizacionTareas;
	
	Long idCategorizacionResoluciones;
	
	Boolean despachoIntegral;
	
	Boolean avisos;
	
	Boolean pausados;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdDespacho() {
		return idDespacho;
	}

	public void setIdDespacho(Long idDespacho) {
		this.idDespacho = idDespacho;
	}

	public Long getIdCategorizacionTareas() {
		return idCategorizacionTareas;
	}

	public void setIdCategorizacionTareas(Long idCategorizacionTareas) {
		this.idCategorizacionTareas = idCategorizacionTareas;
	}

	public Long getIdCategorizacionResoluciones() {
		return idCategorizacionResoluciones;
	}

	public void setIdCategorizacionResoluciones(Long idCategorizacionResoluciones) {
		this.idCategorizacionResoluciones = idCategorizacionResoluciones;
	}

	public Boolean getDespachoIntegral() {
		return despachoIntegral;
	}

	public void setDespachoIntegral(Boolean despachoIntegral) {
		this.despachoIntegral = despachoIntegral;
	}
	
	public Boolean getAvisos() {
		return avisos;
	}

	public void setAvisos(Boolean avisos) {
		this.avisos = avisos;
	}
	
	
	public Boolean getPausados() {
		return pausados;
	}

	public void setPausados(Boolean pausados) {
		this.pausados = pausados;
	}

}
