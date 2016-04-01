package es.capgemini.pfs.expediente.model;

import java.io.Serializable;
import java.util.ArrayList;
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

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;

/**
 * Clase que representa a la entidad contratos expediente.
 */
@Entity
@Table(name = "CEX_CONTRATOS_EXPEDIENTE", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ExpedienteContrato implements Serializable, Auditable {

    private static final long serialVersionUID = -6561585840637893800L;

    @Id
    @Column(name = "CEX_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ExpedienteContratoGenerator")
    @SequenceGenerator(name = "ExpedienteContratoGenerator", sequenceName = "S_CEX_CONTRATOS_EXPEDIENTE")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "CNT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Contrato contrato;

    @ManyToOne
    @JoinColumn(name = "EXP_ID")
    private Expediente expediente;

    @Column(name = "CEX_PASE")
    private Integer pase;

    @ManyToOne
    @JoinColumn(name = "DD_AEX_ID")
    private DDAmbitoExpediente ambitoExpediente;

    @Column(name = "CEX_SIN_ACTUACION")
    private Boolean sinActuacion;

    //@OneToMany
    //@JoinColumn(name = "CEX_ID")
    //@Where(clause = Auditoria.UNDELETED_RESTICTION)
    //private List<Procedimiento> procedimientos;
    //@ManyToMany(mappedBy = "expedienteContratos")
    //@Where(clause = Auditoria.UNDELETED_RESTICTION)
    //private List<Procedimiento> procedimientos;

    @OneToMany(mappedBy = "expedienteContrato")
    private List<ProcedimientoContratoExpediente> procedimientosContratosExpedientes;

    @Column(name = "SYS_GUID")
    private String guid;
    
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}

    /**
     * Se sobreescribe este método para que se puedan comparar
     * listas de estos objetos.
     * @param o Object
     * @return boolean
     */
    @Override
    public boolean equals(Object o) {
    	if(o == null){
    		return false;
    	}
    	
    	if(this.getClass() != o.getClass()){
    		return false;
    	}
    	
        return equals((ExpedienteContrato) o);
    }

    /**
     * Se sobreescribe este método para que se puedan comparar
     * listas de estos objetos.
     * @param expedienteContrato ExpedienteContrato
     * @return boolean
     */
    public boolean equals(ExpedienteContrato expedienteContrato) {
        if (id.longValue() == expedienteContrato.getId().longValue()) {
            return true;
        }
        return false;
    }

    /**
     * Retorna el atributo auditoria.
     *
     * @return auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * Setea el atributo auditoria.
     *
     * @param auditoria
     *            Auditoria
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * Retorna el atributo version.
     *
     * @return version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * Setea el atributo version.
     *
     * @param version
     *            Integer
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * Retorna el atributo id.
     *
     * @return id
     */
    public Long getId() {
        return id;
    }

    /**
     * Setea el atributo id.
     *
     * @param id
     *            Long
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * Retorna el atributo contrato.
     *
     * @return contrato
     */
    public Contrato getContrato() {
        return contrato;
    }

    /**
     * Setea el atributo contrato.
     *
     * @param contrato
     *            Contrato
     */
    public void setContrato(Contrato contrato) {
        this.contrato = contrato;
    }

    /**
     * Retorna el atributo expediente.
     *
     * @return expediente
     */
    public Expediente getExpediente() {
        return expediente;
    }

    /**
     * Setea el atributo expediente.
     *
     * @param expediente
     *            Expediente
     */
    public void setExpediente(Expediente expediente) {
        this.expediente = expediente;
    }

    /**
     * Retorna el atributo pase.
     *
     * @return pase
     */
    public Integer getCexPase() {
        return pase;
    }

    /**
     * Setea el atributo pase.
     *
     * @param pase
     *            Integer
     */
    public void setCexPase(Integer pase) {
        this.pase = pase;
    }

    /**
     * @return the pase
     */
    public Integer getPase() {
        return pase;
    }

    /**
     * @param pase
     *            the pase to set
     */
    public void setPase(Integer pase) {
        this.pase = pase;
    }

    /**
     * @return the procedimientos
     */
    public List<Procedimiento> getProcedimientosActivos() {

        List<Procedimiento> prc = new ArrayList<Procedimiento>();
        for (ProcedimientoContratoExpediente pce : procedimientosContratosExpedientes) {
            if (!pce.getProcedimiento().getAuditoria().isBorrado()) {
                prc.add(pce.getProcedimiento());
            }
        }

        return prc;
    }

    /**
     * @return the procedimientos
     */
    public List<Procedimiento> getProcedimientos() {

        List<Procedimiento> prc = new ArrayList<Procedimiento>();
        for (ProcedimientoContratoExpediente pce : procedimientosContratosExpedientes) {
            prc.add(pce.getProcedimiento());
        }

        return prc;
    }

    /**
     * @param procedimientos
     *            the procedimientos to set
     */
    public void setProcedimientos(List<Procedimiento> procedimientos) {
        if (procedimientos == null) {
            procedimientosContratosExpedientes = new ArrayList<ProcedimientoContratoExpediente>();
        } else {

            List<ProcedimientoContratoExpediente> list = new ArrayList<ProcedimientoContratoExpediente>();
            for (Procedimiento prc : procedimientos) {
                ProcedimientoContratoExpediente pce = new ProcedimientoContratoExpediente();
                pce.setExpedienteContrato(this);
                pce.setProcedimiento(prc);
                list.add(pce);
            }

            procedimientosContratosExpedientes = list;
        }
    }

    /**
     * @return the sinActuacion
     */
    public Boolean getSinActuacion() {
        return sinActuacion;
    }

    /**
     * @param sinActuacion
     *            the sinActuacion to set
     */
    public void setSinActuacion(Boolean sinActuacion) {
        this.sinActuacion = sinActuacion;
    }

    /**
     * Devuelve la cantidad de procedimientos asociados.
     *
     * @return la cant de procedimientos.
     */
    public Integer getCantidadProcedimientos() {
        if (getProcedimientosActivos() == null) {
            return 0;
        }
        return getProcedimientosActivos().size();
    }

    /**
     * Devuelve la cantidad de procedimientos.
     * @return la cantidad de procedimientos
     */
    public String getCantProcedimientos() {
        if (contrato.getProcedimientos() != null) {
            return "" + contrato.getProcedimientos().size();
        }
        return "NULL";
    }

    /**
     * @param ambitoExpediente the ambitoExpediente to set
     */
    public void setAmbitoExpediente(DDAmbitoExpediente ambitoExpediente) {
        this.ambitoExpediente = ambitoExpediente;
    }

    /**
     * @return the ambitoExpediente
     */
    public DDAmbitoExpediente getAmbitoExpediente() {
        return ambitoExpediente;
    }

}
