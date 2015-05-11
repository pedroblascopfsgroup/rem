package es.pfsgroup.recovery.recobroCommon.facturacion.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroModeloFacturacionDto extends WebDto{

	private static final long serialVersionUID = -5768135316322384957L;
	
	private Long id;
	
	private Long idModFact;
	
	private String nombre;
	
	private String descripcion;
	
	private String corrector;
	
	private String facturacion;
	
	private Boolean esquemaVigente;
	
	private String tipoDeCorrector;
	
	private Float objetivoRecobro; 
	
	private Integer tramoDias;
	
	private String estado;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getCorrector() {
		return corrector;
	}

	public void setCorrector(String corrector) {
		this.corrector = corrector;
	}

	public String getFacturacion() {
		return facturacion;
	}

	public void setFacturacion(String facturacion) {
		this.facturacion = facturacion;
	}

	public Boolean getEsquemaVigente() {
		return esquemaVigente;
	}

	public void setEsquemaVigente(Boolean esquemaVigente) {
		this.esquemaVigente = esquemaVigente;
	}

	public String getTipoDeCorrector() {
		return tipoDeCorrector;
	}

	public void setTipoDeCorrector(String tipoDeCorrector) {
		this.tipoDeCorrector = tipoDeCorrector;
	}

	public Float getObjetivoRecobro() {
		return objetivoRecobro;
	}

	public void setObjetivoRecobro(Float objetivoRecobro) {
		this.objetivoRecobro = objetivoRecobro;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Long getIdModFact() {
		return idModFact;
	}

	public void setIdModFact(Long idModFact) {
		this.idModFact = idModFact;
	}

	public Integer getTramoDias() {
		return tramoDias;
	}

	public void setTramoDias(Integer tramoDias) {
		this.tramoDias = tramoDias;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

}
