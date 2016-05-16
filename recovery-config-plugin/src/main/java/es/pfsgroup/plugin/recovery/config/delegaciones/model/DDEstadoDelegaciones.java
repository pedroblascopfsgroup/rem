package es.pfsgroup.plugin.recovery.config.delegaciones.model;

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

@Entity
@Table(name="DD_EDL_ESTADO_DELEGACIONES", schema="${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class DDEstadoDelegaciones implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = -8873686715687310266L;
	
	public static final String ACTIVA = "ACTIVA";
	public static final String CERRADA = "CERRADA";
	
	@Id
	@Column(name="DD_EDL_ID")
	@GeneratedValue(strategy =  GenerationType.AUTO, generator = "DDEstadoDelegacionesGenerator")
	@SequenceGenerator(name="DDEstadoDelegacionesGenerator", sequenceName="S_DD_EDL_ESTADO_DELEGACIONES")
	private Long id;
	
	@Column(name="DD_EDL_CODIGO")
	private String codigo;
	
	@Column(name="DD_EDL_DESCRIPCION")
	private String descripcion;
	
	@Column(name="DD_EDL_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	
    @Version
    private Integer version;

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

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	@Override
	public Auditoria getAuditoria() {
		return this.auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}


}
