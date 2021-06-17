package es.pfsgroup.plugin.rem.model.dd;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;


@Entity
@Table(name = "DD_CVC_CARTERA_VENTA_CREDITOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDCarteraVentaCreditos implements Auditable, Serializable {
	
		
	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_EARTH="1";
	public static final String CODIGO_FIRE="2";
	public static final String CODIGO_NEWTON="3";
	public static final String CODIGO_MATCH="4";
	public static final String CODIGO_MARSHMELLO="5";
	public static final String CODIGO_JETS="6";
	public static final String CODIGO_SKY="7";
	public static final String CODIGO_TIZONA="8";
	public static final String CODIGO_ELYSIUM="9";
	public static final String CODIGO_GIANTS="10";

	@Id
	@Column(name = "DD_CVC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDCarteraVentaCreditosGenerator")
	@SequenceGenerator(name = "DDCarteraVentaCreditosGenerator", sequenceName = "S_DD_CVC_CARTERA_VENTA_CREDITOS")
	private Long id;
	 
	@Column(name = "DD_CVC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_CVC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_CVC_DESCRIPCION_LARGA")   
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
