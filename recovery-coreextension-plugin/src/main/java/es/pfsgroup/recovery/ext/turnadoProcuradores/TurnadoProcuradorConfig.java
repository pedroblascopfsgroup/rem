package es.pfsgroup.recovery.ext.turnadoProcuradores;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;

@Entity
@Table(name = "TUP_TPC_TURNADO_PROCU_CONFIG", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class TurnadoProcuradorConfig implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "TPC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "TurnadoProcuradorConfigGenerator")
	@SequenceGenerator(name = "TurnadoProcuradorConfigGenerator", sequenceName = "S_TUP_TPC_TURNADO_PROCU_CONFIG")
	private Long id;

	@OneToMany(fetch = FetchType.LAZY)
	@JoinColumn(name = "EPT_ID")
	private List<EsquemaPlazasTpo> esquemaPlazasTpo;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "USU_ID")
	private Usuario usuario;

	@Column(name = "TPC_IMPORTE_DESDE")
	private Double importeDesde;

	@Column(name = "TPC_IMPORTE_HASTA")
	private Double importeHasta;

	@Column(name = "TPC_PORCENTAJE")
	private Double porcentaje;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public List<EsquemaPlazasTpo> getEsquemaPlazasTpo() {
		return esquemaPlazasTpo;
	}

	public void setEsquemaPlazasTpo(List<EsquemaPlazasTpo> esquemaPlazasTpo) {
		this.esquemaPlazasTpo = esquemaPlazasTpo;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public Double getImporteDesde() {
		return importeDesde;
	}

	public void setImporteDesde(Double importeDesde) {
		this.importeDesde = importeDesde;
	}

	public Double getImporteHasta() {
		return importeHasta;
	}

	public void setImporteHasta(Double importeHasta) {
		this.importeHasta = importeHasta;
	}

	public Double getPorcentaje() {
		return porcentaje;
	}

	public void setPorcentaje(Double porcentaje) {
		this.porcentaje = porcentaje;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
