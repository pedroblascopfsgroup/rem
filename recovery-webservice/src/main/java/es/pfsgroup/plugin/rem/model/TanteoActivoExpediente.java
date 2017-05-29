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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDAdministracion;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;


/**
 * Modelo que gestiona la informacion de tanteo asociada a los activos de los expedientes comerciales.
 *  
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ECO_TAN_TANTEO_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class TanteoActivoExpediente implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

		
	@Id
    @Column(name = "TAN_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TanteoActivoExpedienteGenerator")
    @SequenceGenerator(name = "TanteoActivoExpedienteGenerator", sequenceName = "S_ECO_TAN_TANTEO_ACTIVO")
    private Long id;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ADM_ID")
	private DDAdministracion adminitracion;      
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DRT_ID")
	private DDResultadoTanteo resultadoTanteo; 
    
    @Column(name= "TAN_NUM_EXPEDIENTE")
    private String numExpediente;
    
    @Column(name= "TAN_CONDICIONES_TX")
    private String condicionesTx;
 
    @Column(name = "TAN_FECHA_FIN_TANTEO")
    private Date fechaFinTanteo;
    
    @Column(name = "TAN_FECHA_COMUNICACION")
    private Date fechaComunicacion;
    
    @Column(name="TAN_FECHA_CONTESTACION")
    private Date fechaContestacion;
    
    @Column(name="TAN_SOLICITUD_VISITA")
    private Integer solicitudVisita;
    
    @Column(name = "TAN_FECHA_VISITA")
    private Date fechaVisita;
    
    @Column(name = "TAN_FECHA_RESOLUCION")
    private Date fechaResolucion;
    
    @Column(name="TAN_FECHA_VENC_RESOL")
    private Date fechaVencimientoResol;
    
    
    
    
     
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
	public ExpedienteComercial getExpediente() {
		return expediente;
	}
	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}
	public Activo getActivo() {
		return activo;
	}
	public void setActivo(Activo activo) {
		this.activo = activo;
	}
	public DDAdministracion getAdminitracion() {
		return adminitracion;
	}
	public void setAdminitracion(DDAdministracion adminitracion) {
		this.adminitracion = adminitracion;
	}
	public DDResultadoTanteo getResultadoTanteo() {
		return resultadoTanteo;
	}
	public void setResultadoTanteo(DDResultadoTanteo resultadoTanteo) {
		this.resultadoTanteo = resultadoTanteo;
	}
	public String getNumExpediente() {
		return numExpediente;
	}
	public void setNumExpediente(String numExpediente) {
		this.numExpediente = numExpediente;
	}
	public String getCondicionesTx() {
		return condicionesTx;
	}
	public void setCondicionesTx(String condicionesTx) {
		this.condicionesTx = condicionesTx;
	}
	public Date getFechaFinTanteo() {
		return fechaFinTanteo;
	}
	public void setFechaFinTanteo(Date fechaFinTanteo) {
		this.fechaFinTanteo = fechaFinTanteo;
	}
	public Date getFechaComunicacion() {
		return fechaComunicacion;
	}
	public void setFechaComunicacion(Date fechaComunicacion) {
		this.fechaComunicacion = fechaComunicacion;
	}
	public Date getFechaContestacion() {
		return fechaContestacion;
	}
	public void setFechaContestacion(Date fechaContestacion) {
		this.fechaContestacion = fechaContestacion;
	}
	public Integer getSolicitudVisita() {
		return solicitudVisita;
	}
	public void setSolicitudVisita(Integer solicitudVisita) {
		this.solicitudVisita = solicitudVisita;
	}
	public Date getFechaVisita() {
		return fechaVisita;
	}
	public void setFechaVisita(Date fechaVisita) {
		this.fechaVisita = fechaVisita;
	}
	public Date getFechaResolucion() {
		return fechaResolucion;
	}
	public void setFechaResolucion(Date fechaResolucion) {
		this.fechaResolucion = fechaResolucion;
	}
	public Date getFechaVencimientoResol() {
		return fechaVencimientoResol;
	}
	public void setFechaVencimientoResol(Date fechaVencimientoResol) {
		this.fechaVencimientoResol = fechaVencimientoResol;
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
    
}
