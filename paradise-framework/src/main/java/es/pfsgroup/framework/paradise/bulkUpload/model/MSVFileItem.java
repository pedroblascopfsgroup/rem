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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.Where;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;


/**
 * Entidad para almacenar ficheros en base de datos.
 * @author manuel
 *
 */
@Entity
@Table(name = "MSV_TMP_FILES", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class MSVFileItem implements Auditable, Serializable{

	private static final long serialVersionUID = -8776052240901128408L;

    @Id
    @Column(name = "MSV_TMP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVFileItemGenerator")
    @SequenceGenerator(name = "MSVFileItemGenerator", sequenceName = "S_MSV_TMP_FILES")
    private Long id;
    
    @Column(name = "MSV_TMP_FICHERO", nullable = true)
    @Type(type = "es.capgemini.devon.hibernate.dao.BlobStreamType")
    private FileItem fileItem;
    
    @Column(name = "MSV_TMP_NOMBRE")
    private String nombre;
    
    @Column(name = "MSV_TMP_CONTENT")
    private String contentType;
    
    @ManyToOne
	@JoinColumn(name = "DD_TFA_ID", nullable = true)
	private DDTipoFicheroAdjunto tipoFichero;
    
    

	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public FileItem getFileItem() {
		return fileItem;
	}

	public void setFileItem(FileItem fileItem) {
		this.fileItem = fileItem;
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

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	
	public DDTipoFicheroAdjunto getTipoFichero() {
		return tipoFichero;
	}

	public void setTipoFichero(DDTipoFicheroAdjunto tipoFichero) {
		this.tipoFichero = tipoFichero;
	}
    
}
