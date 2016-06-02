package es.capgemini.pfs.itinerario.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Define un tipo de itinerario (seguimiento o recuperación).
 *
 * @author pjimenez
 */
@Entity
@Table(name = "DD_TIT_TIPO_ITINERARIOS", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoItinerario implements Dictionary, Auditable {

    private static final long serialVersionUID = 1L;

    public static final String ITINERARIO_RECUPERACION = "REC";
    public static final String ITINERARIO_SEGUIMIENTO_SISTEMATICO = "SIS";
    public static final String ITINERARIO_SEGUIMIENTO_SINTOMATICO = "SIN";
    public static final String ITINERARIO_GESTION_DEUDA = "DEU";

    public static final String ITINERARIO_ESPECIAL_SIN_GESTION = "000";

    @Id
    @Column(name = "DD_TIT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoItinerarioGenerator")
    @SequenceGenerator(name = "DDTipoItinerarioGenerator", sequenceName = "${master.schema}.S_DD_TIT_TIPO_ITINERARIOS")
    private Long id;

    @Column(name = "DD_TIT_CODIGO")
    private String codigo;

    @Column(name = "DD_TIT_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TIT_DESCRIPCION_LARGA")
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
     * Indica si el itinerario es o no de seguimiento
     * @return
     */
    public Boolean getItinerarioSeguimiento() {
    	return (ITINERARIO_SEGUIMIENTO_SINTOMATICO.equals(codigo) ||
    			ITINERARIO_SEGUIMIENTO_SISTEMATICO.equals(codigo));
    }

    /**
     * Indica si el itinerario es o no de recuperación
     * @return
     */
    public Boolean getItinerarioRecuperacion() {
        return ITINERARIO_RECUPERACION.equals(codigo);
    }
    
    /**
     * Indica si el itinerario es de Gestión de deuda
     */
    public Boolean getItinerarioGestionDeuda() {
    	return ITINERARIO_GESTION_DEUDA.equals(codigo);
    }

}
