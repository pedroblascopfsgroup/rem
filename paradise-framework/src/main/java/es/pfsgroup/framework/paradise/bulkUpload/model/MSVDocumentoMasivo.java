package es.pfsgroup.framework.paradise.bulkUpload.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Type;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVProcesoMasivo;

@Entity
@Table(name = "DMS_DOCUMENTOS_MASIVO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVDocumentoMasivo implements Serializable, Auditable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4201419937910064521L;
	
	@Id
    @Column(name = "DMS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVDocumentosMasivoGenerator")
    @SequenceGenerator(name = "MSVDocumentosMasivoGenerator", sequenceName = "S_DMS_DOCUMENTOS_MASIVO")
    private Long id;
	
	@Column(name = "DMS_NOMBRE")
    private String nombre;
	
	@Column(name = "DMS_DIRECTORIO")
    private String directorio;
	
	@ManyToOne
    @JoinColumn(name = "PRM_ID")
    private MSVProcesoMasivo procesoMasivo;
	
	@Column(name = "DMS_CONTENIDO_FICH")
	@Type(type = "es.capgemini.devon.hibernate.dao.BlobStreamType")
	private FileItem contenidoFichero;
	
	@Column(name = "DMS_ERRORES_FICH")
	@Type(type = "es.capgemini.devon.hibernate.dao.BlobStreamType")
	private FileItem erroresFichero;
	
	@Column(name = "DMS_ERRORES_PROCESAR", nullable = true)
	@Type(type = "es.capgemini.devon.hibernate.dao.BlobStreamType")
	private FileItem erroresFicheroProcesar;
	
	@Column(name = "DMS_RESULTADO_FICH", nullable = true)
	@Type(type = "es.capgemini.devon.hibernate.dao.BlobStreamType")
	private FileItem resultadoFich;
	
	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;
    
    @Transient
    private Object[] extraArgs;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getDirectorio() {
		return directorio;
	}

	public void setDirectorio(String directorio) {
		this.directorio = directorio;
	}

	public FileItem getContenidoFichero() {
		return contenidoFichero;
	}

	public void setContenidoFichero(FileItem contenidoFichero) {
		this.contenidoFichero = contenidoFichero;
	}

	public FileItem getErroresFichero() {
		return erroresFichero;
	}

	public void setErroresFichero(FileItem erroresFichero) {
		this.erroresFichero = erroresFichero;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setProcesoMasivo(MSVProcesoMasivo procesoMasivo) {
		this.procesoMasivo = procesoMasivo;
	}

	public MSVProcesoMasivo getProcesoMasivo() {
		return procesoMasivo;
	}

	public FileItem getErroresFicheroProcesar() {
		return erroresFicheroProcesar;
	}

	public void setErroresFicheroProcesar(FileItem erroresFicheroProcesar) {
		this.erroresFicheroProcesar = erroresFicheroProcesar;
	}

	public FileItem getResultadoFich() {
		return resultadoFich;
	}

	public void setResultadoFich(FileItem resultadoFich) {
		this.resultadoFich = resultadoFich;
	}

	public Object[] getExtraArgs() {
		return extraArgs;
	}

	public void setExtraArgs(Object[] extraArgs) {
		this.extraArgs = extraArgs;
	}

	
	
}
