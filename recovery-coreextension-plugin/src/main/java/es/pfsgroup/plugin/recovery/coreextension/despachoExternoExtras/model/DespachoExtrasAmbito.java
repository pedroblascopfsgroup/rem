package es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.direccion.model.DDComunidadAutonoma;
import es.capgemini.pfs.direccion.model.DDProvincia;

/**
 * PRODUCTO-1272 - Clase del ambito de actuacion del despacho (distinto al usado en turnado)
 * @author jros
 *
 */
@Entity
@Table(name = "DEA_DESPACHO_EXTRAS_AMBITO", schema = "${entity.schema}")
//@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DespachoExtrasAmbito implements Serializable, Auditable  {

	private static final long serialVersionUID = 5862786013275837589L;
	
	@Id
    @Column(name = "DEA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DespachoExtrasAmbitoGenerator")
    @SequenceGenerator(name = "DespachoExtrasAmbitoGenerator", sequenceName = "S_DEA_DESPACHO_EXTRAS_AMBITO")
	private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_PRV_ID")
	private DDProvincia provincia;
	
	@OneToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_CCA_ID")
	private DDComunidadAutonoma comunidad;
	
	@OneToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DES_ID")
	private DespachoExterno despacho;
	
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

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}

	public DDComunidadAutonoma getComunidad() {
		return comunidad;
	}

	public void setComunidad(DDComunidadAutonoma comunidad) {
		this.comunidad = comunidad;
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

	public DespachoExterno getDespacho() {
		return despacho;
	}

	public void setDespacho(DespachoExterno despacho) {
		this.despacho = despacho;
	}
}
