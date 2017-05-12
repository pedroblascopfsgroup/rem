package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de provisiones de gastos
 * @author Jose Villel
 *
 */
public class DtoProvisionGastos extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long id;
	private String numProvision;
	private String estadoProvisionCodigo;
	private String estadoProvisionDescripcion;
	private Date fechaAlta;
	private Date fechaEnvio;
	private Date fechaRespuesta;
	private Date fechaAnulacion;	
	private Long idProveedor;
	private String codREMProveedor;
	private String nombreProveedor;
	private String nomPropietario;
	private String nifPropietario;
	private String codCartera;
	private String descCartera;
	private String codSubCartera;
	private String descSubCartera;
	private Double importeTotal;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getNumProvision() {
		return numProvision;
	}
	public void setNumProvision(String numProvision) {
		this.numProvision = numProvision;
	}
	public String getEstadoProvisionCodigo() {
		return estadoProvisionCodigo;
	}
	public void setEstadoProvisionCodigo(String estadoProvisionCodigo) {
		this.estadoProvisionCodigo = estadoProvisionCodigo;
	}
	public String getEstadoProvisionDescripcion() {
		return estadoProvisionDescripcion;
	}
	public void setEstadoProvisionDescripcion(String estadoProvisionDescripcion) {
		this.estadoProvisionDescripcion = estadoProvisionDescripcion;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public Date getFechaEnvio() {
		return fechaEnvio;
	}
	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}
	public Date getFechaRespuesta() {
		return fechaRespuesta;
	}
	public void setFechaRespuesta(Date fechaRespuesta) {
		this.fechaRespuesta = fechaRespuesta;
	}
	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}
	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
	}
	public Long getIdProveedor() {
		return idProveedor;
	}
	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}
	public String getCodREMProveedor() {
		return codREMProveedor;
	}
	public void setCodREMProveedor(String codREMProveedor) {
		this.codREMProveedor = codREMProveedor;
	}
	public String getNombreProveedor() {
		return nombreProveedor;
	}
	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}
	public String getNomPropietario() {
		return nomPropietario;
	}
	public void setNomPropietario(String nomPropietario) {
		this.nomPropietario = nomPropietario;
	}
	public String getNifPropietario() {
		return nifPropietario;
	}
	public void setNifPropietario(String nifPropietario) {
		this.nifPropietario = nifPropietario;
	}
	public String getCodCartera() {
		return codCartera;
	}
	public void setCodCartera(String codCartera) {
		this.codCartera = codCartera;
	}
	public String getDescCartera() {
		return descCartera;
	}
	public void setDescCartera(String descCartera) {
		this.descCartera = descCartera;
	}
	public String getCodSubCartera() {
		return codSubCartera;
	}
	public void setCodSubCartera(String codSubCartera) {
		this.codSubCartera = codSubCartera;
	}
	public String getDescSubCartera() {
		return descSubCartera;
	}
	public void setDescSubCartera(String descSubCartera) {
		this.descSubCartera = descSubCartera;
	}
	public Double getImporteTotal() {
		return importeTotal;
	}
	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}
	
	
	
}