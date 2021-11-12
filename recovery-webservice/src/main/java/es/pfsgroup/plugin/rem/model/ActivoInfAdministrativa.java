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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoVenta;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;
import es.pfsgroup.plugin.rem.model.dd.DDTributacionAdquisicion;



/**
 * Modelo que gestiona la informacion administrativa de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_ADM_INF_ADMINISTRATIVA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoInfAdministrativa implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ADM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoInfAdministrativaGenerator")
    @SequenceGenerator(name = "ActivoInfAdministrativaGenerator", sequenceName = "S_ACT_ADM_INF_ADMINISTRATIVA")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TVP_ID")
	private DDTipoVpo tipoVpo;
	
	@Column(name = "ADM_SUELO_VPO")
	private Integer sueloVpo;
	
	@Column(name = "ADM_PROMOCION_VPO")
	private Integer promocionVpo;
	
	@Column(name = "ADM_NUM_EXPEDIENTE")
	private String numExpediente;
	
	@Column(name = "ADM_FECHA_CALIFICACION")
	private Date fechaCalificacion;
	
	@Column(name = "ADM_OBLIGATORIO_SOL_DEV_AYUDA")
	private Integer obligatorioSolDevAyuda;
	
	@Column(name = "ADM_OBLIG_AUT_ADM_VENTA")
	private Integer obligatorioAutAdmVenta;
	
	@Column(name = "ADM_DESCALIFICADO")
	private Integer descalificado;
	
	@Column(name = "ADM_MAX_PRECIO_VENTA")
	private Double maxPrecioVenta;
	
	@Column(name = "ADM_OBSERVACIONES")
	private String observaciones;
	
	@Column(name = "ADM_SUJETO_A_EXPEDIENTE")
	private Integer sujetoAExpediente;
	
	@Column(name = "ADM_ORGANISMO_EXPROPIANTE")
	private String organismoExpropiante;
	
	@Column(name = "ADM_FECHA_INI_EXPEDIENTE")
	private Date fechaInicioExpediente;
	
	@Column(name = "ADM_REF_EXPDTE_ADMIN")
	private String refExpedienteAdmin;
	
	@Column(name = "ADM_REF_EXPDTE_INTERNO")
	private String refExpedienteInterno;
	
	@Column(name = "ADM_OBS_EXPROPIACION")
	private String observacionesExpropiacion;
	
	@Column(name = "ADM_VIGENCIA")
	private Date vigencia;
	
	@Column(name = "ADM_COMUNICAR_ADQUISICION")
	private Integer comunicarAdquisicion;
	
	@Column(name = "ADM_NECESARIO_INSCR_VPO")
	private Integer necesarioInscribirVpo;
	
	@Column(name = "ADM_LIBERTAD_CESION")
	private Integer libertadCesion;
	
	@Column(name = "ADM_RENUNCIA_TANTEO_RETRAC")
	private Integer renunciaTanteoRetrac;
	
	@Column(name = "ADM_VISA_CONTRATO_PRIVADO")
	private Integer visaContratoPriv;
	
	@Column(name = "ADM_VENDER_PER_JURIDICA")
	private Integer venderPersonaJuridica;
	
	@Column(name = "ADM_MINUSVALIA")
	private Integer minusvalia;
	
	@Column(name = "ADM_INSCR_REGISTRO_DEMANDA")
	private Integer inscripcionRegistroDemVpo;
	
	@Column(name = "ADM_INGRESOS_INF_NIVEL")
	private Integer ingresosInfNivel;
	
	@Column(name = "ADM_RESIDENCIA_CM_AUTONOMA")
	private Integer residenciaComAutonoma;
	
	@Column(name = "ADM_NO_TITULAR_VIVIENDA")
	private Integer noTitularOtraVivienda;
	
	@Column(name = "ADM_FECHA_SOL_CERTIFICADO")
	private Date fechaSolCertificado;
	
	@Column(name = "ADM_FECHA_COM_ADQUISICION")
	private Date fechaComAdquision;
	
	@Column(name = "ADM_FECHA_COM_REG_DEM")
	private Date fechaComRegDem;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ADM_ACTUALIZA_PRECIO_MAX")
	private DDSinSiNo actualizaPrecioMax; 
	
	@Column(name = "ADM_FECHA_VENCIMIENTO")
	private Date fechaVencimiento;

	@Column(name = "ADM_PRECIO_MAX_VENTA")
	private Double precioMaxVenta;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TRA_ID")
	private DDTributacionAdquisicion tributacionAdquisicion; 
	
	@Column(name = "ACT_ADM_FECHA_VENC_TIP_BON")
	private Date fechaVencTpoBonificacion;
	
	@Column(name = "ACT_ADM_FECHA_LIQ_COMPLEM")
	private Date fechaLiqComplementaria;
	
	@Column(name = "ADM_FECHA_ENVIO_COM_ORG")
	private Date fechaEnvioComunicacionOrganismo;

	@Column(name = "ADM_FECHA_RECEPCION_RESP_ORG")
	private Date fechaRecepcionRespuestaOrganismo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ADM_ESTADO_VENTA")
	private DDEstadoVenta estadoVenta; 
	
	@Column(name = "ADM_MAX_PRECIO_MODULO_ALQUILER") 
	private Double maxPrecioModuloAlquiler; 
	
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

	public DDTipoVpo getTipoVpo() {
		return tipoVpo;
	}
	
	public void setTipoVpo(DDTipoVpo tipoVpo) {
		this.tipoVpo = tipoVpo;
	}
	
	public Integer getSueloVpo() {
		return sueloVpo;
	}
	
	public void setSueloVpo(Integer sueloVpo) {
		this.sueloVpo = sueloVpo;
	}
	
	public Integer getPromocionVpo() {
		return promocionVpo;
	}
	
	public void setPromocionVpo(Integer promocionVpo) {
		this.promocionVpo = promocionVpo;
	}
	
	public String getNumExpediente() {
		return numExpediente;
	}
	
	public void setNumExpediente(String numExpediente) {
		this.numExpediente = numExpediente;
	}
	
	public Date getFechaCalificacion() {
		return fechaCalificacion;
	}
	
	public void setFechaCalificacion(Date fechaCalificacion) {
		this.fechaCalificacion = fechaCalificacion;
	}
	
	public Integer getObligatorioSolDevAyuda() {
		return obligatorioSolDevAyuda;
	}
	
	public void setObligatorioSolDevAyuda(Integer obligatorioSolDevAyuda) {
		this.obligatorioSolDevAyuda = obligatorioSolDevAyuda;
	}
	
	public Integer getObligatorioAutAdmVenta() {
		return obligatorioAutAdmVenta;
	}
	
	public void setObligatorioAutAdmVenta(Integer obligatorioAutAdmVenta) {
		this.obligatorioAutAdmVenta = obligatorioAutAdmVenta;
	}
	
	public Integer getDescalificado() {
		return descalificado;
	}
	
	public void setDescalificado(Integer descalificado) {
		this.descalificado = descalificado;
	}
	
	public Double getMaxPrecioVenta() {
		return maxPrecioVenta;
	}
	
	public void setMaxPrecioVenta(Double maxPrecioVenta) {
		this.maxPrecioVenta = maxPrecioVenta;
	}
	
	public String getObservaciones() {
		return observaciones;
	}
	
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	public Integer getSujetoAExpediente() {
		return sujetoAExpediente;
	}

	public void setSujetoAExpediente(Integer sujetoAExpediente) {
		this.sujetoAExpediente = sujetoAExpediente;
	}

	public String getOrganismoExpropiante() {
		return organismoExpropiante;
	}

	public void setOrganismoExpropiante(String organismoExpropiante) {
		this.organismoExpropiante = organismoExpropiante;
	}

	public Date getFechaInicioExpediente() {
		return fechaInicioExpediente;
	}

	public void setFechaInicioExpediente(Date fechaInicioExpediente) {
		this.fechaInicioExpediente = fechaInicioExpediente;
	}

	public String getRefExpedienteAdmin() {
		return refExpedienteAdmin;
	}

	public void setRefExpedienteAdmin(String refExpedienteAdmin) {
		this.refExpedienteAdmin = refExpedienteAdmin;
	}

	public String getRefExpedienteInterno() {
		return refExpedienteInterno;
	}

	public void setRefExpedienteInterno(String refExpedienteInterno) {
		this.refExpedienteInterno = refExpedienteInterno;
	}

	public String getObservacionesExpropiacion() {
		return observacionesExpropiacion;
	}

	public void setObservacionesExpropiacion(String observacionesExpropiacion) {
		this.observacionesExpropiacion = observacionesExpropiacion;
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

	public Date getVigencia() {
		return vigencia;
	}

	public void setVigencia(Date vigencia) {
		this.vigencia = vigencia;
	}

	public Integer getComunicarAdquisicion() {
		return comunicarAdquisicion;
	}

	public void setComunicarAdquisicion(Integer comunicarAdquisicion) {
		this.comunicarAdquisicion = comunicarAdquisicion;
	}

	public Integer getNecesarioInscribirVpo() {
		return necesarioInscribirVpo;
	}

	public void setNecesarioInscribirVpo(Integer necesarioInscribirVpo) {
		this.necesarioInscribirVpo = necesarioInscribirVpo;
	}

	public Integer getLibertadCesion() {
		return libertadCesion;
	}

	public void setLibertadCesion(Integer libertadCesion) {
		this.libertadCesion = libertadCesion;
	}

	public Integer getRenunciaTanteoRetrac() {
		return renunciaTanteoRetrac;
	}

	public void setRenunciaTanteoRetrac(Integer renunciaTanteoRetrac) {
		this.renunciaTanteoRetrac = renunciaTanteoRetrac;
	}

	public Integer getVisaContratoPriv() {
		return visaContratoPriv;
	}

	public void setVisaContratoPriv(Integer visaContratoPriv) {
		this.visaContratoPriv = visaContratoPriv;
	}

	public Integer getVenderPersonaJuridica() {
		return venderPersonaJuridica;
	}

	public void setVenderPersonaJuridica(Integer venderPersonaJuridica) {
		this.venderPersonaJuridica = venderPersonaJuridica;
	}

	public Integer getMinusvalia() {
		return minusvalia;
	}

	public void setMinusvalia(Integer minusvalia) {
		this.minusvalia = minusvalia;
	}

	public Integer getInscripcionRegistroDemVpo() {
		return inscripcionRegistroDemVpo;
	}

	public void setInscripcionRegistroDemVpo(Integer inscripcionRegistroDemVpo) {
		this.inscripcionRegistroDemVpo = inscripcionRegistroDemVpo;
	}

	public Integer getIngresosInfNivel() {
		return ingresosInfNivel;
	}

	public void setIngresosInfNivel(Integer ingresosInfNivel) {
		this.ingresosInfNivel = ingresosInfNivel;
	}

	public Integer getResidenciaComAutonoma() {
		return residenciaComAutonoma;
	}

	public void setResidenciaComAutonoma(Integer residenciaComAutonoma) {
		this.residenciaComAutonoma = residenciaComAutonoma;
	}

	public Integer getNoTitularOtraVivienda() {
		return noTitularOtraVivienda;
	}

	public void setNoTitularOtraVivienda(Integer noTitularOtraVivienda) {
		this.noTitularOtraVivienda = noTitularOtraVivienda;
	}

	public Date getFechaSolCertificado() {
		return fechaSolCertificado;
	}

	public void setFechaSolCertificado(Date fechaSolCertificado) {
		this.fechaSolCertificado = fechaSolCertificado;
	}

	public Date getFechaComAdquision() {
		return fechaComAdquision;
	}

	public void setFechaComAdquisicion(Date fechaComAdquision) {
		this.fechaComAdquision = fechaComAdquision;
	}

	public Date getFechaComRegDem() {
		return fechaComRegDem;
	}

	public void setFechaComRegDem(Date fechaComRegDem) {
		this.fechaComRegDem = fechaComRegDem;
	}

	public DDSinSiNo getActualizaPrecioMax() {
		return actualizaPrecioMax;
	}

	public void setActualizaPrecioMax(DDSinSiNo actualizaPrecioMax) {
		this.actualizaPrecioMax = actualizaPrecioMax;
	}

	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	
	public Double getPrecioMaxVenta() {
		return precioMaxVenta;
	}

	public void setPrecioMaxVenta(Double precioMaxVenta) {
		this.precioMaxVenta = precioMaxVenta;
	}

	public Date getFechaVencTpoBonificacion() {
		return fechaVencTpoBonificacion;
	}

	public void setFechaVencTpoBonificacion(Date fechaVencTpoBonificacion) {
		this.fechaVencTpoBonificacion = fechaVencTpoBonificacion;
	}

	public Date getFechaLiqComplementaria() {
		return fechaLiqComplementaria;
	}

	public void setFechaLiqComplementaria(Date fechaLiqComplementaria) {
		this.fechaLiqComplementaria = fechaLiqComplementaria;
	}

	public DDTributacionAdquisicion getTributacionAdquisicion() {
		return tributacionAdquisicion;
	}

	public void setTributacionAdquisicion(DDTributacionAdquisicion tributacionAdquisicion) {
		this.tributacionAdquisicion = tributacionAdquisicion;
	}

	public Date getFechaEnvioComunicacionOrganismo() {
		return fechaEnvioComunicacionOrganismo;
	}

	public void setFechaEnvioComunicacionOrganismo(Date fechaEnvioComunicacionOrganismo) {
		this.fechaEnvioComunicacionOrganismo = fechaEnvioComunicacionOrganismo;
	}

	public Date getFechaRecepcionRespuestaOrganismo() {
		return fechaRecepcionRespuestaOrganismo;
	}

	public void setFechaRecepcionRespuestaOrganismo(Date fechaRecepcionRespuestaOrganismo) {
		this.fechaRecepcionRespuestaOrganismo = fechaRecepcionRespuestaOrganismo;
	}

	public DDEstadoVenta getEstadoVenta() {
		return estadoVenta;
	}

	public void setEstadoVenta(DDEstadoVenta estadoVenta) {
		this.estadoVenta = estadoVenta;
	}

	public void setFechaComAdquision(Date fechaComAdquision) {
		this.fechaComAdquision = fechaComAdquision;
	}

	public Double getMaxPrecioModuloAlquiler() { 
		return maxPrecioModuloAlquiler; 
	} 

	public void setMaxPrecioModuloAlquiler(Double maxPrecioModuloAlquiler) { 
		this.maxPrecioModuloAlquiler = maxPrecioModuloAlquiler; 
	} 
	
}

