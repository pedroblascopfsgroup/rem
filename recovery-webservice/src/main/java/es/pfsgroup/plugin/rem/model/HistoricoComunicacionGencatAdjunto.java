package es.pfsgroup.plugin.rem.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo que gestiona la informacion de los adjuntos de las comunicaciones del histórico de GENCAT
 * 
 * @author Isidro Sotoca
 *
 */
@Entity
@Table(name = "HCG_ADH_ADJ_HIST_COM_GENCAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class HistoricoComunicacionGencatAdjunto implements Serializable, Auditable {

	private static final long serialVersionUID = 8345403272020534666L;
	
	@Id
    @Column(name = "ADH_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoComunicacionGencatAdjuntoGenerator")
    @SequenceGenerator(name = "HistoricoComunicacionGencatAdjuntoGenerator", sequenceName = "S_HCG_ADH_ADJ_HIST_COM_GENCAT")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "HCG_ID")
	private HistoricoComunicacionGencat historicoComunicacionGencat;
	
	@ManyToOne
    @JoinColumn(name = "ADC_ID")
	private AdjuntoComunicacion adjuntoComunicacion;
	
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

	public HistoricoComunicacionGencat getHistoricoComunicacionGencat() {
		return historicoComunicacionGencat;
	}

	public void setHistoricoComunicacionGencat(HistoricoComunicacionGencat historicoComunicacionGencat) {
		this.historicoComunicacionGencat = historicoComunicacionGencat;
	}

	public AdjuntoComunicacion getAdjuntoComunicacion() {
		return adjuntoComunicacion;
	}

	public void setAdjuntoComunicacion(AdjuntoComunicacion adjuntoComunicacion) {
		this.adjuntoComunicacion = adjuntoComunicacion;
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
