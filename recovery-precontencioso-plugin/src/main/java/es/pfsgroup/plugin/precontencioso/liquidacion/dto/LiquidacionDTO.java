package es.pfsgroup.plugin.precontencioso.liquidacion.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class LiquidacionDTO extends WebDto {

	private static final long serialVersionUID = -3060420588597775665L;

	private Long id;
	private Long idProcedimientoPCO;
	private Long idContrato;
	private String producto;
	private Date fechaSolicitud;
	private Date fechaRecepcion;
	private Date fechaConfirmacion;
	private Date fechaCierre;
	private Float capitalVencido;
	private Float capitalNoVencido;
	private Float interesesDemora;
	private Float interesesOrdinarios;
	private Float total;
	private String sysGuid;

	// Estado
	private String estadoCod;
	private String estadoLiquidacion;

	// Apoderado
	private String apoderadoNombre;
	private Long apoderadoUsdId; // USD_ID

	// Apoderado usuario/despacho
	private Long apoderadoUsuarioId;
	private Long apoderadoDespachoId;

	/*
	 * GETTERS & SETTERS
	 */

	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdProcedimientoPCO() {
		return idProcedimientoPCO;
	}
	public void setIdProcedimientoPCO(Long idProcedimientoPCO) {
		this.idProcedimientoPCO = idProcedimientoPCO;
	}
	public Long getIdContrato() {
		return idContrato;
	}
	public void setIdContrato(Long idContrato) {
		this.idContrato = idContrato;
	}
	public String getProducto() {
		return producto;
	}
	public void setProducto(String producto) {
		this.producto = producto;
	}
	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}
	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}
	public Date getFechaConfirmacion() {
		return fechaConfirmacion;
	}
	public void setFechaConfirmacion(Date fechaConfirmacion) {
		this.fechaConfirmacion = fechaConfirmacion;
	}
	public Date getFechaCierre() {
		return fechaCierre;
	}
	public void setFechaCierre(Date fechaCierre) {
		this.fechaCierre = fechaCierre;
	}
	public Float getCapitalVencido() {
		return capitalVencido;
	}
	public void setCapitalVencido(Float capitalVencido) {
		this.capitalVencido = capitalVencido;
	}
	public Float getCapitalNoVencido() {
		return capitalNoVencido;
	}
	public void setCapitalNoVencido(Float capitalNoVencido) {
		this.capitalNoVencido = capitalNoVencido;
	}
	public Float getInteresesDemora() {
		return interesesDemora;
	}
	public void setInteresesDemora(Float interesesDemora) {
		this.interesesDemora = interesesDemora;
	}
	public Float getInteresesOrdinarios() {
		return interesesOrdinarios;
	}
	public void setInteresesOrdinarios(Float interesesOrdinarios) {
		this.interesesOrdinarios = interesesOrdinarios;
	}
	public Float getTotal() {
		return total;
	}
	public void setTotal(Float total) {
		this.total = total;
	}
	public String getSysGuid() {
		return sysGuid;
	}
	public void setSysGuid(String sysGuid) {
		this.sysGuid = sysGuid;
	}
	public String getEstadoCod() {
		return estadoCod;
	}
	public void setEstadoCod(String estadoCod) {
		this.estadoCod = estadoCod;
	}
	public String getEstadoLiquidacion() {
		return estadoLiquidacion;
	}
	public void setEstadoLiquidacion(String estadoLiquidacion) {
		this.estadoLiquidacion = estadoLiquidacion;
	}
	public String getApoderadoNombre() {
		return apoderadoNombre;
	}
	public void setApoderadoNombre(String apoderadoNombre) {
		this.apoderadoNombre = apoderadoNombre;
	}
	public Long getApoderadoUsdId() {
		return apoderadoUsdId;
	}
	public void setApoderadoUsdId(Long apoderadoUsdId) {
		this.apoderadoUsdId = apoderadoUsdId;
	}
	public Long getApoderadoUsuarioId() {
		return apoderadoUsuarioId;
	}
	public void setApoderadoUsuarioId(Long apoderadoUsuarioId) {
		this.apoderadoUsuarioId = apoderadoUsuarioId;
	}
	public Long getApoderadoDespachoId() {
		return apoderadoDespachoId;
	}
	public void setApoderadoDespachoId(Long apoderadoDespachoId) {
		this.apoderadoDespachoId = apoderadoDespachoId;
	}
}
