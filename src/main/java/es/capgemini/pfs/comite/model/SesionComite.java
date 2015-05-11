package es.capgemini.pfs.comite.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase que representa una sesión del comité.
 * @author pamuller
 *
 */
@Entity
@Table(name = "SES_SESIONES_COMITE", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class SesionComite implements Serializable,Auditable {

    private static final long serialVersionUID = -627918339058111023L;

    @Id
    @Column(name = "SES_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "SesionComiteGenerator")
    @SequenceGenerator(name = "SesionComiteGenerator", sequenceName = "S_SES_SESIONES_COMITE")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "COM_ID")
    private Comite comite;

    @Column(name = "SES_FECHA_INI")
    private Date fechaInicio;

    @Column(name = "SES_FECHA_FIN")
    private Date fechaFin;

    @OneToMany(mappedBy = "sesion")
    private List<DecisionComite> decisiones;

    @OneToMany
    @JoinColumn(name = "SES_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Asistente> asistentes;

    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

    /**
     * retorna la cantidad de expedientes y asuntos decididos.
     * @return cantidad de expedientes decididos
     */
    public int getCantidadPuntosDecididos() {
        int count = 0;
        for (DecisionComite decision : getDecisiones()) {
            count+= decision.getCantidadPuntosTratados();
        }
        return count;
    }

    /**
     * obtiene el supervisor de la sesion actual.
     * @return usuario supervisor
     */
    public Usuario getSupervisorSesionComite(){
    	for (Asistente asistente : asistentes){
    		if (asistente.isSupervisor()){
    			return asistente.getUsuario();
    		}
    	}
    	return null;
    }

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
     * @return the comite
     */
    public Comite getComite() {
        return comite;
    }

    /**
     * @param comite the comite to set
     */
    public void setComite(Comite comite) {
        this.comite = comite;
    }

    /**
     * @return the fechaInicio
     */
    public Date getFechaInicio() {
        return fechaInicio;
    }

    /**
     * @param fechaInicio the fechaInicio to set
     */
    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the fechaFin
     */
    public Date getFechaFin() {
        return fechaFin;
    }

    /**
     * @param fechaFin the fechaFin to set
     */
    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    /**
     * @return the asistentes
     */
    public List<Asistente> getAsistentes() {
        return asistentes;
    }

    /**
     * @param asistentes the asistentes to set
     */
    public void setAsistentes(List<Asistente> asistentes) {
        this.asistentes = asistentes;
    }

    /**
     * @return the decisiones
     */
    public List<DecisionComite> getDecisiones() {
        return decisiones;
    }

    /**
     * @param decisiones the decisiones to set
     */
    public void setDecisiones(List<DecisionComite> decisiones) {
        this.decisiones = decisiones;
    }
}
