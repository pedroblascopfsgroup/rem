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
 * Motivo no pagar tasa
 * @author asoler
 *
 */
@Entity
@Table(name = "DD_MNP_MOTIVO_NO_PAGAR_TASA", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDMotivoNoPagarTasa implements Dictionary, Auditable {

	private static final long serialVersionUID = -2049648657529232264L;
	
	public static final String INSTRUCCIONES_ENTIDAD = "IEN";
    public static final String POSIBLE_ACUERDO_DEUDOR = "PAD";
    public static final String OTROS = "OTR";


	@Id
    @Column(name = "DD_MNP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivoNoPagarTasaGenerator")
	@SequenceGenerator(name = "DDMotivoNoPagarTasaGenerator", sequenceName = "S_DD_MNP_MOTIVO_NO_PAGAR_TASA")
    private Long id;

    @Column(name = "DD_MNP_CODIGO")
    private String codigo;

    @Column(name = "DD_MNP_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_MNP_DESCRIPCION_LARGA")
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
