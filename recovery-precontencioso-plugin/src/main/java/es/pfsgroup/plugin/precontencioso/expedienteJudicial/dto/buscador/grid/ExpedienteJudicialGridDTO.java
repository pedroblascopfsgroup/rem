package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class ExpedienteJudicialGridDTO extends WebDto {

	private static final long serialVersionUID = 655397921693689581L;

	private String codigo;
	private String nombre;
	private String estado;
	private Date fechaEstado;
	private String tipoProcedimiento;
	private String tipoPreparacion;
	private Date fechaInicioPreparacion;
	private Integer diasPreparacion;
	private Boolean documentacionCompleta;
	private Double totalLiquidacion;
	private Boolean notificacion;
	private Date fechaEnvioLetrado;
	private Date aceptadoLetrado;
	private DocumentoGridDTO documento;
	private LiquidacionGridDTO liquidacion;
	private BurofaxGridDTO burofax;

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
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public Date getFechaEstado() {
		return fechaEstado;
	}
	public void setFechaEstado(Date fechaEstado) {
		this.fechaEstado = fechaEstado;
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
	public Date getFechaInicioPreparacion() {
		return fechaInicioPreparacion;
	}
	public void setFechaInicioPreparacion(Date fechaInicioPreparacion) {
		this.fechaInicioPreparacion = fechaInicioPreparacion;
	}
	public Integer getDiasPreparacion() {
		return diasPreparacion;
	}
	public void setDiasPreparacion(Integer diasPreparacion) {
		this.diasPreparacion = diasPreparacion;
	}
	public Boolean getDocumentacionCompleta() {
		return documentacionCompleta;
	}
	public void setDocumentacionCompleta(Boolean documentacionCompleta) {
		this.documentacionCompleta = documentacionCompleta;
	}
	public Double getTotalLiquidacion() {
		return totalLiquidacion;
	}
	public void setTotalLiquidacion(Double totalLiquidacion) {
		this.totalLiquidacion = totalLiquidacion;
	}
	public Boolean getNotificacion() {
		return notificacion;
	}
	public void setNotificacion(Boolean notificacion) {
		this.notificacion = notificacion;
	}
	public Date getFechaEnvioLetrado() {
		return fechaEnvioLetrado;
	}
	public void setFechaEnvioLetrado(Date fechaEnvioLetrado) {
		this.fechaEnvioLetrado = fechaEnvioLetrado;
	}
	public Date getAceptadoLetrado() {
		return aceptadoLetrado;
	}
	public void setAceptadoLetrado(Date aceptadoLetrado) {
		this.aceptadoLetrado = aceptadoLetrado;
	}
	public DocumentoGridDTO getDocumento() {
		return documento;
	}
	public void setDocumento(DocumentoGridDTO documento) {
		this.documento = documento;
	}
	public LiquidacionGridDTO getLiquidacion() {
		return liquidacion;
	}
	public void setLiquidacion(LiquidacionGridDTO liquidacion) {
		this.liquidacion = liquidacion;
	}
	public BurofaxGridDTO getBurofax() {
		return burofax;
	}
	public void setBurofax(BurofaxGridDTO burofax) {
		this.burofax = burofax;
	}
}
