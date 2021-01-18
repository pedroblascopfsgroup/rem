package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de los tipos de segmento de los activos
 * 
 * @author Joaquin Bahamonde
 *
 */
@Entity
@Table(name = "DD_TS_TIPO_SEGMENTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoSegmento implements Auditable, Dictionary {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_SEGMENTO_REMAINING = "01";
	public static final String CODIGO_SEGMENTO_INDUSTRIAL = "02";
	public static final String CODIGO_SEGMENTO_MACC = "03";
	public static final String CODIGO_SEGMENTO_ICE_SPV = "04";
	public static final String CODIGO_SEGMENTO_SIN_CARTERIZAR = "05";
	public static final String CODIGO_SEGMENTO_ICE = "06";
	public static final String CODIGO_SEGMENTO_INDUSTRIAL_SPV = "07";

	 @Id
	 @Column(name = "DD_TS_ID")
	 private Long id;
	    
	 @Column(name = "DD_TS_CODIGO")   
	 private String codigo;
	 
	 @Column(name = "DD_TS_DESCRIPCION")   
	 private String descripcion;
	    
	 @Column(name = "DD_TS_DESCRIPCION_LARGA")   
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



