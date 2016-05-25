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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

@Entity
@Table(name = "TUP_EPT_ESQUEMA_PLAZAS_TPO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class EsquemaPlazasTpo implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "EPT_ID")
 	@GeneratedValue(strategy = GenerationType.AUTO, generator = "EsquemaPlazasTpoGenerator")
    @SequenceGenerator(name = "EsquemaPlazasTpoGenerator", sequenceName = "S_TUP_EPT_ESQUEMA_PLAZAS_TPO")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ETP_ID")
	private EsquemaTurnadoProcurador esquemaTurnadoProcurador;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_PLA_ID")
	private TipoPlaza tipoPlaza;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TPO_ID")
	private TipoProcedimiento tipoProcedimiento;	
	
	@Column(name = "EPT_GRUPO_ASIGNADO")
	private float grupoAsignado;

	@OneToMany(fetch = FetchType.LAZY)
	@JoinColumn(name = "EPT_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<TurnadoProcuradorConfig> configuracion;
	
//    @OneToMany(mappedBy = "esquema", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
//    @JoinColumn(name = "ETU_ID")
//    @OrderBy("codigo ASC")
//    @Where(clause = Auditoria.UNDELETED_RESTICTION)
//	private List<EsquemaTurnadoConfig> configuracion;
	
    @Embedded
    private Auditoria auditoria;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}	

	public EsquemaTurnadoProcurador getEsquemaTurnadoProcurador() {
		return esquemaTurnadoProcurador;
	}

	public void setEsquemaTurnadoProcurador(EsquemaTurnadoProcurador esquemaTurnadoProcurador) {
		this.esquemaTurnadoProcurador = esquemaTurnadoProcurador;
	}

	public TipoPlaza getTipoPlaza() {
		return tipoPlaza;
	}

	public void setTipoPlaza(TipoPlaza tipoPlaza) {
		this.tipoPlaza = tipoPlaza;
	}

	public TipoProcedimiento getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setTipoProcedimiento(TipoProcedimiento tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}

	public float getGrupoAsignado() {
		return grupoAsignado;
	}

	public void setGrupoAsignado(float grupoAsignado) {
		this.grupoAsignado = grupoAsignado;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
		
	}
	
	public List<TurnadoProcuradorConfig> getConfiguracion() {
		return configuracion;
	}

	public void setConfiguracion(List<TurnadoProcuradorConfig> configuracion) {
		this.configuracion = configuracion;
	}	
		
}
