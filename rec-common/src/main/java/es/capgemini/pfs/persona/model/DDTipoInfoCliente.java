package es.capgemini.pfs.persona.model;

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
 * 
 * @author diana
 *
 */
@Entity
@Table(name = "EXT_DD_IFX_INFO_EXTRA_CLI", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoInfoCliente implements Auditable, Dictionary{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -665287118664943272L;
	
	public static final String TIPO_INFO_ADICIONAL_CLIENTE_NOMINA_PENSION = "SERV_NOMINA_PENSION";
	public static final String TIPO_INFO_ADICIONAL_CLIENTE_ULTIMA_ACTUACION = "ULTIMA_ACTUACION";
	public static final String NUM_EXTRA1 = "num_extra1";
	public static final String NUM_EXTRA2 = "num_extra2";
	public static final String CHAR_EXTRA1 = "char_extra1";
	public static final String DATE_EXTRA1 = "date_extra1";
	public static final String FLAG_EXTRA1 = "flag_extra1";	

	@Id
	 @Column(name = "DD_IFX_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoInfoClienteGenerator")
	 @SequenceGenerator(name = "DDTipoInfoClienteGenerator", sequenceName = "S_EXT_DD_IFX_INFO_EXTRA_CLI")
	 private Long id;
	    
	 @Column(name = "DD_IFX_DESCRIPCION")   
	 private String descripcion;
	    
	 @Column(name = "DD_IFX_DESCRIPCION_LARGA")   
	 private String descripcionLarga;
	    
	 @Column(name = "DD_IFX_CODIGO")   
	 private String codigo;
	 
	 @Column(name = "DD_IFX_UPDATEABLE")  
	 private Boolean updateable;
	    
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

	public Boolean getUpdateable() {
		return updateable;
	}

	public void setUpdateable(Boolean updateable) {
		this.updateable = updateable;
	}

	

}
