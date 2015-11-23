package es.pfsgroup.plugin.precontencioso.liquidacion.dto;

import java.math.BigDecimal;
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
	private BigDecimal capitalVencido;
	private BigDecimal capitalNoVencido;
	private BigDecimal interesesDemora;
	private BigDecimal interesesOrdinarios;
	private BigDecimal total;
	private BigDecimal capitalVencidoOriginal;
	private BigDecimal capitalNoVencidoOriginal;
	private BigDecimal interesesDemoraOriginal;
	private BigDecimal interesesOrdinariosOriginal;
	private BigDecimal totalOriginal;
	private String sysGuid;
	private BigDecimal comisiones;
	private BigDecimal gastos;
	private BigDecimal impuestos;
	private BigDecimal comisionesOriginal;
	private BigDecimal gastosOriginal;
	private BigDecimal impuestosOriginal;

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
	public BigDecimal getCapitalVencido() {
		return capitalVencido;
	}
	public void setCapitalVencido(BigDecimal capitalVencido) {
		this.capitalVencido = capitalVencido;
	}
	public BigDecimal getCapitalNoVencido() {
		return capitalNoVencido;
	}
	public void setCapitalNoVencido(BigDecimal capitalNoVencido) {
		this.capitalNoVencido = capitalNoVencido;
	}
	public BigDecimal getInteresesDemora() {
		return interesesDemora;
	}
	public void setInteresesDemora(BigDecimal interesesDemora) {
		this.interesesDemora = interesesDemora;
	}
	public BigDecimal getInteresesOrdinarios() {
		return interesesOrdinarios;
	}
	public void setInteresesOrdinarios(BigDecimal interesesOrdinarios) {
		this.interesesOrdinarios = interesesOrdinarios;
	}
	public BigDecimal getTotal() {
		return total;
	}
	public void setTotal(BigDecimal total) {
		this.total = total;
	}
	public BigDecimal getCapitalVencidoOriginal() {
		return capitalVencidoOriginal;
	}
	public void setCapitalVencidoOriginal(BigDecimal capitalVencidoOriginal) {
		this.capitalVencidoOriginal = capitalVencidoOriginal;
	}
	public BigDecimal getCapitalNoVencidoOriginal() {
		return capitalNoVencidoOriginal;
	}
	public void setCapitalNoVencidoOriginal(BigDecimal capitalNoVencidoOriginal) {
		this.capitalNoVencidoOriginal = capitalNoVencidoOriginal;
	}
	public BigDecimal getInteresesDemoraOriginal() {
		return interesesDemoraOriginal;
	}
	public void setInteresesDemoraOriginal(BigDecimal interesesDemoraOriginal) {
		this.interesesDemoraOriginal = interesesDemoraOriginal;
	}
	public BigDecimal getInteresesOrdinariosOriginal() {
		return interesesOrdinariosOriginal;
	}
	public void setInteresesOrdinariosOriginal(BigDecimal interesesOrdinariosOriginal) {
		this.interesesOrdinariosOriginal = interesesOrdinariosOriginal;
	}
	public BigDecimal getTotalOriginal() {
		return totalOriginal;
	}
	public void setTotalOriginal(BigDecimal totalOriginal) {
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
	public BigDecimal getComisiones() {
		return comisiones;
	}
	public void setComisiones(BigDecimal comisiones) {
		this.comisiones = comisiones;
	}
	public BigDecimal getGastos() {
		return gastos;
	}
	public void setGastos(BigDecimal gastos) {
		this.gastos = gastos;
	}
	public BigDecimal getImpuestos() {
		return impuestos;
	}
	public void setImpuestos(BigDecimal impuestos) {
		this.impuestos = impuestos;
	}
	public BigDecimal getComisionesOriginal() {
		return comisionesOriginal;
	}
	public void setComisionesOriginal(BigDecimal comisionesOriginal) {
		this.comisionesOriginal = comisionesOriginal;
	}
	public BigDecimal getGastosOriginal() {
		return gastosOriginal;
	}
	public void setGastosOriginal(BigDecimal gastosOriginal) {
		this.gastosOriginal = gastosOriginal;
	}
	public BigDecimal getImpuestosOriginal() {
		return impuestosOriginal;
	}
	public void setImpuestosOriginal(BigDecimal impuestosOriginal) {
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
