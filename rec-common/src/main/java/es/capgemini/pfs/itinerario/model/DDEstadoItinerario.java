package es.capgemini.pfs.itinerario.model;

import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

/**
 *    DD_EST_ID            BIGINT NOT NULL AUTO_INCREMENT,
 *    DD_EST_CODIGO        VARCHAR(20) NOT NULL,
 *    DD_EST_DESCRIPCION   VARCHAR(50),
 *    DD_EST_DESCRIPCION_LARGA VARCHAR(250).
 *
 * @author Nicolás Cornaglia
 */
@Entity
@Table(name = "DD_EST_ESTADOS_ITINERARIOS", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDEstadoItinerario implements Dictionary, Auditable {

    private static final long serialVersionUID = 1L;

    public static final String ESTADO_GESTION_VENCIDOS_CARENCIA = "CAR";
    public static final String ESTADO_GESTION_VENCIDOS = "GV";
    public static final String ESTADO_COMPLETAR_EXPEDIENTE = "CE";
    public static final String ESTADO_REVISAR_EXPEDIENTE = "RE";
    public static final String ESTADO_DECISION_COMIT = "DC";
    public static final String ESTADO_FORMALIZAR_PROPUESTA = "FP";
    public static final String ESTADO_ASUNTO = "AS";
    public static final String ESTADO_VIGILANCIA_METAS_VOLANTES = "VMV";
    public static final String ESTADO_CREACION_MANUAL_EXPEDIENTE_RECOBRO = "CMER";
    public static final String ESTADO_PERSONA_ASUNTO = "ASUNTO";
    public static final String ESTADO_PERSONA_EXPEDIENTE = "EXPEDIMENTADO";
    public static final String ESTADO_PERSONA_REGULAR = "REGULAR";
    public static final String ESTADO_ITINERARIO_EN_SANCION = "ENSAN";

    private static final String[] ESTADOS_ORDENADOS = { ESTADO_GESTION_VENCIDOS_CARENCIA, ESTADO_GESTION_VENCIDOS, ESTADO_COMPLETAR_EXPEDIENTE,
            ESTADO_REVISAR_EXPEDIENTE, ESTADO_DECISION_COMIT, ESTADO_ASUNTO };

    @Id
    @Column(name = "DD_EST_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoItinerarioGenerator")
    @SequenceGenerator(name = "DDEstadoItinerarioGenerator", sequenceName = "${master.schema}.S_DD_EST_EST_ITI")
    private Long id;

    @Column(name = "DD_EST_CODIGO")
    private String codigo;

    @Column(name = "DD_EST_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_EST_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Column(name = "DD_EST_ORDEN")
    private String orden;

	@ManyToOne
    @JoinColumn(name = "DD_EIN_ID")
    private DDTipoEntidad tipoEntidad;

    @OneToMany
    @JoinColumn(name = "DD_EST_ID")
    private Set<Estado> estados;

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

    /** Este getter de la constante es necesario para poder acceder mediante EL en los flows o JSP.
     * @return la constante ESTADO_GESTION_VENCIDOS
     */
    public String getESTADO_GESTION_VENCIDOS() {
        return ESTADO_GESTION_VENCIDOS;
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
     * @return the tipoEntidad
     */
    public DDTipoEntidad getTipoEntidad() {
        return tipoEntidad;
    }

    /**
     * @param tipoEntidad the tipoEntidad to set
     */
    public void setTipoEntidad(DDTipoEntidad tipoEntidad) {
        this.tipoEntidad = tipoEntidad;
    }

    /**
     * getEstados.
     * @return estados
     */
    public Set<Estado> getEstados() {
        return estados;
    }

    /**
     * set estados.
     * @param estados estados
     */
    public void setEstados(Set<Estado> estados) {
        this.estados = estados;
    }
    
    public String getOrden() {
		return orden;
	}

	public void setOrden(String orden) {
		this.orden = orden;
	}

    /**
     * Retorna el código de estado siguiente al actual, "---" si es el �ltimo.
     * @return String
     */
    public String getSiguienteEstado() {
        int i = 0;
        while (i < ESTADOS_ORDENADOS.length - 1) {
            if (codigo.equals(ESTADOS_ORDENADOS[i])) { return ESTADOS_ORDENADOS[i + 1]; }
            i++;
        }
        if (codigo.equals(ESTADO_ASUNTO)) { return "---"; }
        return "";
    }
}
