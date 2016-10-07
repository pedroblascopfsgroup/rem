package es.pfsgroup.plugin.rem.trabajo.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Trabajos
 * @author Jose Villel
 *
 */
public class DtoTrabajoFilter extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	private String idTrabajo;
	
	private Long idActivo;
	
	private String numTrabajo;
	
	private Long idTrabajoWebcom;
	
	private Long numActivoAgrupacion;
	
	private Long numActivo;
	
	private Long numActivoRem;
	
	private Long numAgrupacionRem;
	
	private String codigoTipo;
	
	private String codigoSubtipo;		
	
	private String codigoEstado;
	
	private String fechaPeticionDesde;
	
	private String fechaPeticionHasta;
	
	private String descripcionPoblacion;
	
	private String codigoProvincia;
	
	private String codPostal;
	
	private String solicitante;
	
	private String proveedor;
	
	private String cartera;
	
	private String gestorActivo;
	
	private Integer cubreSeguro;
	
	private Long idProveedor;
	
	private Integer conCierreEconomico;
	
	private Integer facturado;

	public String getIdTrabajo() {
		return idTrabajo;
	}

	public void setIdTrabajo(String idTrabajo) {
		this.idTrabajo = idTrabajo;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(String numTrabajo) {
		this.numTrabajo = numTrabajo;
	}
	
	public Long getIdTrabajoWebcom() {
		return idTrabajoWebcom;
	}

	public void setIdTrabajoWebcom(Long idTrabajoWebcom) {
		this.idTrabajoWebcom = idTrabajoWebcom;
	}

	public Long getNumActivoAgrupacion() {
		return numActivoAgrupacion;
	}

	public void setNumActivoAgrupacion(Long numActivoAgrupacion) {
		this.numActivoAgrupacion = numActivoAgrupacion;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public String getFechaPeticionDesde() {
		return fechaPeticionDesde;
	}

	public void setFechaPeticionDesde(String fechaPeticionDesde) {
		this.fechaPeticionDesde = fechaPeticionDesde;
	}

	public String getFechaPeticionHasta() {
		return fechaPeticionHasta;
	}

	public void setFechaPeticionHasta(String fechaPeticionHasta) {
		this.fechaPeticionHasta = fechaPeticionHasta;
	}

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}

	public String getCodigoTipo() {
		return codigoTipo;
	}

	public void setCodigoTipo(String codigoTipo) {
		this.codigoTipo = codigoTipo;
	}

	public String getCodigoSubtipo() {
		return codigoSubtipo;
	}

	public void setCodigoSubtipo(String codigoSubtipo) {
		this.codigoSubtipo = codigoSubtipo;
	}

	public String getCodigoEstado() {
		return codigoEstado;
	}

	public void setCodigoEstado(String codigoEstado) {
		this.codigoEstado = codigoEstado;
	}

	public String getDescripcionPoblacion() {
		return descripcionPoblacion;
	}

	public void setDescripcionPoblacion(String descripcionPoblacion) {
		this.descripcionPoblacion = descripcionPoblacion;
	}

	public String getCodigoProvincia() {
		return codigoProvincia;
	}

	public void setCodigoProvincia(String codigoProvincia) {
		this.codigoProvincia = codigoProvincia;
	}

	public String getSolicitante() {
		return solicitante;
	}

	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}

	public String getProveedor() {
		return proveedor;
	}

	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}

	public Long getNumActivoRem() {
		return numActivoRem;
	}

	public void setNumActivoRem(Long numActivoRem) {
		this.numActivoRem = numActivoRem;
	}

	public Long getNumAgrupacionRem() {
		return numAgrupacionRem;
	}

	public void setNumAgrupacionRem(Long numAgrupacionRem) {
		this.numAgrupacionRem = numAgrupacionRem;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getGestorActivo() {
		return gestorActivo;
	}

	public void setGestorActivo(String gestorActivo) {
		this.gestorActivo = gestorActivo;
	}

	public Integer getCubreSeguro() {
		return cubreSeguro;
	}

	public void setCubreSeguro(Integer cubreSeguro) {
		this.cubreSeguro = cubreSeguro;
	}

	public Long getIdProveedor() {
		return idProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}

	public Integer getConCierreEconomico() {
		return conCierreEconomico;
	}

	public void setConCierreEconomico(Integer conCierreEconomico) {
		this.conCierreEconomico = conCierreEconomico;
	}

	public Integer getFacturado() {
		return facturado;
	}

	public void setFacturado(Integer facturado) {
		this.facturado = facturado;
	}

}