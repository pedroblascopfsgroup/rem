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
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;

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

	@OneToMany(mappedBy= "esquemaPlazasTpo", fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@OrderBy("importeDesde")
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
	
	/**
	 * Comprueba si el par plaza-tpo ya dispone de un rango de importes que se solape con el dado y que no sean de la lista dada
	 * @param impMin  Importe desde de la regla
	 * @param impMax  Importe hasta de la regla
	 * @param listaRangos
	 * @return
	 */
	public boolean importesSolapados(Double impMin, Double impMax, List<TurnadoProcuradorConfig> listaRangos) {
		if (Checks.estaVacio(this.configuracion)) return false;
		for (TurnadoProcuradorConfig config : configuracion) {
			//Si se le pasa una lista de rangos a excluir en la comparacion
			if(!Checks.estaVacio(listaRangos)){
				boolean excluyente = false;
				for(TurnadoProcuradorConfig configExcluyente : listaRangos){
					if(config.getId().equals(configExcluyente.getId())){
						excluyente=true;
					}
				}
				if (!excluyente && impMin<=config.getImporteHasta() 
						 && impMax>=config.getImporteDesde()) {
						return true;
				}
			}
			//Si no hay 
			else {
				if (impMin<=config.getImporteHasta() 
					 && impMax>=config.getImporteDesde()) {
					return true;
				}
			}
		}
		return false;
	} 
		
}
