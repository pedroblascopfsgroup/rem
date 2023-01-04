

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
 * Modelo que gestiona el diccionario de tipos de trabajo.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_TTR_TIPO_TRABAJO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoTrabajo implements Auditable, Dictionary {
	

    public static final String CODIGO_TASACION = "01";
    public static final String CODIGO_OBTENCION_DOCUMENTAL = "02";
    public static final String CODIGO_ACTUACION_TECNICA = "03";
    public static final String CODIGO_PRECIOS = "04";
    public static final String CODIGO_PUBLICACIONES = "05";
    public static final String CODIGO_COMERCIALIZACION = "06";
    public static final String CODIGO_EDIFICACION = "07";
    public static final String CODIGO_SUELO = "08";
    public static final String CODIGO_VIGILANCIA_SEGURIDAD = "09";
    
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_TTR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoTrabajoGenerator")
	@SequenceGenerator(name = "DDTipoTrabajoGenerator", sequenceName = "S_DD_TTR_TIPO_TRABAJO")
	private Long id;
	    
	@Column(name = "DD_TTR_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TTR_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TTR_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
	@Column(name = "DD_TTR_FILTRAR")   
	private String filtrar;
	
	@Column(name = "DD_TTR_FILTRO_TRAMITE")   
	private Boolean filtroEnTramite;
	
	@Column(name = "DD_TTR_BLOQUEADO")   
	private Boolean bloqueado;
	    
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

	public String getFiltrar() {
		return filtrar;
	}

	public void setFiltrar(String filtrar) {
		this.filtrar = filtrar;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
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

	public Boolean getFiltroEnTramite() {
		return filtroEnTramite;
	}

	public void setFiltroEnTramite(Boolean filtroEnTramite) {
		this.filtroEnTramite = filtroEnTramite;
	}

	public Boolean getBloqueado() {
		return bloqueado;
	}

	public void setBloqueado(Boolean bloqueado) {
		this.bloqueado = bloqueado;
	}

	
}



