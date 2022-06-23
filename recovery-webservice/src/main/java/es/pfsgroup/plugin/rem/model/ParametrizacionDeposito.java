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
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;

/**
 * Modelo que gestiona la tabla de parametrizacion deposito
 * 
 * 
 * @author Javier Esbri
 */
@Entity
@Table(name = "PDE_PARAMETRIZACION_DEPOSITO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ParametrizacionDeposito implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "PDE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ParametrizacionDepositoGenerator")
	@SequenceGenerator(name = "ParametrizacionDepositoGenerator", sequenceName = "S_PDE_PARAMETRIZACION_DEPOSITO")
	private Long id;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TCR_ID")
    private DDTipoComercializar tipoComercializar;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_SCR_ID")
	private DDSubcartera subcartera;
	
	@Column(name = "PDE_IMPORTE")
	private Double importeDeposito;

	@Column(name = "PDE_PRECIO")
	private Double precioVenta;
	
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

	public DDTipoComercializar getTipoComercializar() {
		return tipoComercializar;
	}

	public void setTipoComercializar(DDTipoComercializar tipoComercializar) {
		this.tipoComercializar = tipoComercializar;
	}

	public DDSubcartera getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(DDSubcartera subcartera) {
		this.subcartera = subcartera;
	}

	public Double getImporteDeposito() {
		return importeDeposito;
	}

	public void setImporteDeposito(Double importeDeposito) {
		this.importeDeposito = importeDeposito;
	}

	public Double getPrecioVenta() {
		return precioVenta;
	}

	public void setPrecioVenta(Double precioVenta) {
		this.precioVenta = precioVenta;
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
