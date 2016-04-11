package es.capgemini.pfs.politica.model;


import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;

/**
 * Diccionario de datos de los estados que puede tener una política.
 * @author Andrés Esteban
 */
@Entity
@Table(name = "DD_EPI_EST_POL_ITINERARIO", schema = "${master.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDEstadoItinerarioPolitica implements Auditable, Dictionary {

    private static final long serialVersionUID = 5029026178969906212L;

    public static final String ESTADO_PREPOLITICA = "PRE";
    public static final String ESTADO_COMPLETAR_EXPEDIENTE = "CE";
    public static final String ESTADO_REVISAR_EXPEDIENTE = "RE";
    public static final String ESTADO_DECISION_COMITE = "DC";
    public static final String ESTADO_VIGENTE = "VIG";
    public static final String ESTADO_PERIODO_CARENCIA = "CAR";
    public static final String ESTADO_GESTION_VENCIDOS = "GV";
    public static final String ESTADO_EN_SANCION = "ENSAN";
    public static final String ESTADO_SANCIONADO = "SANC";

    @Id
    @Column(name = "DD_EPI_ID")
    private Long id;

    @OneToOne
    @JoinColumn(name = "DD_EST_ID")
    private DDEstadoItinerario estadoItinerario;

    @Column(name = "DD_EPI_CODIGO")
    private String codigo;

    @Column(name = "DD_EPI_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_EPI_DESCRIPCION_LARGA")
    private String descripcionLarga;

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
     * Es nulo para los casos en que el estado es Prepolitica y Superusuario.
     * @return the estadoItinerario
     */
    public DDEstadoItinerario getEstadoItinerario() {
        return estadoItinerario;
    }

    /**
     * @param estadoItinerario the estadoItinerario to set
     */
    public void setEstadoItinerario(DDEstadoItinerario estadoItinerario) {
        this.estadoItinerario = estadoItinerario;
    }

    /**
     * @return the codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the descripcionLarga
     */
    public String getDescripcionLarga() {
        return descripcionLarga;
    }

    /**
     * @param descripcionLarga the descripcionLarga to set
     */
    public void setDescripcionLarga(String descripcionLarga) {
        this.descripcionLarga = descripcionLarga;
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

}
