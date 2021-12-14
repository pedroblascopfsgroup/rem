package es.pfsgroup.plugin.rem.model.dd;

import java.io.Serializable;

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
 * Modelo que gestiona el mapeo entre los diccionarios de tipo via de rem y fenix
 * 
 * @author Adrián Molina
 *
 */
@Entity
@Table(name = "DD_TVF_TIPO_VIA_FENIX", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoViaFenix implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 2307957295534774606L;

	@Id
	@Column(name = "DD_TVF_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoViaFenixGenerator")
	@SequenceGenerator(name = "DDTipoViaFenixGenerator", sequenceName = "S_DD_TVF_TIPO_VIA_FENIX")
	private Long id;
	
	@Column(name = "DD_TVF_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TVF_CODIGO_FENIX")   
	private String codigoFenix;
	        
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

	public String getCodigoFenix() {
		return codigoFenix;
	}

	public void setCodigoFenix(String codigoFenix) {
		this.codigoFenix = codigoFenix;
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
