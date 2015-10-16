package es.pfsgroup.recovery.ext.impl.procedimiento;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

public class EXTProcedimientoDto {

	private Long idProcedimiento;
	private Asunto asunto;
	private Procedimiento procedimientoPadre;
	private TipoProcedimiento tipoProcedimiento;
	private Boolean decidido;
	private List<ExpedienteContrato> expedienteContratos;
	private Date fechaRecopilacion;
	private List<Persona> personas;
	private DDEstadoProcedimiento estadoProcedimiento;
	private TipoJuzgado juzgado;
	private String codigoProcedimientoEnJuzgado;
	private String observacionesRecopilacion;
	private Integer plazoRecuperacion;
	private Integer porcentajeRecuperacion;
	private BigDecimal saldoOriginalNoVencido;
	private BigDecimal saldoOriginalVencido;
	private BigDecimal saldoRecuperacion;
	private DDTipoReclamacion tipoReclamacion;
	private List<ProcedimientoBien> bienes;
	private String guid;
	
	public Long getIdProcedimiento() {
		return idProcedimiento;
	}
	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}
	public Asunto getAsunto() {
		return asunto;
	}
	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}
	public Procedimiento getProcedimientoPadre() {
		return procedimientoPadre;
	}
	public void setProcedimientoPadre(Procedimiento procedimientoPadre) {
		this.procedimientoPadre = procedimientoPadre;
	}
	public TipoProcedimiento getTipoProcedimiento() {
		return tipoProcedimiento;
	}
	public void setTipoProcedimiento(TipoProcedimiento tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	public Boolean getDecidido() {
		return decidido;
	}
	public void setDecidido(Boolean decidido) {
		this.decidido = decidido;
	}
	public List<ExpedienteContrato> getExpedienteContratos() {
		return expedienteContratos;
	}
	public void setExpedienteContratos(List<ExpedienteContrato> expedienteContratos) {
		this.expedienteContratos = expedienteContratos;
	}
	public Date getFechaRecopilacion() {
		return fechaRecopilacion;
	}
	public void setFechaRecopilacion(Date fechaRecopilacion) {
		this.fechaRecopilacion = fechaRecopilacion;
	}
	public List<Persona> getPersonas() {
		return personas;
	}
	public void setPersonas(List<Persona> personas) {
		this.personas = personas;
	}
	public DDEstadoProcedimiento getEstadoProcedimiento() {
		return estadoProcedimiento;
	}
	public void setEstadoProcedimiento(DDEstadoProcedimiento estadoProcedimiento) {
		this.estadoProcedimiento = estadoProcedimiento;
	}
	public TipoJuzgado getJuzgado() {
		return juzgado;
	}
	public void setJuzgado(TipoJuzgado juzgado) {
		this.juzgado = juzgado;
	}
	public String getCodigoProcedimientoEnJuzgado() {
		return codigoProcedimientoEnJuzgado;
	}
	public void setCodigoProcedimientoEnJuzgado(String codigoProcedimientoEnJuzgado) {
		this.codigoProcedimientoEnJuzgado = codigoProcedimientoEnJuzgado;
	}
	public String getObservacionesRecopilacion() {
		return observacionesRecopilacion;
	}
	public void setObservacionesRecopilacion(String observacionesRecopilacion) {
		this.observacionesRecopilacion = observacionesRecopilacion;
	}
	public Integer getPlazoRecuperacion() {
		return plazoRecuperacion;
	}
	public void setPlazoRecuperacion(Integer plazoRecuperacion) {
		this.plazoRecuperacion = plazoRecuperacion;
	}
	public Integer getPorcentajeRecuperacion() {
		return porcentajeRecuperacion;
	}
	public void setPorcentajeRecuperacion(Integer porcentajeRecuperacion) {
		this.porcentajeRecuperacion = porcentajeRecuperacion;
	}
	public BigDecimal getSaldoOriginalNoVencido() {
		return saldoOriginalNoVencido;
	}
	public void setSaldoOriginalNoVencido(BigDecimal saldoOriginalNoVencido) {
		this.saldoOriginalNoVencido = saldoOriginalNoVencido;
	}
	public BigDecimal getSaldoOriginalVencido() {
		return saldoOriginalVencido;
	}
	public void setSaldoOriginalVencido(BigDecimal saldoOriginalVencido) {
		this.saldoOriginalVencido = saldoOriginalVencido;
	}
	public BigDecimal getSaldoRecuperacion() {
		return saldoRecuperacion;
	}
	public void setSaldoRecuperacion(BigDecimal saldoRecuperacion) {
		this.saldoRecuperacion = saldoRecuperacion;
	}
	public DDTipoReclamacion getTipoReclamacion() {
		return tipoReclamacion;
	}
	public void setTipoReclamacion(DDTipoReclamacion tipoReclamacion) {
		this.tipoReclamacion = tipoReclamacion;
	}
	public List<ProcedimientoBien> getBienes() {
		return bienes;
	}
	public void setBienes(List<ProcedimientoBien> bienes) {
		this.bienes = bienes;
	}
	public String getGuid() {
		return guid;
	}
	public void setGuid(String guid) {
		this.guid = guid;
	}
	
}
