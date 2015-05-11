package es.pfsgroup.recovery.ext.impl.itinerario.model;

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
import es.pfsgroup.recovery.ext.api.itinerario.model.EXTDDTipoInfoAdicionalItinerarioInfo;

@Entity
@Table(name = "EXT_DD_TII_TIPO_INFO_ITI", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class EXTDDTipoInfoAdicionalItinerario implements EXTDDTipoInfoAdicionalItinerarioInfo, Auditable, Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -4776881801602478742L;

	@Id
    @Column(name = "DD_TII_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EXTDDTipoInfoAdicionalItinerariooGenerator")
    @SequenceGenerator(name = "EXTDDTipoInfoAdicionalItinerariooGenerator", sequenceName = "S_EXT_DD_TII_TIPO_INFO_ITI")
    private Long id;

    @Column(name = "DD_TII_CODIGO")
    private String codigo;

    @Column(name = "DD_TII_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TII_DESCRIPCION_LARGA")
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
