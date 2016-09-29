package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de un activo-gasto.
 *  
 * @author Luis Caballero
 *
 */
public class DtoActivoGasto extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long id;
	private Long idGasto;
	private Long idActivo;
	private Long idAgrupacion;
	private Long numActivo;
	private Long numAgrupacion;
	private Long idGastoActivo;
	private String direccion;
	private Double participacionGasto;
	private Double importeProporcinalTotal;
	private String referenciasCatastrales;
	private String referenciaCatastral;
	private String subtipoCodigo;
	private String subtipoDescripcion;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdGasto() {
		return idGasto;
	}
	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getIdAgrupacion() {
		return idAgrupacion;
	}
	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public Long getNumAgrupacion() {
		return numAgrupacion;
	}
	public void setNumAgrupacion(Long numAgrupacion) {
		this.numAgrupacion = numAgrupacion;
	}
	public Long getIdGastoActivo() {
		return idGastoActivo;
	}
	public void setIdGastoActivo(Long idGastoActivo) {
		this.idGastoActivo = idGastoActivo;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public Double getParticipacionGasto() {
		return participacionGasto;
	}
	public void setParticipacionGasto(Double participacionGasto) {
		this.participacionGasto = participacionGasto;
	}
	public Double getImporteProporcinalTotal() {
		return importeProporcinalTotal;
	}
	public void setImporteProporcinalTotal(Double importeProporcinalTotal) {
		this.importeProporcinalTotal = importeProporcinalTotal;
	}
	public String getReferenciasCatastrales() {
		return referenciasCatastrales;
	}
	public void setReferenciasCatastrales(String referenciasCatastrales) {
		this.referenciasCatastrales = referenciasCatastrales;
	}
	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}
	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}
	public String getSubtipoCodigo() {
		return subtipoCodigo;
	}
	public void setSubtipoCodigo(String subtipoCodigo) {
		this.subtipoCodigo = subtipoCodigo;
	}
	public String getSubtipoDescripcion() {
		return subtipoDescripcion;
	}
	public void setSubtipoDescripcion(String subtipoDescripcion) {
		this.subtipoDescripcion = subtipoDescripcion;
	}
   	
}
