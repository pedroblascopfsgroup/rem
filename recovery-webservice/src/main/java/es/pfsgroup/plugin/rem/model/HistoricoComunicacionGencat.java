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
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDSancionGencat;

/**
 * Modelo que gestiona el historico de las comunicaciones con GENCAT.
 * 
 * @author Isidro Sotoca
 */
@Entity
@Table(name = "ACT_HCG_HIST_COM_GENCAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class HistoricoComunicacionGencat implements Serializable, Auditable {

	private static final long serialVersionUID = 2475044665035356775L;
	
	@Id
    @Column(name = "HCG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoComunicacionGencatGenerator")
    @SequenceGenerator(name = "HistoricoComunicacionGencatGenerator", sequenceName = "S_ACT_HCG_HIST_COM_GENCAT")
    private Long id;
	
	@Column(name = "HCG_FECHA_INI")
	private Date fechaInicio;
	
	@Column(name = "HCG_FECHA_FIN")
	private Date fechaFin;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

    @Column(name = "HCG_FECHA_PREBLOQUEO")
	private Date fechaPreBloqueo;
    
    @Column(name = "HCG_FECHA_COMUNICACION")
	private Date fechaComunicacion;
    
    @Column(name = "HCG_FECHA_PREV_SANCION")
	private Date fechaPrevSancion;
    
    @Column(name = "HCG_FECHA_SANCION")
	private Date fechaSancion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SAN_ID")
    private DDSancionGencat sancion;
    
    @Column(name = "HCG_COMPRADOR_NIF")
	private String nifComprador;
    
    @Column(name = "HCG_COMPRADOR_NOMBRE")
	private String nombreComprador;
    
    @Column(name = "HCG_COMPRADOR_APELLIDO1")
	private String compradorApellido1;
    
    @Column(name = "HCG_COMPRADOR_APELLIDO2")
	private String compradorApellido2;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ECG_ID")
    private DDEstadoComunicacionGencat estadoComunicacion;
    
    @Column(name = "HCG_FECHA_ANULACION")
	private Date fechaAnulacion;
    
    @Column(name = "HCG_CHECK_ANULACION")
	private Boolean anulacion;
    
    @Version   
	private Long version;
    
    @Embedded
	private Auditoria auditoria;
    
    @OneToMany(mappedBy = "historicoComunicacionGencat", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "HCG_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<HistoricoComunicacionGencatAdjunto> adjuntos;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public Date getFechaPreBloqueo() {
		return fechaPreBloqueo;
	}

	public void setFechaPreBloqueo(Date fechaPreBloqueo) {
		this.fechaPreBloqueo = fechaPreBloqueo;
	}

	public Date getFechaComunicacion() {
		return fechaComunicacion;
	}

	public void setFechaComunicacion(Date fechaComunicacion) {
		this.fechaComunicacion = fechaComunicacion;
	}

	public Date getFechaPrevSancion() {
		return fechaPrevSancion;
	}

	public void setFechaPrevSancion(Date fechaPrevSancion) {
		this.fechaPrevSancion = fechaPrevSancion;
	}

	public Date getFechaSancion() {
		return fechaSancion;
	}

	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}

	public DDSancionGencat getSancion() {
		return sancion;
	}

	public void setSancion(DDSancionGencat sancion) {
		this.sancion = sancion;
	}

	public String getNifComprador() {
		return nifComprador;
	}

	public void setNifComprador(String nifComprador) {
		this.nifComprador = nifComprador;
	}

	public String getNombreComprador() {
		return nombreComprador;
	}

	public void setNombreComprador(String nombreComprador) {
		this.nombreComprador = nombreComprador;
	}

	public String getCompradorApellido1() {
		return compradorApellido1;
	}

	public void setCompradorApellido1(String compradorApellido1) {
		this.compradorApellido1 = compradorApellido1;
	}

	public String getCompradorApellido2() {
		return compradorApellido2;
	}

	public void setCompradorApellido2(String compradorApellido2) {
		this.compradorApellido2 = compradorApellido2;
	}

	public DDEstadoComunicacionGencat getEstadoComunicacion() {
		return estadoComunicacion;
	}

	public void setEstadoComunicacion(DDEstadoComunicacionGencat estadoComunicacion) {
		this.estadoComunicacion = estadoComunicacion;
	}

	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}

	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
	}

	public Boolean getAnulacion() {
		return anulacion;
	}

	public void setAnulacion(Boolean anulacion) {
		this.anulacion = anulacion;
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

	public List<HistoricoComunicacionGencatAdjunto> getAdjuntos() {
		return adjuntos;
	}

	public void setAdjuntos(List<HistoricoComunicacionGencatAdjunto> adjuntos) {
		this.adjuntos = adjuntos;
	}
	
	/**
     * Agrega un adjunto a la comunicacion
     * @param id id
     */
    /*public void addAdjunto(FileItem fileItem) {
		ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo(fileItem);
		adjuntoActivo.setActivo(this);
        Auditoria.save(adjuntoActivo);
        getAdjuntos().add(adjuntoActivo);

    }*/
    
    /**
     * devuelve el adjunto por Id.
     * @param id ComunicacionGencat
     * @return adjunto
     */
    /*public ComunicacionGencatAdjunto getAdjunto(Long id) {
        for (ActivoAdjuntoActivo adj : getAdjuntos()) {
            if (adj.getId().equals(id)) { return adj; }
        }
        return null;
    }*/
    
	/**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    /*public ActivoAdjuntoActivo getAdjuntoGD(Long idDocRestClient) {
    	for (ActivoAdjuntoActivo adj : getAdjuntos()) {
    		if(!Checks.esNulo(adj.getIdDocRestClient()) && adj.getIdDocRestClient().equals(idDocRestClient)) { return adj; }
        }
        return null;
    }*/

}
