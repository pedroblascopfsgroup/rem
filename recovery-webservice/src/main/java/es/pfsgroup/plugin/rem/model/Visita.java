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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisita;
import es.pfsgroup.plugin.rem.model.dd.DDSubEstadosVisita;


/**
 * Modelo que gestiona la informacion de una visita
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "VIS_VISITAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class Visita implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "VIS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "VisitaGenerator")
    @SequenceGenerator(name = "VisitaGenerator", sequenceName = "S_VIS_VISITAS")
    private Long id;
	
    @Column(name = "VIS_NUM_VISITA")
    private Long numVisitaRem;
    
    @Column(name = "VIS_WEBCOM_ID")
    private Long idVisitaWebcom;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CLC_ID")
    private ClienteComercial cliente;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EVI_ID")
	private DDEstadosVisita estadoVisita;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SVI_ID")
	private DDSubEstadosVisita subEstadoVisita;
    
    @Column(name="VIS_FECHA_VISITA")
    private Date fechaVisita;   
    
    @Column(name="VIS_FECHA_CONCERTACION")
    private Date fechaConcertacion;
    
    @Column(name="VIS_FECHA_SOLICTUD")
    private Date fechaSolicitud;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID")
    private Usuario usuarioAccion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_PRESCRIPTOR")
	private ActivoProveedor prescriptor;
 
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_API_RESPONSABLE")
	private ActivoProveedor apiResponsable;    
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_API_CUSTODIO")
	private ActivoProveedor apiCustodio;    

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_FDV")
	private ActivoProveedor fdv; 
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_PVE_VISITA")
	private ActivoProveedor proveedorVisita; 
    
    @Column(name="VIS_OBSERVACIONES")
    private String observaciones;
    
    
    
    
    
/*    @Column(name="VIS_VISITA_PRESCRIPTOR")
    private Integer realizaVisitaPrescriptor;   
    
    @Column(name="VIS_VISITA_API_RESPONSABLE")
    private Integer realizaVisitaApiResponsable;    
    
    @Column(name="VIS_VISITA_API_CUSTODIO")
    private Integer realizaVisitaApiCustodio;*/
    
    
    
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

	public Long getNumVisitaRem() {
		return numVisitaRem;
	}

	public void setNumVisitaRem(Long numVisitaRem) {
		this.numVisitaRem = numVisitaRem;
	}

	public Long getIdVisitaWebcom() {
		return idVisitaWebcom;
	}

	public void setIdVisitaWebcom(Long idVisitaWebcom) {
		this.idVisitaWebcom = idVisitaWebcom;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public ClienteComercial getCliente() {
		return cliente;
	}

	public void setCliente(ClienteComercial cliente) {
		this.cliente = cliente;
	}

	public DDEstadosVisita getEstadoVisita() {
		return estadoVisita;
	}

	public void setEstadoVisita(DDEstadosVisita estadoVisita) {
		this.estadoVisita = estadoVisita;
	}

	public DDSubEstadosVisita getSubEstadoVisita() {
		return subEstadoVisita;
	}

	public void setSubEstadoVisita(DDSubEstadosVisita subEstadoVisita) {
		this.subEstadoVisita = subEstadoVisita;
	}

	public Date getFechaVisita() {
		return fechaVisita;
	}

	public void setFechaVisita(Date fechaVisita) {
		this.fechaVisita = fechaVisita;
	}
	
	public Date getFechaConcertacion() {
		return fechaConcertacion;
	}

	public void setFechaConcertacion(Date fechaConcertacion) {
		this.fechaConcertacion = fechaConcertacion;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Usuario getUsuarioAccion() {
		return usuarioAccion;
	}

	public void setUsuarioAccion(Usuario usuarioAccion) {
		this.usuarioAccion = usuarioAccion;
	}

	public ActivoProveedor getPrescriptor() {
		return prescriptor;
	}

	public void setPrescriptor(ActivoProveedor prescriptor) {
		this.prescriptor = prescriptor;
	}
	
	public ActivoProveedor getApiResponsable() {
		return apiResponsable;
	}

	public void setApiResponsable(ActivoProveedor apiResponsable) {
		this.apiResponsable = apiResponsable;
	}
	
	public ActivoProveedor getFdv() {
		return fdv;
	}

	public void setFdv(ActivoProveedor fdv) {
		this.fdv = fdv;
	}

	public ActivoProveedor getProveedorVisita() {
		return proveedorVisita;
	}

	public void setProveedorVisita(ActivoProveedor proveedorVisita) {
		this.proveedorVisita = proveedorVisita;
	}

	public ActivoProveedor getApiCustodio() {
		return apiCustodio;
	}

	public void setApiCustodio(ActivoProveedor apiCustodio) {
		this.apiCustodio = apiCustodio;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	/*public Integer getRealizaVisitaPrescriptor() {
		return realizaVisitaPrescriptor;
	}

	public void setRealizaVisitaPrescriptor(Integer realizaVisitaPrescriptor) {
		this.realizaVisitaPrescriptor = realizaVisitaPrescriptor;
	}
	
	public Integer getRealizaVisitaApiResponsable() {
		return realizaVisitaApiResponsable;
	}

	public void setRealizaVisitaApiResponsable(Integer realizaVisitaApiResponsable) {
		this.realizaVisitaApiResponsable = realizaVisitaApiResponsable;
	}
	
	public Integer getRealizaVisitaApiCustodio() {
		return realizaVisitaApiCustodio;
	}

	public void setRealizaVisitaApiCustodio(Integer realizaVisitaApiCustodio) {
		this.realizaVisitaApiCustodio = realizaVisitaApiCustodio;
	}*/
	
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
    
    
    
    
   
}
