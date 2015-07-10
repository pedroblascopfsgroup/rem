package es.pfsgroup.plugin.precontencioso.liquidacion.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class LiquidacionDTO extends WebDto {

	private static final long serialVersionUID = -3060420588597775665L;

	private Long id;
	private Long idProcedimientoPCO;
	private Long idContrato;
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

	private String estadoCod;
	private String estadoLiquidacion;

	private String apoderado;
	private Long apoderadoId;

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
	public Long getApoderadoId() {
		return apoderadoId;
	}
	public void setApoderadoId(Long apoderadoId) {
		this.apoderadoId = apoderadoId;
	}
	public String getEstadoLiquidacion() {
		return estadoLiquidacion;
	}
	public void setEstadoLiquidacion(String estadoLiquidacion) {
		this.estadoLiquidacion = estadoLiquidacion;
	}
	public String getApoderado() {
		return apoderado;
	}
	public void setApoderado(String apoderado) {
		this.apoderado = apoderado;
	}
}
