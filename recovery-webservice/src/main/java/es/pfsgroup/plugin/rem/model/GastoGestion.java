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
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionHaya;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionPropietario;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionGasto;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAutorizacionPropietario;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoAutorizacionHaya;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRetencionPago;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;


/**
 * Modelo que gestiona la informacion de la gestión de un gasto
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "GGE_GASTOS_GESTION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class GastoGestion implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "GGE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoGestionGenerator")
    @SequenceGenerator(name = "GastoGestionGenerator", sequenceName = "S_GGE_GASTOS_GESTION")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID")
    private GastoProveedor gastoProveedor;
    
    @Column(name="GGE_AUTORIZACION_PROPIETARIO")
    private Integer autorizaPropietario;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="DD_MAP_ID")
    private DDMotivoAutorizacionPropietario motivoAutorizacionPropietario;
    
    @Column(name="GGE_OBSERVACIONES")
    private String observaciones;
    
    @Column(name="GGE_FECHA_ALTA")
    private Date fechaAlta;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="USU_ID_ALTA")
    private Usuario usuarioAlta;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="DD_EAH_ID")
    private DDEstadoAutorizacionHaya estadoAutorizacionHaya;
    
    @Column(name="GGE_FECHA_EAH")
    private Date fechaEstadoAutorizacionHaya;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="USU_ID_EAH")
    private Usuario usuarioEstadoAutorizacionHaya;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="DD_MRH_ID")
    private DDMotivoRechazoAutorizacionHaya motivoRechazoAutorizacionHaya;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="DD_EAP_ID")
    private DDEstadoAutorizacionPropietario estadoAutorizacionPropietario;
    
    @Column(name="GGE_FECHA_EAP")
    private Date fechaEstadoAutorizacionPropietario;
    
    @Column(name="GGE_MOTIVO_RECHAZO_PROP")
    private String motivoRechazoAutorizacionPropietario;
    
    @Column(name="GGE_FECHA_ANULACION")
    private Date fechaAnulacionGasto;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="USU_ID_ANULACION")
    private Usuario usuarioAnulacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="DD_MAG_ID")
    private DDMotivoAnulacionGasto motivoAnulacion;
    
    @Column(name="GGE_FECHA_RP")
    private Date fechaRetencionPago;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="USU_ID_RP")
    private Usuario usuarioRetencionPago;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="DD_MRP_ID")
    private DDMotivoRetencionPago motivoRetencionPago;
    
    @Column(name="GGE_FECHA_ENVIO_GESTORIA")
    private Date fechaEnvioGestoria;
    
    @Column(name="GGE_FECHA_ENVIO_PRPTRIO")
    private Date fechaEnvioPropietario;
    
    @Column(name="GGE_FECHA_RECEPCION_GESTORIA")
    private Date fechaRecepcionGestoria;
    
    @Column(name="GGE_FECHA_RECEPCION_PRPTRIO")
    private Date fechaRecepcionPropietario;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="GGE_REPERCUTIDO")
    private DDSinSiNo gestionGastoRepercutido;
    
    @Column(name="GGE_FECHA_REPERCUSION")
    private Date fechaGestionGastoRepercusion;
    
    @Column(name="GGE_MOTIVO_RECHAZO")
    private String motivoRechazoGestionGasto;
    
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

	public GastoProveedor getGastoProveedor() {
		return gastoProveedor;
	}

	public void setGastoProveedor(GastoProveedor gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}

	public Integer getAutorizaPropietario() {
		return autorizaPropietario;
	}

	public void setAutorizaPropietario(Integer autorizaPropietario) {
		this.autorizaPropietario = autorizaPropietario;
	}

	public DDMotivoAutorizacionPropietario getMotivoAutorizacionPropietario() {
		return motivoAutorizacionPropietario;
	}

	public void setMotivoAutorizacionPropietario(
			DDMotivoAutorizacionPropietario motivoAutorizacionPropietario) {
		this.motivoAutorizacionPropietario = motivoAutorizacionPropietario;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Usuario getUsuarioAlta() {
		return usuarioAlta;
	}

	public void setUsuarioAlta(Usuario usuarioAlta) {
		this.usuarioAlta = usuarioAlta;
	}

	public DDEstadoAutorizacionHaya getEstadoAutorizacionHaya() {
		return estadoAutorizacionHaya;
	}

	public void setEstadoAutorizacionHaya(
			DDEstadoAutorizacionHaya estadoAutorizacionHaya) {
		this.estadoAutorizacionHaya = estadoAutorizacionHaya;
	}

	public Date getFechaEstadoAutorizacionHaya() {
		return fechaEstadoAutorizacionHaya;
	}

	public void setFechaEstadoAutorizacionHaya(Date fechaEstadoAutorizacionHaya) {
		this.fechaEstadoAutorizacionHaya = fechaEstadoAutorizacionHaya;
	}

	public Usuario getUsuarioEstadoAutorizacionHaya() {
		return usuarioEstadoAutorizacionHaya;
	}

	public void setUsuarioEstadoAutorizacionHaya(
			Usuario usuarioEstadoAutorizacionHaya) {
		this.usuarioEstadoAutorizacionHaya = usuarioEstadoAutorizacionHaya;
	}

	public DDMotivoRechazoAutorizacionHaya getMotivoRechazoAutorizacionHaya() {
		return motivoRechazoAutorizacionHaya;
	}

	public void setMotivoRechazoAutorizacionHaya(
			DDMotivoRechazoAutorizacionHaya motivoRechazoAutorizacionHaya) {
		this.motivoRechazoAutorizacionHaya = motivoRechazoAutorizacionHaya;
	}

	public DDEstadoAutorizacionPropietario getEstadoAutorizacionPropietario() {
		return estadoAutorizacionPropietario;
	}

	public void setEstadoAutorizacionPropietario(
			DDEstadoAutorizacionPropietario estadoAutorizacionPropietario) {
		this.estadoAutorizacionPropietario = estadoAutorizacionPropietario;
	}

	public Date getFechaEstadoAutorizacionPropietario() {
		return fechaEstadoAutorizacionPropietario;
	}

	public void setFechaEstadoAutorizacionPropietario(
			Date fechaEstadoAutorizacionPropietario) {
		this.fechaEstadoAutorizacionPropietario = fechaEstadoAutorizacionPropietario;
	}

	public String getMotivoRechazoAutorizacionPropietario() {
		return motivoRechazoAutorizacionPropietario;
	}

	public void setMotivoRechazoAutorizacionPropietario(
			String motivoRechazoAutorizacionPropietario) {
		this.motivoRechazoAutorizacionPropietario = motivoRechazoAutorizacionPropietario;
	}

	public Date getFechaAnulacionGasto() {
		return fechaAnulacionGasto;
	}

	public void setFechaAnulacionGasto(Date fechaAnulacionGasto) {
		this.fechaAnulacionGasto = fechaAnulacionGasto;
	}

	public Usuario getUsuarioAnulacion() {
		return usuarioAnulacion;
	}

	public void setUsuarioAnulacion(Usuario usuarioAnulacion) {
		this.usuarioAnulacion = usuarioAnulacion;
	}

	public DDMotivoAnulacionGasto getMotivoAnulacion() {
		return motivoAnulacion;
	}

	public void setMotivoAnulacion(DDMotivoAnulacionGasto motivoAnulacion) {
		this.motivoAnulacion = motivoAnulacion;
	}

	public Date getFechaRetencionPago() {
		return fechaRetencionPago;
	}

	public void setFechaRetencionPago(Date fechaRetencionPago) {
		this.fechaRetencionPago = fechaRetencionPago;
	}

	public Usuario getUsuarioRetencionPago() {
		return usuarioRetencionPago;
	}

	public void setUsuarioRetencionPago(Usuario usuarioRetencionPago) {
		this.usuarioRetencionPago = usuarioRetencionPago;
	}

	public DDMotivoRetencionPago getMotivoRetencionPago() {
		return motivoRetencionPago;
	}

	public void setMotivoRetencionPago(DDMotivoRetencionPago motivoRetencionPago) {
		this.motivoRetencionPago = motivoRetencionPago;
	}

	public Date getFechaEnvioGestoria() {
		return fechaEnvioGestoria;
	}

	public void setFechaEnvioGestoria(Date fechaEnvioGestoria) {
		this.fechaEnvioGestoria = fechaEnvioGestoria;
	}

	public Date getFechaEnvioPropietario() {
		return fechaEnvioPropietario;
	}

	public void setFechaEnvioPropietario(Date fechaEnvioPropietario) {
		this.fechaEnvioPropietario = fechaEnvioPropietario;
	}

	public Date getFechaRecepcionGestoria() {
		return fechaRecepcionGestoria;
	}

	public void setFechaRecepcionGestoria(Date fechaRecepcionGestoria) {
		this.fechaRecepcionGestoria = fechaRecepcionGestoria;
	}

	public Date getFechaRecepcionPropietario() {
		return fechaRecepcionPropietario;
	}

	public void setFechaRecepcionPropietario(Date fechaRecepcionPropietario) {
		this.fechaRecepcionPropietario = fechaRecepcionPropietario;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
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

	public DDSinSiNo getGestionGastoRepercutido() {
		return gestionGastoRepercutido;
	}

	public void setGestionGastoRepercutido(DDSinSiNo gestionGastoRepercutido) {
		this.gestionGastoRepercutido = gestionGastoRepercutido;
	}

	public Date getFechaGestionGastoRepercusion() {
		return fechaGestionGastoRepercusion;
	}

	public void setFechaGestionGastoRepercusion(Date fechaGestionGastoRepercusion) {
		this.fechaGestionGastoRepercusion = fechaGestionGastoRepercusion;
	}

	public String getMotivoRechazoGestionGasto() {
		return motivoRechazoGestionGasto;
	}

	public void setMotivoRechazoGestionGasto(String motivoRechazoGestionGasto) {
		this.motivoRechazoGestionGasto = motivoRechazoGestionGasto;
	}
	
}
