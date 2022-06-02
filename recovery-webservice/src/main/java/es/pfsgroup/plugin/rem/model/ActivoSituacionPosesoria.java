package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionJuridica;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloPosesorio;



/**
 * Modelo que gestiona la situacion posesoria de un activo.
 * 
 * @author Jose Villel
 */
@Entity
@Table(name = "ACT_SPS_SIT_POSESORIA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoSituacionPosesoria implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "SPS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoSituacionPosesoriaGenerator")
    @SequenceGenerator(name = "ActivoSituacionPosesoriaGenerator", sequenceName = "S_ACT_SPS_SIT_POSESORIA")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPO_ID")
    private DDTipoTituloPosesorio tipoTituloPosesorio;
    
	@OneToMany(mappedBy = "situacionPosesoria", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "SPS_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoOcupanteLegal> activoOcupanteLegal;
	
    @Column(name = "SPS_FECHA_REVISION_ESTADO")
    private Date fechaRevisionEstado;
    
	@Column(name = "SPS_FECHA_TOMA_POSESION")
	private Date fechaTomaPosesion;
	
	@Column(name = "SPS_OCUPADO")
	private Integer ocupado;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPA_ID")
    private DDTipoTituloActivoTPA conTitulo;
	
	@Column(name = "SPS_RIESGO_OCUPACION")
	private Integer riesgoOcupacion;
	
	@Column(name = "SPS_FECHA_TITULO")
	private Date fechaTitulo;
	
	@Column(name = "SPS_FECHA_VENC_TITULO")
	private Date fechaVencTitulo;
	
	@Column(name = "SPS_RENTA_MENSUAL")
	private Float rentaMensual;

	@Column(name = "SPS_FECHA_SOL_DESAHUCIO")
	private Date fechaSolDesahucio;
	
	@Column(name = "SPS_FECHA_LANZAMIENTO")
	private Date fechalanzamiento;
	
	@Column(name = "SPS_FECHA_LANZAMIENTO_EFECTIVO")
	private Date fechaLanzamientoEfectivo;

	@Column(name = "SPS_ACC_TAPIADO")
	private Integer accesoTapiado;
	
	@Column(name = "SPS_FECHA_ACC_TAPIADO")
	private Date fechaAccesoTapiado;
	
	@Column(name = "SPS_ACC_ANTIOCUPA")
	private Integer accesoAntiocupa;
	
	@Column(name = "SPS_FECHA_ACC_ANTIOCUPA")
	private Date fechaAccesoAntiocupa;
	
	@Column(name = "SPS_OTRO")
	private String otro;
	
	@Column(name = "SPS_ESTADO_PORTAL_EXTERNO")
	private Boolean publicadoPortalExterno;
	
	@Column(name = "SPS_EDITA_FECHA_TOMA_POSESION")
	private Boolean editadoFechaTomaPosesion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SIJ_ID")
    private DDSituacionJuridica sitaucionJuridica;
	
	@Column(name = "SPS_FECHA_ULT_CAMBIO_TIT")
	private Date fechaUltCambioTit;
	
	@Column(name = "SPS_FECHA_ULT_CAMBIO_POS")
	private Date fechaUltCambioPos;
	
	@Column(name = "SPS_FECHA_ULT_CAMBIO_TAPIADO")
	private Date fechaUltCambioTapiado;
	
	@Column(name = "SPS_COMBO_OTRO")
	private Integer comboOtro = 0;
	
	@Column(name = "SPS_CON_TITULO")
	private Integer spsConTitulo;
	

	@Column(name = "SPS_POSESION_NEG")
	private Boolean spsPosesionNeg;
	
	@Column(name = "SPS_ALARMA")
	private Integer conAlarma;
	
	@Column(name = "SPS_FECHA_INSTALA_ALARMA")
	private Date fechaInstalacionAlarma;
	
	@Column(name = "SPS_FECHA_DESINSTALA_ALARMA")
	private Date fechaDesinstalacionAlarma;
	
	@Column(name = "SPS_VIGILANCIA")
	private Integer conVigilancia;
	
	@Column(name = "SPS_FECHA_INSTALA_VIGILANCIA")
	private Date fechaInstalacionVigilancia;
	
	@Column(name = "SPS_FECHA_DESINSTALA_VIGILANCIA")
	private Date fechaDesinstalacionVigilancia;

	@Column(name="SPS_USUARIOMODIFICAR_OCUPADO")
	private String usuarioModificarOcupado;

	@Column(name="SPS_FECHAMODIFICAR_OCUPADO")
	private Date fechaModificarOcupado;

	@Column(name="SPS_USUARIOMODIFICAR_CON_TITULO")
	private String usuarioModificarConTitulo;

	@Column(name="SPS_FECHAMODIFICAR_CON_TITULO")
	private Date fechaModificarConTitulo;
	
	@Column(name = "SPS_VERTICAL")
	private Integer vertical;

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;
	
	
	

	public Integer getSpsConTitulo() {
		return spsConTitulo;
	}
	
	public void setSpsConTitulo(Integer spsConTitulo) {
		this.spsConTitulo = spsConTitulo;
	}
	

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDTipoTituloPosesorio getTipoTituloPosesorio() {
		return tipoTituloPosesorio;
	}

	public void setTipoTituloPosesorio(DDTipoTituloPosesorio tipoTituloPosesorio) {
		this.tipoTituloPosesorio = tipoTituloPosesorio;
	}

	public List<ActivoOcupanteLegal> getActivoOcupanteLegal() {
		return activoOcupanteLegal;
	}

	public void setActivoOcupanteLegal(List<ActivoOcupanteLegal> activoOcupanteLegal) {
		this.activoOcupanteLegal = activoOcupanteLegal;
	}

	public Date getFechaRevisionEstado() {
		return fechaRevisionEstado;
	}

	public void setFechaRevisionEstado(Date fechaRevisionEstado) {
		this.fechaRevisionEstado = fechaRevisionEstado;
	}

	public Date getFechaTomaPosesion() {
		return fechaTomaPosesion;
	}

	public void setFechaTomaPosesion(Date fechaTomaPosesion) {
		this.fechaTomaPosesion = fechaTomaPosesion;
	}

	public Integer getOcupado() {
		return ocupado;
	}

	public void setOcupado(Integer ocupado) {
		this.ocupado = ocupado;
	}

	public DDTipoTituloActivoTPA getConTitulo() {
		return conTitulo;
	}

	public void setConTitulo(DDTipoTituloActivoTPA conTitulo) {
		this.conTitulo = conTitulo;
	}

	public Integer getRiesgoOcupacion() {
		return riesgoOcupacion;
	}

	public void setRiesgoOcupacion(Integer riesgoOcupacion) {
		this.riesgoOcupacion = riesgoOcupacion;
	}

	public Date getFechaTitulo() {
		return fechaTitulo;
	}

	public void setFechaTitulo(Date fechaTitulo) {
		this.fechaTitulo = fechaTitulo;
	}

	public Date getFechaVencTitulo() {
		return fechaVencTitulo;
	}

	public void setFechaVencTitulo(Date fechaVencTitulo) {
		this.fechaVencTitulo = fechaVencTitulo;
	}

	public Float getRentaMensual() {
		return rentaMensual;
	}

	public void setRentaMensual(Float rentaMensual) {
		this.rentaMensual = rentaMensual;
	}

	public Date getFechaSolDesahucio() {
		return fechaSolDesahucio;
	}

	public void setFechaSolDesahucio(Date fechaSolDesahucio) {
		this.fechaSolDesahucio = fechaSolDesahucio;
	}

	public Date getFechalanzamiento() {
		return fechalanzamiento;
	}

	public void setFechalanzamiento(Date fechalanzamiento) {
		this.fechalanzamiento = fechalanzamiento;
	}

	public Date getFechaLanzamientoEfectivo() {
		return fechaLanzamientoEfectivo;
	}

	public void setFechaLanzamientoEfectivo(Date fechaLanzamientoEfectivo) {
		this.fechaLanzamientoEfectivo = fechaLanzamientoEfectivo;
	}

	public Integer getAccesoTapiado() {
		return accesoTapiado;
	}

	public void setAccesoTapiado(Integer accesoTapiado) {
		this.accesoTapiado = accesoTapiado;
	}

	public Date getFechaAccesoTapiado() {
		return fechaAccesoTapiado;
	}

	public void setFechaAccesoTapiado(Date fechaAccesoTapiado) {
		this.fechaAccesoTapiado = fechaAccesoTapiado;
	}

	public Integer getAccesoAntiocupa() {
		return accesoAntiocupa;
	}

	public void setAccesoAntiocupa(Integer accesoAntiocupa) {
		this.accesoAntiocupa = accesoAntiocupa;
	}

	public Date getFechaAccesoAntiocupa() {
		return fechaAccesoAntiocupa;
	}

	public void setFechaAccesoAntiocupa(Date fechaAccesoAntiocupa) {
		this.fechaAccesoAntiocupa = fechaAccesoAntiocupa;
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

	public String getOtro() {
		return otro;
	}

	public void setOtro(String otro) {
		this.otro = otro;
	}

	public Boolean isPublicadoPortalExterno() {
		return publicadoPortalExterno;
	}
	
	public Boolean getPublicadoPortalExterno() {
		return publicadoPortalExterno;
	}

	public void setPublicadoPortalExterno(Boolean publicadoPortalExterno) {
		this.publicadoPortalExterno = publicadoPortalExterno;
	}

	public Boolean getEditadoFechaTomaPosesion() {
		return editadoFechaTomaPosesion;
	}

	public void setEditadoFechaTomaPosesion(Boolean editadoFechaTomaPosesion) {
		this.editadoFechaTomaPosesion = editadoFechaTomaPosesion;
	}

	public DDSituacionJuridica getSitaucionJuridica() {
		return sitaucionJuridica;
	}

	public void setSitaucionJuridica(DDSituacionJuridica sitaucionJuridica) {
		this.sitaucionJuridica = sitaucionJuridica;
	}

	public Date getFechaUltCambioPos() {
		return fechaUltCambioPos;
	}

	public void setFechaUltCambioPos(Date fechaUltCambioPos) {
		this.fechaUltCambioPos = fechaUltCambioPos;
	}

	public Date getFechaUltCambioTit() {
		return fechaUltCambioTit;
	}

	public void setFechaUltCambioTit(Date fechaUltCambioTit) {
		this.fechaUltCambioTit = fechaUltCambioTit;
	}

	public Date getFechaUltCambioTapiado() {
		return fechaUltCambioTapiado;
	}

	public void setFechaUltCambioTapiado(Date fechaUltCambioTapiado) {
		this.fechaUltCambioTapiado = fechaUltCambioTapiado;
	}
	
	public Integer getComboOtro() {
		return comboOtro;
	}

	public void setComboOtro(Integer comboOtro) {
		this.comboOtro = comboOtro;
	}

	public Boolean getSpsPosesionNeg() {
		return spsPosesionNeg;
	}

	public void setSpsPosesionNeg(Boolean spsPosesionNeg) {
		this.spsPosesionNeg = spsPosesionNeg;
	}

	public Integer getConAlarma() {
		return conAlarma;
	}

	public void setConAlarma(Integer conAlarma) {
		this.conAlarma = conAlarma;
	}

	public Date getFechaInstalacionAlarma() {
		return fechaInstalacionAlarma;
	}

	public void setFechaInstalacionAlarma(Date fechaInstalacionAlarma) {
		this.fechaInstalacionAlarma = fechaInstalacionAlarma;
	}

	public Date getFechaDesinstalacionAlarma() {
		return fechaDesinstalacionAlarma;
	}

	public void setFechaDesinstalacionAlarma(Date fechaDesinstalacionAlarma) {
		this.fechaDesinstalacionAlarma = fechaDesinstalacionAlarma;
	}

	public Integer getConVigilancia() {
		return conVigilancia;
	}

	public void setConVigilancia(Integer conVigilancia) {
		this.conVigilancia = conVigilancia;
	}

	public Date getFechaInstalacionVigilancia() {
		return fechaInstalacionVigilancia;
	}

	public void setFechaInstalacionVigilancia(Date fechaInstalacionVigilancia) {
		this.fechaInstalacionVigilancia = fechaInstalacionVigilancia;
	}

	public Date getFechaDesinstalacionVigilancia() {
		return fechaDesinstalacionVigilancia;
	}

	public void setFechaDesinstalacionVigilancia(Date fechaDesinstalacionVigilancia) {
		this.fechaDesinstalacionVigilancia = fechaDesinstalacionVigilancia;
	}

	
	

	public String getUsuarioModificarOcupado() {
		return usuarioModificarOcupado;
	}

	public void setUsuarioModificarOcupado(String usuarioModificarOcupado) {
		this.usuarioModificarOcupado = usuarioModificarOcupado;
	}

	public Date getFechaModificarOcupado() {
		return fechaModificarOcupado;
	}

	public void setFechaModificarOcupado(Date fechaModificarOcupado) {
		this.fechaModificarOcupado = fechaModificarOcupado;
	}

	public String getUsuarioModificarConTitulo() {
		return usuarioModificarConTitulo;
	}

	public void setUsuarioModificarConTitulo(String usuarioModificarConTitulo) {
		this.usuarioModificarConTitulo = usuarioModificarConTitulo;
	}

	public Date getFechaModificarConTitulo() {
		return fechaModificarConTitulo;
	}

	public void setFechaModificarConTitulo(Date fechaModificarConTitulo) {
		this.fechaModificarConTitulo = fechaModificarConTitulo;
	}

	public Integer getVertical() {
		return vertical;
	}

	public void setVertical(Integer vertical) {
		this.vertical = vertical;
	}
	
	
}
