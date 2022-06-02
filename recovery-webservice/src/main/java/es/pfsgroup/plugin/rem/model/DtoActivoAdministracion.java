package es.pfsgroup.plugin.rem.model;

/**
 * Dto para el tab de cargas
 * @author Carlos Feliu
 *
 */
public class DtoActivoAdministracion extends DtoTabActivo {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
    private Long numActivo;
    private Boolean ibiExento;
    private Boolean isUnidadAlquilable;
	private String segmentacionCarteraCodigo;
	private String segmentacionCarteraDescripcion;
    
    
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public Boolean getIbiExento() {
		return ibiExento;
	}
	public void setIbiExento(Boolean ibiExento) {
		this.ibiExento = ibiExento;
	}
	public Boolean getIsUnidadAlquilable() {
		return isUnidadAlquilable;
	}
	public void setIsUnidadAlquilable(Boolean isUnidadAlquilable) {
		this.isUnidadAlquilable = isUnidadAlquilable;
	}
	public String getSegmentacionCarteraCodigo() {
		return segmentacionCarteraCodigo;
	}
	public void setSegmentacionCarteraCodigo(String segmentacionCarteraCodigo) {
		this.segmentacionCarteraCodigo = segmentacionCarteraCodigo;
	}
	public String getSegmentacionCarteraDescripcion() {
		return segmentacionCarteraDescripcion;
	}
	public void setSegmentacionCarteraDescripcion(String segmentacionCarteraDescripcion) {
		this.segmentacionCarteraDescripcion = segmentacionCarteraDescripcion;
	}
	
}