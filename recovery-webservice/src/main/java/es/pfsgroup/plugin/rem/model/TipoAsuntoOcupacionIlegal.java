package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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
import es.pfsgroup.plugin.rem.model.dd.DDTipoTenedor;


/**
 * Modelo que gestiona la informacion de los tipos de asunto de las ocupaciones ilegales
 * 
 * @author alberto.garcia@pfsgroup.es
 */
@Entity
@Table(name = "DD_TAO_OKU_TIPO_ASUNTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class TipoAsuntoOcupacionIlegal implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5094166397912165718L;

	@Id
    @Column(name = "DD_TAO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TipoAsuntoOcupacionIlegalGenerator")
    @SequenceGenerator(name = "TipoAsuntoOcupacionIlegalGenerator", sequenceName = "S_DD_TAO_OKU_TIPO_ASUNTO")
    private Long id;

	@Column(name = "DD_TAO_CODIGO")
	private String codigo;
	
	@Column(name = "DD_TAO_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "DD_TAO_DESCRIPCION_LARGA")
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
