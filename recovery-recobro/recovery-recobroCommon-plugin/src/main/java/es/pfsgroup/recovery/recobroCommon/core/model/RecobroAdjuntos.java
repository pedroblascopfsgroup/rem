package es.pfsgroup.recovery.recobroCommon.core.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
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
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase que mapea los adjuntos utilizados por las clases de recobro
 * @author Carlos
 *
 */
@Entity
@Table(name = "REA_RECOBRO_ADJUNTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroAdjuntos implements Auditable, Serializable{
	
	private static final long serialVersionUID = 8532818719790972070L;
	public static final String TIPO_PROCESOS_FACTURACION = "Procesos facturacion";	
	public static final String TIPO_MODELO_FACTURACION_RESUMEN = "Mod. facturacion resumen";	
	public static final String TIPO_MODELO_FACTURACION_DETALLE = "Mod. facturacion detalle";
	
	@Id
    @Column(name = "REA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "RecobroAdjuntosGenerator")
	@SequenceGenerator(name = "RecobroAdjuntosGenerator", sequenceName = "S_REA_RECOBRO_ADJUNTOS")
    private Long id;

	@Column(name = "REA_FILENAME")
	private String fileName;
	
	@Column(name = "REA_CONTENT_TYPE")
	private String contentType;
	
	@Column(name = "REA_LENGTH")
	private Long length;
	
	@Column(name = "REA_FILE")
	@Type(type = "es.capgemini.devon.hibernate.dao.BlobStreamType")
	private FileItem fileItem;
	
	@Column(name = "REA_TIPO")
	private String tipo;
	
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

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public Long getLength() {
		return length;
	}

	public void setLength(Long length) {
		this.length = length;
	}

	public FileItem getFileItem() {
		FileItem fileTmp = fileItem;
		if (fileItem.getFileName() == null) fileTmp.setFileName(this.fileName);
		if (fileItem.getContentType() == null) fileTmp.setContentType(this.contentType);
		if (fileItem.getLength() == 0) fileTmp.setLength(this.length);
		return fileTmp;
	}

	public void setFileItem(FileItem fileItem) {
		this.fileItem = fileItem;
		this.setFileName(fileItem.getFileName());
		this.setContentType(fileItem.getContentType());
		this.setLength(fileItem.getLength());
	}
	
	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
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
	
	public RecobroAdjuntos() {
	}
	
	public RecobroAdjuntos(FileItem fileItem) {
		this.setFileItem(fileItem);
	}

}
