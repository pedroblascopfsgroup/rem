package es.capgemini.pfs.multigestor.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "TGP_TIPO_GESTOR_PROPIEDAD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class EXTTipoGestorPropiedad implements Auditable, Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4733220437323862147L;

	public static final String TGP_CLAVE_UNIDAD_GESTION_VALIDAS = "UG_VALIDAS";
	public static final String TGP_CLAVE_DESPACHOS_VALIDOS = "DES_VALIDOS";
	
	@Id
	@Column(name="TGP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TipoGestorPropGenerator")
	@SequenceGenerator(name = "TipoGestorPropGenerator", sequenceName = "S_TGP_TIPO_GESTOR_PROPIEDAD")
	private Long id;
	
	@OneToOne
	@JoinColumn(name="DD_TGE_ID")
	private EXTDDTipoGestor tipoGestor;
	
	@Column(name="TGP_CLAVE")
	private String clave;
	
	@Column(name="TGP_VALOR")
	private String valor;
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;
	
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public EXTDDTipoGestor getTipoGestor() {
		return tipoGestor;
	}

	public void setTipoGestor(EXTDDTipoGestor tipoGestor) {
		this.tipoGestor = tipoGestor;
	}

	public String getClave() {
		return clave;
	}

	public void setClave(String clave) {
		this.clave = clave;
	}

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
	}

}
