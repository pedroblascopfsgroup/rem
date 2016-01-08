package es.pfsgroup.plugin.recovery.itinerarios.ddTipoReglaVigenciaPolitica.model;

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
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;

@Entity
@Table(name = "DD_TRV_TIPO_REGLAS_VIGENCIA", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class ITIDDTipoReglaVigenciaPolitica implements Dictionary, Auditable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -2143854503493875345L;

	public static final String INCLUSION_CONSENSO_CE_RE = "CONS_CE_RE";
    public static final String INCLUSION_CONSENSO_PRE_CE = "CONS_PRE_CE";
    public static final String INCLUSION_CONSENSO_PRE_CE_RE = "CONS_PRE_CE_RE";

    public static final String EXCLUSION_CE_MAYOR_PRE = "EXC_CE_MAYOR_PRE";
    public static final String EXCLUSION_CE_MENOR_PRE = "EXC_CE_MENOR_PRE";

    public static final String EXCLUSION_RE_MAYOR_PRE = "EXC_RE_MAYOR_PRE";
    public static final String EXCLUSION_RE_MENOR_PRE = "EXC_RE_MENOR_PRE";

    public static final String EXCLUSION_RE_MAYOR_CE = "EXC_RE_MAYOR_CE";
    public static final String EXCLUSION_RE_MENOR_CE = "EXC_RE_MENOR_CE";

    @Id
    @Column(name = "DD_TRV_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoReglaVigenciaPolitica")
    @SequenceGenerator(name = "DDTipoReglaVigenciaPolitica", sequenceName = "${master.schema}.S_DD_TRV_TIPO_REGLAS_VIGENCIA")
    private Long id;

    @Column(name = "DD_TRV_CODIGO")
    private String codigo;

    @Column(name = "DD_TRV_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TRV_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Column(name = "DD_TRV_RE")
    private Boolean categoriaRevExp;
    
    @Column(name = "DD_TRV_CONSEX")
    private Boolean categoriaConsenso;

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
     * Comprueba si es una regla de inclusión o no
     * @return
     */
    public Boolean isReglaInclusion() {
        if (INCLUSION_CONSENSO_CE_RE.equals(codigo) || INCLUSION_CONSENSO_PRE_CE.equals(codigo) || INCLUSION_CONSENSO_PRE_CE_RE.equals(codigo))
            return true;
        else
            return false;
    }

    /**
     * Comprueba que es una regla del estado itinerario que corresponde como parametro de entrada
     * @param estadoItinerario
     * @return
     */
    public boolean isEstadoItinerario(String estadoItinerario) {
        if (DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE.equals(estadoItinerario)) {
            if (INCLUSION_CONSENSO_PRE_CE.equals(codigo) || EXCLUSION_CE_MAYOR_PRE.equals(codigo) || EXCLUSION_CE_MENOR_PRE.equals(codigo))
                return true;
        } else if (DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE.equals(estadoItinerario)) {
            if (INCLUSION_CONSENSO_CE_RE.equals(codigo) || INCLUSION_CONSENSO_PRE_CE_RE.equals(codigo) || EXCLUSION_RE_MAYOR_PRE.equals(codigo)
                    || EXCLUSION_RE_MENOR_PRE.equals(codigo) || EXCLUSION_RE_MAYOR_CE.equals(codigo) || EXCLUSION_RE_MENOR_CE.equals(codigo))
                return true;
        }

        return false;
    }

	public void setCategoriaRevExp(Boolean categoriaRevExp) {
		this.categoriaRevExp = categoriaRevExp;
	}

	public Boolean getCategoriaRevExp() {
		return categoriaRevExp;
	}

	public void setCategoriaConsenso(Boolean categoriaConsenso) {
		this.categoriaConsenso = categoriaConsenso;
	}

	public Boolean getCategoriaConsenso() {
		return categoriaConsenso;
	}

}
