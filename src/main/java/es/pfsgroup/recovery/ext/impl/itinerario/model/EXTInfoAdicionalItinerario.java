package es.pfsgroup.recovery.ext.impl.itinerario.model;

import java.io.Serializable;

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
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.pfsgroup.recovery.ext.api.itinerario.model.EXTInfoAdicionalItinerarioInfo;

@Entity
@Table(name = "EXT_IAI_INFO_ADD_ITI", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class EXTInfoAdicionalItinerario implements Serializable, Auditable, EXTInfoAdicionalItinerarioInfo{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -8630100829648158942L;

	@Id
	@Column(name = "IAI_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "EXTInfoAdicionalItinerarioGenerator")
	@SequenceGenerator(name = "EXTInfoAdicionalItinerarioGenerator", sequenceName = "S_EXT_IAI_INFO_ADD_ITI")
	private Long id;
	
	@ManyToOne
    @JoinColumn(name = "ITI_ID")
	private Itinerario itinerario;
	
	@ManyToOne
    @JoinColumn(name = "DD_TII_ID")
	private EXTDDTipoInfoAdicionalItinerario tipoInfoAdicional;
	
	@Column(name="IAI_VALUE")
	private String value;
	
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

	public Itinerario getItinerario() {
		return itinerario;
	}

	public void setItinerario(Itinerario itinerario) {
		this.itinerario = itinerario;
	}

	public EXTDDTipoInfoAdicionalItinerario getTipoInfoAdicional() {
		return tipoInfoAdicional;
	}

	public void setTipoInfoAdicional(
			EXTDDTipoInfoAdicionalItinerario tipoInfoAdicional) {
		this.tipoInfoAdicional = tipoInfoAdicional;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
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
