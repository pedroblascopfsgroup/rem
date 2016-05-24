package es.pfsgroup.plugin.recovery.coreextension.subasta.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Resultado comite subasta
 * @author asoler
 *
 */
@Entity
@Table(name = "DD_RCS_RESULTADO_COMITE_SUB", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDResultadoComiteSubasta implements Dictionary, Auditable {

	private static final long serialVersionUID = 1705039707091961077L;
	
	public static final String RECHAZAR = "REC";
    public static final String CONTINUAR_SUBASTA = "CSU";
    public static final String NO_PAGAR_TASA = "NPT";


	@Id
    @Column(name = "DD_RCS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDResultadoComiteSubastaGenerator")
	@SequenceGenerator(name = "DDResultadoComiteSubastaGenerator", sequenceName = "S_DD_RCS_RESULTADO_COMITE_SUB")
    private Long id;

    @Column(name = "DD_RCS_CODIGO")
    private String codigo;

    @Column(name = "DD_RCS_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_RCS_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Embedded
    private Auditoria auditoria;


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

}
