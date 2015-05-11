package es.pfsgroup.plugin.recovery.masivo.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


/**
 * Clase que modela un lote
 * @author manuel
 *
 */
@Entity
@Table(name = "LOT_LOTE", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVLote implements Serializable, Auditable{

	private static final long serialVersionUID = -4918480199449262484L;
	
	@Id
    @Column(name = "LOT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVLoteGenerator")
    @SequenceGenerator(name = "MSVLoteGenerator", sequenceName = "S_LOT_LOTE")
    private Long id;

    @Column(name = "LOT_DESCRIPCION")
    private String descripcion;

    @Column(name = "LOT_DESCRIPCION_LARGA")
    private String descripcionLarga;

	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

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

}
