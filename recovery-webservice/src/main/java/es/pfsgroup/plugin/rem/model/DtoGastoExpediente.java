package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de los honorarios del expediente.
 *  
 * @author Luis Caballero
 *
 */
public class DtoGastoExpediente extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private String id;
	private String codigoId;
	private String codigoTipoComision;
	private String descripcionTipoComision;
	private String proveedor;
	private String tipoCalculo;
	private String codigoTipoCalculo;
	private Double importeCalculo;
	private Double honorarios;
	private String observaciones;
	private String tipoProveedor;
	private Long idProveedor;
	private String codigoTipoProveedor;
	private Long idActivo;
	private Long idOferta;
	private Long numActivo;
	private Long codigoProveedorRem;
	private Double participacionActivo;
	private Double importeFinal;
	private String origenComprador;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCodigoId() {
		return codigoId;
	}
	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}
	public String getProveedor() {
		return proveedor;
	}
	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}
	public String getTipoCalculo() {
		return tipoCalculo;
	}
	public void setTipoCalculo(String tipoCalculo) {
		this.tipoCalculo = tipoCalculo;
	}
	public String getCodigoTipoCalculo() {
		return codigoTipoCalculo;
	}
	public void setCodigoTipoCalculo(String codigoTipoCalculo) {
		this.codigoTipoCalculo = codigoTipoCalculo;
	}
	public Double getImporteCalculo() {
		return importeCalculo;
	}
	public void setImporteCalculo(Double importeCalculo) {
		this.importeCalculo = importeCalculo;
	}
	public Double getHonorarios() {
		return honorarios;
	}
	public void setHonorarios(Double honorarios) {
		this.honorarios = honorarios;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getTipoProveedor() {
		return tipoProveedor;
	}
	public void setTipoProveedor(String tipoProveedor) {
		this.tipoProveedor = tipoProveedor;
	}
	public Long getIdProveedor() {
		return idProveedor;
	}
	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}
	public String getCodigoTipoProveedor() {
		return codigoTipoProveedor;
	}
	public void setCodigoTipoProveedor(String codigoTipoProveedor) {
		this.codigoTipoProveedor = codigoTipoProveedor;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getIdOferta() {
		return idOferta;
	}
	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
	}
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public Long getCodigoProveedorRem() {
		return codigoProveedorRem;
	}
	public void setCodigoProveedorRem(Long codigoProveedorRem) {
		this.codigoProveedorRem = codigoProveedorRem;
	}
	public String getCodigoTipoComision() {
		return codigoTipoComision;
	}
	public void setCodigoTipoComision(String codigoTipoComision) {
		this.codigoTipoComision = codigoTipoComision;
	}
	public String getDescripcionTipoComision() {
		return descripcionTipoComision;
	}
	public void setDescripcionTipoComision(String descripcionTipoComision) {
		this.descripcionTipoComision = descripcionTipoComision;
	}
	public Double getParticipacionActivo() {
		return participacionActivo;
	}
	public void setParticipacionActivo(Double participacionActivo) {
		this.participacionActivo = participacionActivo;
	}

	public Double getImporteFinal() {
		return importeFinal;
	}
	public void setImporteFinal(Double importeFinal) {
		this.importeFinal = importeFinal;
	}
	
	public String getOrigenComprador() {
		return origenComprador;
	}
	
	public void setOrigenComprador(String origenComprador) {
		this.origenComprador = origenComprador;
	} 
}
