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


@Entity
@Table(name = "DD_TTC_TIPO_TITULO_COMPLEM", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoTituloComplemento implements Auditable, Dictionary{

	
	public static final String CODIGO_INSTANCIAS_TRACTO = "INSTR";
	public static final String CODIGO_INSTANCIAS_LIBERTAD_ARRENDATICIAS = "INSLA";
	public static final String CODIGO_ACTA_FINAL_OBRA = "ACTFO";
	public static final String CODIGO_DIVISION_HORIZONTAL = "DIVHO";
	public static final String CODIGO_MANDAMIENTOS_CANCELCION = "MANCAN";
	public static final String CODIGO_NOTIFICACION_ARRENDATARIO = "NOTIFARR";
	public static final String CODIGO_RATIFICACION_TITULO = "RATTIT";
	public static final String CODIGO_OTROS = "OTR";
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	 @Id
	 @Column(name = "DD_TTC_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoTituloComplementoGenerator")
	 @SequenceGenerator(name = "DDTipoTituloComplementoGenerator", sequenceName = "S_DD_TTC_TIPO_TITULO_COMPLEM")
	 private Long id;
	    
	 @Column(name = "DD_TTC_DESCRIPCION")   
	 private String descripcion;
	    
	 @Column(name = "DD_TTC_DESCRIPCION_LARGA")   
	 private String descripcionLarga;
	    
	 @Column(name = "DD_TTC_CODIGO")   
	 private String codigo;
	    
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



	 
}


