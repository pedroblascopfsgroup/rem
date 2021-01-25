package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;



/**
 * Dto para las tarifas aplicadas para los trabajos
 * @author Carlos Feliu
 *
 */
public class DtoTarifaTrabajo extends WebDto {

	private static final long serialVersionUID = 0L;

	private String id;
	private Long idConfigTarifa;
	private String codigoTarifa;
	private String descripcion;
	private String precioUnitario;
	private String subtipoTrabajoCodigo;
	private String subtipoTrabajoDescripcion;
	private String unidadMedida;
	private String medicion;
	private String cuentaContable;
	private String partidaPresupuestaria;
	private String importeTotal;
	private Integer totalCount;
	private String importeTotalTarifas;
	private String precioUnitarioCliente;
	private String importeCliente;
	private String importeTotalCliente;

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Long getIdConfigTarifa() {
		return idConfigTarifa;
	}
	public void setIdConfigTarifa(Long idConfigTarifa) {
		this.idConfigTarifa = idConfigTarifa;
	}
	public String getCodigoTarifa() {
		return codigoTarifa;
	}
	public void setCodigoTarifa(String codigoTarifa) {
		this.codigoTarifa = codigoTarifa;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getPrecioUnitario() {
		return precioUnitario;
	}
	public void setPrecioUnitario(String precioUnitario) {
		this.precioUnitario = precioUnitario;
	}
	public String getSubtipoTrabajoCodigo() {
		return subtipoTrabajoCodigo;
	}
	public void setSubtipoTrabajoCodigo(String subtipoTrabajoCodigo) {
		this.subtipoTrabajoCodigo = subtipoTrabajoCodigo;
	}
	public String getSubtipoTrabajoDescripcion() {
		return subtipoTrabajoDescripcion;
	}
	public void setSubtipoTrabajoDescripcion(String subtipoTrabajoDescripcion) {
		this.subtipoTrabajoDescripcion = subtipoTrabajoDescripcion;
	}
	public String getUnidadMedida() {
		return unidadMedida;
	}
	public void setUnidadMedida(String unidadMedida) {
		this.unidadMedida = unidadMedida;
	}
	public String getMedicion() {
		return medicion;
	}
	public void setMedicion(String medicion) {
		this.medicion = medicion;
	}
	public String getCuentaContable() {
		return cuentaContable;
	}
	public void setCuentaContable(String cuentaContable) {
		this.cuentaContable = cuentaContable;
	}
	public String getPartidaPresupuestaria() {
		return partidaPresupuestaria;
	}
	public void setPartidaPresupuestaria(String partidaPresupuestaria) {
		this.partidaPresupuestaria = partidaPresupuestaria;
	}
	public String getImporteTotal() {
		return importeTotal;
	}
	public void setImporteTotal(String importeTotal) {
		this.importeTotal = importeTotal;
	}
	public Integer getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(Integer totalCount) {
		this.totalCount = totalCount;
	}
	public String getImporteTotalTarifas() {
		return importeTotalTarifas;
	}
	public void setImporteTotalTarifas(String importeTotalTarifas) {
		this.importeTotalTarifas = importeTotalTarifas;
	}
	public String getPrecioUnitarioCliente() {
		return precioUnitarioCliente;
	}
	public void setPrecioUnitarioCliente(String precioUnitarioCliente) {
		this.precioUnitarioCliente = precioUnitarioCliente;
	}
	public String getImporteTotalCliente() {
		return importeTotalCliente;
	}
	public void setImporteTotalCliente(String importeTotalCliente) {
		this.importeTotalCliente = importeTotalCliente;
	}
	public String getImporteCliente() {
		return importeCliente;
	}
	public void setImporteCliente(String importeCliente) {
		this.importeCliente = importeCliente;
	}

}