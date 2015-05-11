package es.capgemini.pfs.titulo.model;

import java.io.Serializable;

import javax.persistence.CascadeType;
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
import es.capgemini.pfs.contrato.model.Contrato;


/**
 * Clase que representa la entidad titulo.
 * @author mtorrado
 *
 */

@Entity
@Table(name="TIT_TITULO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Titulo implements Serializable,Auditable{

    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = -6176558369008955201L;

    public static final String CODIGO_SITUACION_TITULO_NINGUNO = "1";

    public static final String CODIGO_TIPO_TITULO_NINGUNO = "1";

    @Id
    @Column(name="TIT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TituloGenerator")
    @SequenceGenerator(name = "TituloGenerator", sequenceName = "S_TIT_TITULO")
    private Long id;

    @ManyToOne(cascade = CascadeType.REFRESH)
    @JoinColumn(name="CNT_ID")
    private Contrato contrato;

    @ManyToOne
    @JoinColumn(name="DD_STI_ID")
    private DDSituacion situacion;

    @ManyToOne
    @JoinColumn(name="DD_TTI_ID")
    private DDTipoTitulo tipoTitulo;

    @Column(name="TIT_INTERVENIDO")
    private boolean intervenido;

    @Column(name="TIT_FIRMA_OK")
    private Long firmaOk;

    @Column(name="TIT_COMENTARIO")
    private String comentario;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * Retorna el atributo id.
     * @return id
     */
    public Long getId() {
        return id;
    }

    /**
     * Setea el atributo id.
     * @param id Long
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * Retorna el atributo contrato.
     * @return contrato
     */
    public Contrato getContrato() {
        return contrato;
    }

    /**
     * Setea el atributo contrato.
     * @param contrato Contrato
     */
    public void setContrato(Contrato contrato) {
        this.contrato = contrato;
    }

    /**
     * Retorna el atributo situacion.
     * @return situacion
     */
    public DDSituacion getSituacion() {
        return situacion;
    }

    /**
     * Setea el atributo situacion.
     * @param situacion DDSituacion
     */
    public void setSituacion(DDSituacion situacion) {
        this.situacion = situacion;
    }

    /**
     * Retorna el atributo tipoTitulo.
     * @return tipoTitulo
     */
    public DDTipoTitulo getTipoTitulo() {
        return tipoTitulo;
    }

    /**
     * Setea el atributo tipoTitulo.
     * @param tipoTitulo DDTipoTitulo
     */
    public void setTipoTitulo(DDTipoTitulo tipoTitulo) {
        this.tipoTitulo = tipoTitulo;
    }

    /**
     * Retorna el atributo intervenido.
     * @return intervenido
     */
    public boolean getIntervenido() {
        return intervenido;
    }

    /**
     * Setea el atributo intervenido.
     * @param intervenido boolean
     */
    public void setIntervenido(boolean intervenido) {
        this.intervenido = intervenido;
    }

    /**
     * Retorna el atributo firmaOk.
     * @return firmaOk Long
     */
    public Long getFirmaOk() {
        return firmaOk;
    }

    /**
     * Setea el atributo firmaOk.
     * @param firmaOk Long
     */
    public void setFirmaOk(Long firmaOk) {
        this.firmaOk = firmaOk;
    }

    /**
     * Retorna el atributo comentario.
     * @return comentario
     */
    public String getComentario() {
        return comentario;
    }

    /**
     * Setea el atributo comentario.
     * @param comentario String
     */
    public void setComentario(String comentario) {
        this.comentario = comentario;
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
}
