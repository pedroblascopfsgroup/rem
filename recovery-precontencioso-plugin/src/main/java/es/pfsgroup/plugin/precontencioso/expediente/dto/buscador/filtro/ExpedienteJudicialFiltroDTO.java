package es.pfsgroup.plugin.precontencioso.expediente.dto.buscador.filtro;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class ExpedienteJudicialFiltroDTO extends WebDto {

	private static final long serialVersionUID = 3410603482861665588L;

	private String codigo;
	private String nombre;
	private String actor;
	private String codigoEstado;
	private Date fechaInicioPreparacionDesde;
	private Date fechaInicioPreparacionHasta;
	private Date fechaPreparadoDesde;
	private Date fechaPreparadoHasta;
	private Date fechaEnviadoLetradoDesde;
	private Date fechaEnviadoLetradoHasta;
	private Date fechaFinalizadoDesde;
	private Date fechaFinalizadoHasta;
	private Date fechaUltimaSubsanacionDesde;
	private Date fechaUltimaSubsanacionHasta;
	private Date fechaCanceladoDesde;
	private Date fechaCanceladoHasta;
	private Date fechaParalizacionDesde;
	private Date fechaParalizacionHasta;
	private String tipoProcedimiento;
	private String tipoPreparacion;

	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getActor() {
		return actor;
	}
	public void setActor(String actor) {
		this.actor = actor;
	}
	public String getCodigoEstado() {
		return codigoEstado;
	}
	public void setCodigoEstado(String codigoEstado) {
		this.codigoEstado = codigoEstado;
	}
	public Date getFechaInicioPreparacionDesde() {
		return fechaInicioPreparacionDesde;
	}
	public void setFechaInicioPreparacionDesde(Date fechaInicioPreparacionDesde) {
		this.fechaInicioPreparacionDesde = fechaInicioPreparacionDesde;
	}
	public Date getFechaInicioPreparacionHasta() {
		return fechaInicioPreparacionHasta;
	}
	public void setFechaInicioPreparacionHasta(Date fechaInicioPreparacionHasta) {
		this.fechaInicioPreparacionHasta = fechaInicioPreparacionHasta;
	}
	public Date getFechaPreparadoDesde() {
		return fechaPreparadoDesde;
	}
	public void setFechaPreparadoDesde(Date fechaPreparadoDesde) {
		this.fechaPreparadoDesde = fechaPreparadoDesde;
	}
	public Date getFechaPreparadoHasta() {
		return fechaPreparadoHasta;
	}
	public void setFechaPreparadoHasta(Date fechaPreparadoHasta) {
		this.fechaPreparadoHasta = fechaPreparadoHasta;
	}
	public Date getFechaEnviadoLetradoDesde() {
		return fechaEnviadoLetradoDesde;
	}
	public void setFechaEnviadoLetradoDesde(Date fechaEnviadoLetradoDesde) {
		this.fechaEnviadoLetradoDesde = fechaEnviadoLetradoDesde;
	}
	public Date getFechaEnviadoLetradoHasta() {
		return fechaEnviadoLetradoHasta;
	}
	public void setFechaEnviadoLetradoHasta(Date fechaEnviadoLetradoHasta) {
		this.fechaEnviadoLetradoHasta = fechaEnviadoLetradoHasta;
	}
	public Date getFechaFinalizadoDesde() {
		return fechaFinalizadoDesde;
	}
	public void setFechaFinalizadoDesde(Date fechaFinalizadoDesde) {
		this.fechaFinalizadoDesde = fechaFinalizadoDesde;
	}
	public Date getFechaFinalizadoHasta() {
		return fechaFinalizadoHasta;
	}
	public void setFechaFinalizadoHasta(Date fechaFinalizadoHasta) {
		this.fechaFinalizadoHasta = fechaFinalizadoHasta;
	}
	public Date getFechaUltimaSubsanacionDesde() {
		return fechaUltimaSubsanacionDesde;
	}
	public void setFechaUltimaSubsanacionDesde(Date fechaUltimaSubsanacionDesde) {
		this.fechaUltimaSubsanacionDesde = fechaUltimaSubsanacionDesde;
	}
	public Date getFechaUltimaSubsanacionHasta() {
		return fechaUltimaSubsanacionHasta;
	}
	public void setFechaUltimaSubsanacionHasta(Date fechaUltimaSubsanacionHasta) {
		this.fechaUltimaSubsanacionHasta = fechaUltimaSubsanacionHasta;
	}
	public Date getFechaCanceladoDesde() {
		return fechaCanceladoDesde;
	}
	public void setFechaCanceladoDesde(Date fechaCanceladoDesde) {
		this.fechaCanceladoDesde = fechaCanceladoDesde;
	}
	public Date getFechaCanceladoHasta() {
		return fechaCanceladoHasta;
	}
	public void setFechaCanceladoHasta(Date fechaCanceladoHasta) {
		this.fechaCanceladoHasta = fechaCanceladoHasta;
	}
	public Date getFechaParalizacionDesde() {
		return fechaParalizacionDesde;
	}
	public void setFechaParalizacionDesde(Date fechaParalizacionDesde) {
		this.fechaParalizacionDesde = fechaParalizacionDesde;
	}
	public Date getFechaParalizacionHasta() {
		return fechaParalizacionHasta;
	}
	public void setFechaParalizacionHasta(Date fechaParalizacionHasta) {
		this.fechaParalizacionHasta = fechaParalizacionHasta;
	}
	public String getTipoProcedimiento() {
		return tipoProcedimiento;
	}
	public void setTipoProcedimiento(String tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	public String getTipoPreparacion() {
		return tipoPreparacion;
	}
	public void setTipoPreparacion(String tipoPreparacion) {
		this.tipoPreparacion = tipoPreparacion;
	}
}
