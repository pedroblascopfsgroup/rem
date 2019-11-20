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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de los tipos de solicitud de tributo
 * 
 * @author Juanjo Arbona
 *
 */
@Entity
@Table(name = "DD_TST_TIPO_SOLICITUD_TRIB", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoSolicitudTributo implements Auditable, Dictionary {
	
	
	public static final String COD_DERIVACION_DEUDA ="01";
	public static final String COD_HIPOTECA_LEGAL ="02";
	public static final String COD_SANCION ="03";
	public static final String COD_MULTA_COERCITIVA ="04";
	public static final String COD_SOL_BONIFICACION ="05";
	public static final String COD_SOL_SUSPENSION ="06";

	private static final long serialVersionUID = 2307957295534774606L;

	@Id
	@Column(name = "DD_TST_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoActivoGenerator")
	@SequenceGenerator(name = "DDTipoActivoGenerator", sequenceName = "S_DD_TPA_TIPO_ACTIVO")
	private Long id;
	
	@Column(name = "DD_TST_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TST_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TST_DESCRIPCION_LARGA")   
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
