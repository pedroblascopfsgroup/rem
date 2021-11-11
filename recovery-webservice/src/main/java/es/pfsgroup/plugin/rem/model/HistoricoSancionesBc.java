package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.CascadeType;
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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDComiteBc;



/**
 * Modelo que gestiona la informacion del Historico de sanciones de BC
 *
 * @author Jesus Jativa
 *
 */
@Entity
@Table(name = "HSB_HISTORICO_SANCIONES_BC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class HistoricoSancionesBc implements Serializable, Auditable {

    /**
     *
     */
    private static final long serialVersionUID = -7785802535778510517L;

    @Id
    @Column(name = "HSB_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoSancionesBcGenerator")
    @SequenceGenerator(name = "HistoricoSancionesBcGenerator", sequenceName = "S_HSB_HISTORICO_SANCIONES_BC")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expedienteComercial;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "DD_CBC_ID")
    private DDComiteBc comiteBc;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "DD_APD_ID")
    private DDApruebaDeniega resultado;

    @Column(name = "HSB_OBSERVACIONES_BC")
    private String obserbacionesBc;

    @Version
    private Long version;

    @Embedded
    private Auditoria auditoria;

    @Override
    public Auditoria getAuditoria() {
        return auditoria;
    }

    @Override
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public ExpedienteComercial getExpedienteComercial() {
        return expedienteComercial;
    }

    public void setExpedienteComercial(ExpedienteComercial expedienteComercial) {
        this.expedienteComercial = expedienteComercial;
    }

    public String getObserbacionesBc() {
        return obserbacionesBc;
    }

    public void setObserbacionesBc(String obserbacionesBc) {
        this.obserbacionesBc = obserbacionesBc;
    }

    public Long getVersion() {
        return version;
    }

    public void setVersion(Long version) {
        this.version = version;
    }

	public DDApruebaDeniega getResultado() {
		return resultado;
	}

	public void setResultado(DDApruebaDeniega resultado) {
		this.resultado = resultado;
	}

	public DDComiteBc getComiteBc() {
		return comiteBc;
	}

	public void setComiteBc(DDComiteBc comiteBc) {
		this.comiteBc = comiteBc;
	}
    
}