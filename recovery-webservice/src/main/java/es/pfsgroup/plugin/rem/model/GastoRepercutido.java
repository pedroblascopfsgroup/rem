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
@Table(name = "GAR_GASTOS_REPERCUTIDOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class GastoRepercutido implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "GAR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoRepercutidoGenerator")
    @SequenceGenerator(name = "GastoRepercutidoGenerator", sequenceName = "S_GAR_GASTOS_REPERCUTIDOS")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COE_ID")
    private CondicionanteExpediente condicionanteExpediente;
		
    @Column(name = "GAR_GASTOS_COMUNIDAD_REP_ARRENDATARIO")
    private Boolean gastosComunidadRepArrend;
    
    @Column(name = "GAR_IMP_GASTOS_COM_REP_ARRENDATARIO")
    private Double gastosImpComunidadRepArrend;
    
    @Column(name = "GAR_IBI_REP_ARRENDATARIO")
    private Boolean ibiRepArrend;
    
    @Column(name = "GAR_TASAS_REP_ARRENDATARIO")
    private Boolean tasasRepArrendatario;
    
	@Column(name = "GAR_TASAS_IMPUESTOS_REP_ARRENDATARIO")
	private Double tasasImpRepArrendatario;
	
	@Column(name = "GAR_SUM_PRIV_REP_ARRENDATARIO")
    private Boolean sumPrivativosRepArrend;
	
	@Column(name = "GAR_IMPORTE_SUM_PRIV_REP_ARRENDATARIO")
    private Double precioAlquilerNegociable;
	
	@Column(name = "GAR_SUM_COMUNITARIOS_REP_ARRENDATARIO")
    private Boolean sumComunitariosRepArrend;
	
	@Column(name = "GAR_IMP_SUM_COMUNITARIOS_REP_ARRENDATARIO")
    private Double sumImpuestosComunitariosRepArrend;
	
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

	public Boolean getGastosComunidadRepArrend() {
		return gastosComunidadRepArrend;
	}

	public void setGastosComunidadRepArrend(Boolean gastosComunidadRepArrend) {
		this.gastosComunidadRepArrend = gastosComunidadRepArrend;
	}

	public Double getGastosImpComunidadRepArrend() {
		return gastosImpComunidadRepArrend;
	}

	public void setGastosImpComunidadRepArrend(Double gastosImpComunidadRepArrend) {
		this.gastosImpComunidadRepArrend = gastosImpComunidadRepArrend;
	}

	public Boolean getIbiRepArrend() {
		return ibiRepArrend;
	}

	public void setIbiRepArrend(Boolean ibiRepArrend) {
		this.ibiRepArrend = ibiRepArrend;
	}

	public Boolean getTasasRepArrendatario() {
		return tasasRepArrendatario;
	}

	public void setTasasRepArrendatario(Boolean tasasRepArrendatario) {
		this.tasasRepArrendatario = tasasRepArrendatario;
	}

	public Double getTasasImpRepArrendatario() {
		return tasasImpRepArrendatario;
	}

	public void setTasasImpRepArrendatario(Double tasasImpRepArrendatario) {
		this.tasasImpRepArrendatario = tasasImpRepArrendatario;
	}

	public Boolean getSumPrivativosRepArrend() {
		return sumPrivativosRepArrend;
	}

	public void setSumPrivativosRepArrend(Boolean sumPrivativosRepArrend) {
		this.sumPrivativosRepArrend = sumPrivativosRepArrend;
	}

	public Double getPrecioAlquilerNegociable() {
		return precioAlquilerNegociable;
	}

	public void setPrecioAlquilerNegociable(Double precioAlquilerNegociable) {
		this.precioAlquilerNegociable = precioAlquilerNegociable;
	}

	public Boolean getSumComunitariosRepArrend() {
		return sumComunitariosRepArrend;
	}

	public void setSumComunitariosRepArrend(Boolean sumComunitariosRepArrend) {
		this.sumComunitariosRepArrend = sumComunitariosRepArrend;
	}

	public Double getSumImpuestosComunitariosRepArrend() {
		return sumImpuestosComunitariosRepArrend;
	}

	public void setSumImpuestosComunitariosRepArrend(Double sumImpuestosComunitariosRepArrend) {
		this.sumImpuestosComunitariosRepArrend = sumImpuestosComunitariosRepArrend;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}
