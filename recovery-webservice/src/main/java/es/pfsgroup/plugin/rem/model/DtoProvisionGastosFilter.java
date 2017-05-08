package es.pfsgroup.plugin.rem.model;

import java.util.List;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de provisiones de gastos
 * @author Jose Villel
 *
 */
public class DtoProvisionGastosFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long id;
	private String numProvision;
	private String estadoProvisionCodigo;
	private String codCartera;
	private String codSubCartera;
	private List<Long> listaIdProveedor;
	private Long idGestoria;
	private String codREMProveedorGestoria;
	private String nombreProveedor;
	private Double importeDesde;
	private Double importeHasta;
	private String fechaAltaDesde;
	private String fechaAltaHasta;
	private String nifPropietario;
	private String nomPropietario;
	private Boolean isExterno;
	
	
	
	
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
	public String getCodCartera() {
		return codCartera;
	}
	public void setCodCartera(String codCartera) {
		this.codCartera = codCartera;
	}
	public String getCodSubCartera() {
		return codSubCartera;
	}
	public void setCodSubCartera(String codSubCartera) {
		this.codSubCartera = codSubCartera;
	}
	public List<Long> getListaIdProveedor() {
		return listaIdProveedor;
	}
	public void setListaIdProveedor(List<Long> listaIdProveedor) {
		this.listaIdProveedor = listaIdProveedor;
	}
	public Long getIdGestoria() {
		return idGestoria;
	}
	public void setIdGestoria(Long idGestoria) {
		this.idGestoria = idGestoria;
	}
	public String getCodREMProveedorGestoria() {
		return codREMProveedorGestoria;
	}
	public void setCodREMProveedorGestoria(String codREMProveedorGestoria) {
		this.codREMProveedorGestoria = codREMProveedorGestoria;
	}
	public String getNombreProveedor() {
		return nombreProveedor;
	}
	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}
	public Double getImporteDesde() {
		return importeDesde;
	}
	public void setImporteDesde(Double importeDesde) {
		this.importeDesde = importeDesde;
	}
	public Double getImporteHasta() {
		return importeHasta;
	}
	public void setImporteHasta(Double importeHasta) {
		this.importeHasta = importeHasta;
	}
	public String getFechaAltaDesde() {
		return fechaAltaDesde;
	}
	public void setFechaAltaDesde(String fechaAltaDesde) {
		this.fechaAltaDesde = fechaAltaDesde;
	}
	public String getFechaAltaHasta() {
		return fechaAltaHasta;
	}
	public void setFechaAltaHasta(String fechaAltaHasta) {
		this.fechaAltaHasta = fechaAltaHasta;
	}
	public String getNifPropietario() {
		return nifPropietario;
	}
	public void setNifPropietario(String nifPropietario) {
		this.nifPropietario = nifPropietario;
	}
	public String getNomPropietario() {
		return nomPropietario;
	}
	public void setNomPropietario(String nomPropietario) {
		this.nomPropietario = nomPropietario;
	}
	public Boolean getIsExterno() {
		return isExterno;
	}
	public void setIsExterno(Boolean isExterno) {
		this.isExterno = isExterno;
	}

	
}