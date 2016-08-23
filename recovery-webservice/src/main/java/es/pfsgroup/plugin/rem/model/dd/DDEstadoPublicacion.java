package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de estados de publicación.
 * 
 * @author Daniel Gutiérrez
 *
 */
@Entity
@Table(name = "DD_EPU_ESTADO_PUBLICACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadoPublicacion implements Auditable, Dictionary {
	
    public static final String CODIGO_PUBLICADO = "01";
    public static final String CODIGO_PUBLICADO_FORZADO = "02";
    public static final String CODIGO_PUBLICADO_OCULTO = "03";
    public static final String CODIGO_PUBLICADO_PRECIOOCULTO = "04";
    public static final String CODIGO_DESPUBLICADO = "05";
    public static final String CODIGO_NO_PUBLICADO = "06";
    
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_EPU_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoPublicacionGenerator")
	@SequenceGenerator(name = "DDEstadoPublicacionGenerator", sequenceName = "S_DD_EPU_ESTADO_PUBLICACION")
	private Long id;
	    
	@Column(name = "DD_EPU_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_EPU_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_EPU_DESCRIPCION_LARGA")   
	private String descripcionLarga;	    

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

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
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