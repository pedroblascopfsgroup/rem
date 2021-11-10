package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.titulo.model.DDTipoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloAdicional;


@Entity
@Table(name = "ACT_TIA_TITULO_ADICIONAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoTituloAdicional implements Serializable, Auditable{

	
	private static final long serialVersionUID = -6936507226268404917L;

	
	@Id
    @Column(name = "ACT_TIA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoTituloAdicionalGenerator")
    @SequenceGenerator(name = "ActivoTituloAdicionalGenerator", sequenceName = "S_ACT_TIA_TITULO_ADICIONAL")
	private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
	private Activo activo;
	
	@Column(name = "TIA_TITULO_ADICIONAL")
	private Integer tituloAdicional;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TTA_ID")
	private DDTipoTituloAdicional tipoTitulo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ETI_ID")
	private DDEstadoTitulo estadoTitulo;
	
	@Column(name = "TIA_FECHA_INSCRIPCION_REG")
	private Date fechaInscripcionReg;
	
	@Column(name = "TIA_FECHA_ENTREGA_TITULO")
	private Date fechaEntregaTitulo;
	
	@Column(name = "TIA_FECHA_RETIRADA_REG")
	private Date fechaRetiradaReg;
	
	@Column(name = "TIA_FECHA_PRESENT_HACIENDA")
	private Date fechaPresentHacienda;
	
	@Column(name = "TIA_FECHA_NOTA_SIMPLE")
	private Date fechaNotaSimple;
	
	@Column(name = "TIA_PLUSVALIA_COMPRADOR")
	private Boolean plusvaliaComprador;
	
	@Column(name = "TIA_FECHA_LIQUIDACION_PLUSVALIA")
	private Date fechaLiquidacionPlusvalia;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public DDTipoTituloAdicional getTipoTitulo() {
		return tipoTitulo;
	}

	public void setTipoTitulo(DDTipoTituloAdicional tipoTitulo) {
		this.tipoTitulo = tipoTitulo;
	}

	public DDEstadoTitulo getEstadoTitulo() {
		return estadoTitulo;
	}

	public void setEstadoTitulo(DDEstadoTitulo estadoTitulo) {
		this.estadoTitulo = estadoTitulo;
	}

	public Date getFechaInscripcionReg() {
		return fechaInscripcionReg;
	}

	public void setFechaInscripcionReg(Date fechaInscripcionReg) {
		this.fechaInscripcionReg = fechaInscripcionReg;
	}

	public Date getFechaEntregaTitulo() {
		return fechaEntregaTitulo;
	}

	public void setFechaEntregaTitulo(Date fechaEntregaTitulo) {
		this.fechaEntregaTitulo = fechaEntregaTitulo;
	}

	public Date getFechaRetiradaReg() {
		return fechaRetiradaReg;
	}

	public void setFechaRetiradaReg(Date fechaRetiradaReg) {
		this.fechaRetiradaReg = fechaRetiradaReg;
	}

	public Date getFechaPresentHacienda() {
		return fechaPresentHacienda;
	}

	public void setFechaPresentHacienda(Date fechaPresentHacienda) {
		this.fechaPresentHacienda = fechaPresentHacienda;
	}

	public Date getFechaNotaSimple() {
		return fechaNotaSimple;
	}

	public void setFechaNotaSimple(Date fechaNotaSimple) {
		this.fechaNotaSimple = fechaNotaSimple;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getTituloAdicional() {
		return tituloAdicional;
	}

	public void setTituloAdicional(Integer tituloAdicional) {
		this.tituloAdicional = tituloAdicional;
	}

	public Boolean getPlusvaliaComprador() {
		return plusvaliaComprador;
	}

	public void setPlusvaliaComprador(Boolean plusvaliaComprador) {
		this.plusvaliaComprador = plusvaliaComprador;
	}

	public Date getFechaLiquidacionPlusvalia() {
		return fechaLiquidacionPlusvalia;
	}

	public void setFechaLiquidacionPlusvalia(Date fechaLiquidacionPlusvalia) {
		this.fechaLiquidacionPlusvalia = fechaLiquidacionPlusvalia;
	}

}
