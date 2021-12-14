package es.pfsgroup.plugin.rem.model;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "ACT_MAC_MAESTRO_ACTIVO", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoMaestroActivos implements Serializable, Auditable {

    @Id
    @Column(name = "MAC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoMaestroActivosGenerator")
    @SequenceGenerator(name = "ActivoMaestroActivosGenerator", sequenceName = "S_ACT_MAC_MAESTRO_ACTIVO")
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;

    @Column(name = "ACT_REO")
    private Boolean actReo;

    @Column(name = "MAC_FECHA_ACTUALIZACION")
    private Date fechaActualizacion;

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

    public Activo getActivo() {
        return activo;
    }

    public void setActivo(Activo activo) {
        this.activo = activo;
    }

    public Boolean getActReo() {
        return actReo;
    }

    public void setActReo(Boolean actReo) {
        this.actReo = actReo;
    }

    public Date getFechaActualizacion() {
        return fechaActualizacion;
    }

    public void setFechaActualizacion(Date fechaActualizacion) {
        this.fechaActualizacion = fechaActualizacion;
    }

    public Long getVersion() {
        return version;
    }

    public void setVersion(Long version) {
        this.version = version;
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
