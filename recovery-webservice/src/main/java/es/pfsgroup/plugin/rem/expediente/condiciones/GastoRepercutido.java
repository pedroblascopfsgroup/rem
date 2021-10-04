package es.pfsgroup.plugin.rem.expediente.condiciones;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGastoRepercutido;


@Entity
@Table(name = "GSR_GASTO_REPERCUTIDO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class GastoRepercutido implements Serializable, Auditable{

	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "GLD_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoRepercutidoGenerator")
	@SequenceGenerator(name = "GastoRepercutidoGenerator", sequenceName = "S_GSR_GASTO_REPERCUTIDO")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COE_ID")
    private CondicionanteExpediente condicionanteExpediente;
	 
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TGR_ID")
    private DDTipoGastoRepercutido TipoGastoRepercutido;
	
	@Column(name="GSR_IMPORTE")
	private Double importe;
	
	@Column(name="GSR_FECHA")
	private Date fechaAlta;
	
	@Column(name="GSR_MESES")
	private Long meses;
	
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

	public CondicionanteExpediente getCondicionanteExpediente() {
		return condicionanteExpediente;
	}

	public void setCondicionanteExpediente(CondicionanteExpediente condicionanteExpediente) {
		this.condicionanteExpediente = condicionanteExpediente;
	}

	public DDTipoGastoRepercutido getTipoGastoRepercutido() {
		return TipoGastoRepercutido;
	}

	public void setTipoGastoRepercutido(DDTipoGastoRepercutido tipoGastoRepercutido) {
		TipoGastoRepercutido = tipoGastoRepercutido;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Long getMeses() {
		return meses;
	}

	public void setMeses(Long meses) {
		this.meses = meses;
	}
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}
