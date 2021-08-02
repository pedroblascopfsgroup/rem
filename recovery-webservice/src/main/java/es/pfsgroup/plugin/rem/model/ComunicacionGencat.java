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

import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDSancionGencat;

/**
 * Modelo que gestiona las comunicaciones con GENCAT.
 * 
 * @author Isidro Sotoca
 */
@Entity
@Table(name = "ACT_CMG_COMUNICACION_GENCAT", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ComunicacionGencat implements Serializable, Auditable {

	private static final long serialVersionUID = -3664785355514894637L;
	
	@Id
    @Column(name = "CMG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ComunicacionGencatGenerator")
    @SequenceGenerator(name = "ComunicacionGencatGenerator", sequenceName = "S_ACT_CMG_COMUNICACION_GENCAT")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

    @Column(name = "CMG_FECHA_PREBLOQUEO")
	private Date fechaPreBloqueo;
    
    @Column(name = "CMG_FECHA_COMUNICACION")
	private Date fechaComunicacion;
    
    @Column(name = "CMG_FECHA_PREV_SANCION")
	private Date fechaPrevistaSancion;
    
    @Column(name = "CMG_FECHA_SANCION")
	private Date fechaSancion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SAN_ID")
    private DDSancionGencat sancion;
    
    @Column(name = "CMG_COMPRADOR_NIF")
	private String nuevoCompradorNif;
    
    @Column(name = "CMG_COMPRADOR_NOMBRE")
	private String nuevoCompradorNombre;
    
    @Column(name = "CMG_COMPRADOR_APELLIDO1")
	private String nuevoCompradorApellido1;
    
    @Column(name = "CMG_COMPRADOR_APELLIDO2")
	private String nuevoCompradorApellido2;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ECG_ID")
    private DDEstadoComunicacionGencat estadoComunicacion;
    
    @Column(name = "CMG_FECHA_ANULACION")
	private Date fechaAnulacion;
    
    @Column(name = "CMG_CHECK_ANULACION")
	private Boolean comunicadoAnulacionAGencat;
    
    @Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;
	
	@OneToMany(mappedBy = "comunicacionGencat", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "CMG_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
    private List<ComunicacionGencatAdjunto> adjuntos;
	
	@OneToMany(mappedBy = "comunicacion", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "CMG_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
    private List<AdecuacionGencat> adecuaciones;
	

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

	public Date getFechaPrevistaSancion() {
		return fechaPrevistaSancion;
	}

	public void setFechaPrevistaSancion(Date fechaPrevSancion) {
		this.fechaPrevistaSancion = fechaPrevSancion;
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

	public String getNuevoCompradorNif() {
		return nuevoCompradorNif;
	}

	public void setNuevoCompradorNif(String nifComprador) {
		this.nuevoCompradorNif = nifComprador;
	}

	public String getNuevoCompradorNombre() {
		return nuevoCompradorNombre;
	}

	public void setNuevoCompradorNombre(String nombreComprador) {
		this.nuevoCompradorNombre = nombreComprador;
	}

	public String getNuevoCompradorApellido1() {
		return nuevoCompradorApellido1;
	}

	public void setNuevoCompradorApellido1(String compradorApellido1) {
		this.nuevoCompradorApellido1 = compradorApellido1;
	}

	public String getNuevoCompradorApellido2() {
		return nuevoCompradorApellido2;
	}

	public void setNuevoCompradorApellido2(String compradorApellido2) {
		this.nuevoCompradorApellido2 = compradorApellido2;
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

	public Boolean getComunicadoAnulacionAGencat() {
		return comunicadoAnulacionAGencat;
	}

	public void setComunicadoAnulacionAGencat(Boolean anulacion) {
		this.comunicadoAnulacionAGencat = anulacion;
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

	public List<ComunicacionGencatAdjunto> getAdjuntos() {
		return adjuntos;
	}

	public void setAdjuntos(List<ComunicacionGencatAdjunto> adjuntos) {
		this.adjuntos = adjuntos;
	}

	public List<AdecuacionGencat> getAdecuaciones() {
		return adecuaciones;
	}

	public void setAdecuaciones(List<AdecuacionGencat> adecuaciones) {
		this.adecuaciones = adecuaciones;
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
