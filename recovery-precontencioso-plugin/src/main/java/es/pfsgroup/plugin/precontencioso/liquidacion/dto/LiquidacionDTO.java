package es.pfsgroup.plugin.precontencioso.liquidacion.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class LiquidacionDTO extends WebDto {

	private static final long serialVersionUID = -3060420588597775665L;

	private Long id;
	private Long idProcedimientoPCO;
	private Long idContrato;
	private String nroContrato;
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
	private Float capitalVencidoOriginal;
	private Float capitalNoVencidoOriginal;
	private Float interesesDemoraOriginal;
	private Float interesesOrdinariosOriginal;
	private Float totalOriginal;
	private String sysGuid;
	private Float comisiones;
	private Float gastos;
	private Float impuestos;
	private Float comisionesOriginal;
	private Float gastosOriginal;
	private Float impuestosOriginal;

	// Estado
	private String estadoCod;
	private String estadoLiquidacion;

	// Apoderado
	private String apoderadoNombre;
	private Long apoderadoUsdId; // USD_ID

	// Apoderado usuario/despacho
	private Long apoderadoUsuarioId;
	private Long apoderadoDespachoId;
	
	//Solicitante
	private String solicitante;
	
	

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
	public Float getCapitalVencidoOriginal() {
		return capitalVencidoOriginal;
	}
	public void setCapitalVencidoOriginal(Float capitalVencidoOriginal) {
		this.capitalVencidoOriginal = capitalVencidoOriginal;
	}
	public Float getCapitalNoVencidoOriginal() {
		return capitalNoVencidoOriginal;
	}
	public void setCapitalNoVencidoOriginal(Float capitalNoVencidoOriginal) {
		this.capitalNoVencidoOriginal = capitalNoVencidoOriginal;
	}
	public Float getInteresesDemoraOriginal() {
		return interesesDemoraOriginal;
	}
	public void setInteresesDemoraOriginal(Float interesesDemoraOriginal) {
		this.interesesDemoraOriginal = interesesDemoraOriginal;
	}
	public Float getInteresesOrdinariosOriginal() {
		return interesesOrdinariosOriginal;
	}
	public void setInteresesOrdinariosOriginal(Float interesesOrdinariosOriginal) {
		this.interesesOrdinariosOriginal = interesesOrdinariosOriginal;
	}
	public Float getTotalOriginal() {
		return totalOriginal;
	}
	public void setTotalOriginal(Float totalOriginal) {
		this.totalOriginal = totalOriginal;
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
	public Float getComisiones() {
		return comisiones;
	}
	public void setComisiones(Float comisiones) {
		this.comisiones = comisiones;
	}
	public Float getGastos() {
		return gastos;
	}
	public void setGastos(Float gastos) {
		this.gastos = gastos;
	}
	public Float getImpuestos() {
		return impuestos;
	}
	public void setImpuestos(Float impuestos) {
		this.impuestos = impuestos;
	}
	public Float getComisionesOriginal() {
		return comisionesOriginal;
	}
	public void setComisionesOriginal(Float comisionesOriginal) {
		this.comisionesOriginal = comisionesOriginal;
	}
	public Float getGastosOriginal() {
		return gastosOriginal;
	}
	public void setGastosOriginal(Float gastosOriginal) {
		this.gastosOriginal = gastosOriginal;
	}
	public Float getImpuestosOriginal() {
		return impuestosOriginal;
	}
	public void setImpuestosOriginal(Float impuestosOriginal) {
		this.impuestosOriginal = impuestosOriginal;
	}
	
	public String getNroContrato() {
		return nroContrato;
	}
	public void setNroContrato(String nroContrato) {
		this.nroContrato = nroContrato;
	}
	public String getSolicitante() {
		return solicitante;
	}
	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}
	
	
	
}
