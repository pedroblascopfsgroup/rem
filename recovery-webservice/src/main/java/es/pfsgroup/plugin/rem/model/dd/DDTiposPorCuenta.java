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
 * Modelo que gestiona el diccionario de tipos por cuenta de
 * 
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "DD_TPC_TIPOS_PORCUENTA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTiposPorCuenta implements Auditable, Dictionary {
	

	private static final long serialVersionUID = 1L;
	
	public final static String TIPOS_POR_CUENTA_COMPRADOR = "01";
	public final static String TIPOS_POR_CUENTA_VENDEDOR = "02";
	public final static String TIPOS_POR_CUENTA_SEGUN_LEY = "03";
	public final static String TIPOS_POR_CUENTA_ARRENDADOR = "04";
	public final static String TIPOS_POR_CUENTA_ARRENDATARIO = "05";

	@Id
	@Column(name = "DD_TPC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTiposPorCuenta")
	@SequenceGenerator(name = "DDTiposPorCuenta", sequenceName = "S_DD_TPC_TIPOS_PORCUENTA")
	private Long id;
	    
	@Column(name = "DD_TPC_CODIGO")   
	private String codigo;
    
	@Column(name = "DD_TPC_CODIGO_C4C")   
	private String codigoC4C;
		 
	@Column(name = "DD_TPC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TPC_DESCRIPCION_LARGA")   
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

	public String getCodigoC4C() {
		return codigoC4C;
	}

	public void setCodigoC4C(String codigoC4C) {
		this.codigoC4C = codigoC4C;
	}

	
}