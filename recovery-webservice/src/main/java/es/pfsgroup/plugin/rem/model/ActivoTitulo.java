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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;



/**
 * Modelo que gestiona la informacion de los títulos de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_TIT_TITULO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoTitulo implements Serializable, Auditable {


    /**
	 * 
	 */
	private static final long serialVersionUID = -6936507226268404917L;

	@Id
    @Column(name = "TIT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoTituloGenerator")
    @SequenceGenerator(name = "ActivoTituloGenerator", sequenceName = "S_ACT_TIT_TITULO")
    private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ETI_ID")
    private DDEstadoTitulo estado; 
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo; 
	
	@Column(name = "TIT_FECHA_ENTREGA_GESTORIA")
	private Date fechaEntregaGestoria;
	 
	@Column(name = "TIT_FECHA_PRESENT_HACIENDA")
	private Date fechaPresHacienda;
	
	@Column(name = "TIT_FECHA_ENVIO_AUTO")
	private Date fechaEnvioAuto;
	
	@Column(name = "TIT_FECHA_PRESENT1_REG")
	private Date fechaPres1Registro;
	
	@Column(name = "TIT_FECHA_PRESENT2_REG")
	private Date fechaPres2Registro;
	
	@Column(name = "TIT_FECHA_INSC_REG")
	private Date fechaInscripcionReg;
	
	@Column(name = "TIT_FECHA_RETIRADA_REG")
	private Date fechaRetiradaReg;

	@Column(name = "TIT_FECHA_NOTA_SIMPLE")
	private Date fechaNotaSimple;
	
	@Column(name = "TIT_FEC_MARCAJE_INSC")
	private Date fechaMarcajeInscripcion;
	
    @Column(name = "FECHA_EST_TIT_ACT_INM")
    private Date fechaEstadoTitularidadActivoInmobiliario;

    @Column(name = "TIT_PLUSVALIA_COMPRADOR")
	private Boolean plusvaliaComprador;
	
	@Column(name = "TIT_FECHA_LIQUIDACION_PLUSVALIA")
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

	public DDEstadoTitulo getEstado() {
		return estado;
	}

	public void setEstado(DDEstadoTitulo estado) {
		this.estado = estado;
	}

	public Date getFechaEntregaGestoria() {
		return fechaEntregaGestoria;
	}

	public void setFechaEntregaGestoria(Date fechaEntregaGestoria) {
		this.fechaEntregaGestoria = fechaEntregaGestoria;
	}

	public Date getFechaPresHacienda() {
		return fechaPresHacienda;
	}

	public void setFechaPresHacienda(Date fechaPresHacienda) {
		this.fechaPresHacienda = fechaPresHacienda;
	}

	public Date getFechaEnvioAuto() {
		return fechaEnvioAuto;
	}

	public void setFechaEnvioAuto(Date fechaEnvioAuto) {
		this.fechaEnvioAuto = fechaEnvioAuto;
	}

	public Date getFechaPres1Registro() {
		return fechaPres1Registro;
	}

	public void setFechaPres1Registro(Date fechaPres1Registro) {
		this.fechaPres1Registro = fechaPres1Registro;
	}

	public Date getFechaPres2Registro() {
		return fechaPres2Registro;
	}

	public void setFechaPres2Registro(Date fechaPres2Registro) {
		this.fechaPres2Registro = fechaPres2Registro;
	}

	public Date getFechaInscripcionReg() {
		return fechaInscripcionReg;
	}

	public void setFechaInscripcionReg(Date fechaInscripcionReg) {
		this.fechaInscripcionReg = fechaInscripcionReg;
	}

	public Date getFechaRetiradaReg() {
		return fechaRetiradaReg;
	}

	public void setFechaRetiradaReg(Date fechaRetiradaReg) {
		this.fechaRetiradaReg = fechaRetiradaReg;
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public Date getFechaMarcajeInscripcion() {
		return fechaMarcajeInscripcion;
	}

	public void setFechaMarcajeInscripcion(Date fechaMarcajeInscripcion) {
		this.fechaMarcajeInscripcion = fechaMarcajeInscripcion;
	}

	public Date getFechaEstadoTitularidadActivoInmobiliario() {
		return fechaEstadoTitularidadActivoInmobiliario;
	}

	public void setFechaEstadoTitularidadActivoInmobiliario(Date fechaEstadoTitularidadActivoInmobiliario) {
		this.fechaEstadoTitularidadActivoInmobiliario = fechaEstadoTitularidadActivoInmobiliario;
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
