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
 * Modelo que gestiona el diccionario de tipos de incidencia.
 * 
 * @author Daniel Gutiérrez
 *
 */
@Entity
@Table(name = "DD_TIN_TIPO_INCI", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoIncidencia implements Auditable, Dictionary {
    
    public static final String CODIGO_EQUIPO_TECNICO = "01";
    public static final String CODIGO_GESTION_COMERCIAL = "02";
    public static final String CODIGO_GESTION_OCUPACIONAL = "03";
    public static final String CODIGO_GESTION_RECUPERACIONES = "04";
    public static final String CODIGO_FIRMA = "05";
    public static final String CODIGO_SIN_GESTION = "06";
    public static final String CODIGO_INCIDENCIA = "07";    
    
    
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_TIN_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoIncidenciaGenerator")
	@SequenceGenerator(name = "DDTipoIncidenciaGenerator", sequenceName = "S_DD_TIN_TIPO_INCI")
	private Long id;
	    
	@Column(name = "DD_TIN_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TIN_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TIN_DESCRIPCION_LARGA")   
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