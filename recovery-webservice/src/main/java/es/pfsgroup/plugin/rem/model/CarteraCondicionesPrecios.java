package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCondicionIndicadorPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPropuestaPrecio;

/**
 * Modelo que gestiona la información de la relación entre carteras, condiciones y precios.
 */
@Entity
@Table(name = "CCP_CARTERA_CONDIC_PRECIOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class CarteraCondicionesPrecios implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "CCP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CarteraCondicionesPreciosGenerator")
    @SequenceGenerator(name = "CarteraCondicionesPreciosGenerator", sequenceName = "S_CCP_CARTERA_CONDIC_PRECIOS")
    private Long id;	

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRA_ID")
	private DDCartera cartera;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TPP_ID")
	private DDTipoPropuestaPrecio propuestaPrecio;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CIP_ID")
  	private DDCondicionIndicadorPrecio condicionIndicadorPrecio;

	@Column(name = "CCP_MAYOR_QUE")
	private String mayorQue;

	@Column(name = "CCP_MENOR_QUE")
	private String menorQue;

	@Column(name = "CCP_IGUAL_A")
	private String igualQue;

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

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDTipoPropuestaPrecio getPropuestaPrecio() {
		return propuestaPrecio;
	}

	public void setPropuestaPrecio(DDTipoPropuestaPrecio propuestaPrecio) {
		this.propuestaPrecio = propuestaPrecio;
	}

	public DDCondicionIndicadorPrecio getCondicionIndicadorPrecio() {
		return condicionIndicadorPrecio;
	}

	public void setCondicionIndicadorPrecio(DDCondicionIndicadorPrecio condicionIndicadorPrecio) {
		this.condicionIndicadorPrecio = condicionIndicadorPrecio;
	}

	public String getMayorQue() {
		return mayorQue;
	}

	public void setMayorQue(String mayorQue) {
		this.mayorQue = mayorQue;
	}

	public String getMenorQue() {
		return menorQue;
	}

	public void setMenorQue(String menorQue) {
		this.menorQue = menorQue;
	}

	public String getIgualQue() {
		return igualQue;
	}

	public void setIgualQue(String igualQue) {
		this.igualQue = igualQue;
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