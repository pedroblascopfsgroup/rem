package es.capgemini.pfs.favoritos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase que representa la entidad historico accesos.
 */

@Entity
@Table(name = "HAC_HISTORICO_ACCESOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Favoritos implements Serializable, Auditable {

    private static final long serialVersionUID = -1353637087467504894L;

    @Id
    @Column(name = "HAC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "FavoritosGenerator")
    @SequenceGenerator(name = "FavoritosGenerator", sequenceName = "S_HAC_HISTORICO_ACCESOS")
    private Long id;

    @OneToOne(targetEntity = DDTipoEntidad.class)
    @JoinColumn(name = "DD_EIN_ID")
    private DDTipoEntidad entidadInformacion;

    @ManyToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "EXP_ID")
    private Expediente expediente;

    @ManyToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "PER_ID")
    private Persona persona;

    @ManyToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "PRC_ID")
    private Procedimiento procedimiento;

    @ManyToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "ASU_ID")
    private Asunto asunto;

    @ManyToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "USU_ID")
    private Usuario usuario;

    @ManyToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "CNT_ID")
    private Contrato contrato;

    @Column(name = "HAC_ORDEN")
    private Integer orden;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * devuelve el id de la entidad.
     * @return id
     */
    public Long getEntidadId() {
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(entidadInformacion.getCodigo())) {
            return this.getAsunto().getId();
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(entidadInformacion.getCodigo())) {
            return this.getExpediente().getId();
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(entidadInformacion.getCodigo())) {
            return this.getPersona().getId();
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(entidadInformacion.getCodigo())) {
            return this.getProcedimiento().getId();
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(entidadInformacion.getCodigo())) {
            return this.getContrato().getId();
        } else {
            return null;
        }
    }

    /**
     * retorna el nombre de favoritos.
     * @return nombre
     */
    public String getNombre() {
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(entidadInformacion.getCodigo())) {
            return this.getAsunto().getNombre();
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(entidadInformacion.getCodigo())) {
            return this.getExpediente().getDescripcionExpediente();
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(entidadInformacion.getCodigo())) {
            return this.getPersona().getApellidoNombre();
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(entidadInformacion.getCodigo())) {
            return this.getProcedimiento().getNombreProcedimiento();
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(entidadInformacion.getCodigo())) {
            return this.getContrato().getDescripcion();
        } else {
            return null;
        }
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
     * @return the entidadInformacion
     */
    public DDTipoEntidad getEntidadInformacion() {
        return entidadInformacion;
    }

    /**
     * @param entidadInformacion the entidadInformacion to set
     */
    public void setEntidadInformacion(DDTipoEntidad entidadInformacion) {
        this.entidadInformacion = entidadInformacion;
    }

    /**
     * @return the expediente
     */
    public Expediente getExpediente() {
        return expediente;
    }

    /**
     * @param expediente the expediente to set
     */
    public void setExpediente(Expediente expediente) {
        this.expediente = expediente;
    }

    /**
     * @return the persona
     */
    public Persona getPersona() {
        return persona;
    }

    /**
     * @param persona the persona to set
     */
    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    /**
     * @return the asunto
     */
    public Asunto getAsunto() {
        return asunto;
    }

    /**
     * @param asunto the asunto to set
     */
    public void setAsunto(Asunto asunto) {
        this.asunto = asunto;
    }

    /**
     * @return the orden
     */
    public Integer getOrden() {
        return orden;
    }

    /**
     * @param orden the orden to set
     */
    public void setOrden(Integer orden) {
        this.orden = orden;
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
     * @return the usuario
     */
    public Usuario getUsuario() {
        return usuario;
    }

    /**
     * @param usuario the usuario to set
     */
    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    /**
     * @return the procedimiento
     */
    public Procedimiento getProcedimiento() {
        return procedimiento;
    }

    /**
     * @param procedimiento the procedimiento to set
     */
    public void setProcedimiento(Procedimiento procedimiento) {
        this.procedimiento = procedimiento;
    }

    /**
     * @return the contrato
     */
    public Contrato getContrato() {
        return contrato;
    }

    /**
     * @param contrato the contrato to set
     */
    public void setContrato(Contrato contrato) {
        this.contrato = contrato;
    }

}
