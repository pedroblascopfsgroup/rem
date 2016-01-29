package es.pfsgroup.plugin.recovery.itinerarios.reglasVigenciaPolitica.dao.model;


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
import es.capgemini.pfs.itinerario.model.Estado;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoReglaVigenciaPolitica.model.ITIDDTipoReglaVigenciaPolitica;

/**
 * Las reglas de vigencia de los estados.
 *
 * @author pjimenez
 */
@Entity
@Table(name = "RVP_REGLAS_VIGENCIA_POLITICA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ITIReglasVigenciaPolitica implements Serializable, Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "RVP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ReglasVigenciaPolitica")
    @SequenceGenerator(name = "ReglasVigenciaPolitica", sequenceName = "S_RVP_REGLAS_VIGENCIA_POLITICA")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "DD_TRV_ID")
    private ITIDDTipoReglaVigenciaPolitica tipoReglaVigenciaPolitica;

    @ManyToOne
    @JoinColumn(name = "EST_ID")
    private Estado estadoItinerario;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * Retorna el atributo auditoria.
     * @return auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * Setea el atributo auditoria.
     * @param auditoria Auditoria
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * Retorna el atributo version.
     * @return version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * Setea el atributo version.
     * @param version Integer
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @param estadoItinerario the estadoItinerario to set
     */
    public void setEstadoItinerario(Estado estadoItinerario) {
        this.estadoItinerario = estadoItinerario;
    }

    /**
     * @return the estadoItinerario
     */
    public Estado getEstadoItinerario() {
        return estadoItinerario;
    }

    /**
     * @param tipoReglaVigenciaPolitica the tipoReglaVigenciaPolitica to set
     */
    public void setTipoReglaVigenciaPolitica(ITIDDTipoReglaVigenciaPolitica tipoReglaVigenciaPolitica) {
        this.tipoReglaVigenciaPolitica = tipoReglaVigenciaPolitica;
    }

    /**
     * @return the tipoReglaVigenciaPolitica
     */
    public ITIDDTipoReglaVigenciaPolitica getTipoReglaVigenciaPolitica() {
        return tipoReglaVigenciaPolitica;
    }
}
