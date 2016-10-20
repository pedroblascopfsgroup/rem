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
	private String participacion;
	private String proveedor;
	private String tipoCalculo;
	private Double importeCalculo;
	private Double honorarios;
	private String observaciones;
	private String tipoProveedor;
	private Long idProveedor;
	private String codigoTipoProveedor;
	private String codigoParticipacion;
	
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
	public String getParticipacion() {
		return participacion;
	}
	public void setParticipacion(String participacion) {
		this.participacion = participacion;
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
	public String getCodigoParticipacion() {
		return codigoParticipacion;
	}
	public void setCodigoParticipacion(String codigoParticipacion) {
		this.codigoParticipacion = codigoParticipacion;
	}
	
	
   		
}
