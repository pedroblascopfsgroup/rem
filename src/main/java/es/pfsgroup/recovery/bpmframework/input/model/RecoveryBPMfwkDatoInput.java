package es.pfsgroup.recovery.bpmframework.input.model;

import java.io.Serializable;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;

/**
 * Datos que vienen con el input
 * @author bruno
 *
 */
@Entity
@Table(name = "BPM_DIP_DATOS_INPUT", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class RecoveryBPMfwkDatoInput implements Auditable, Serializable{
    
    private static final long serialVersionUID = -2435682434371343303L;

    private static final int MAX_SIZE_VALOR_CORTO = 1000;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RecoveryBPMfwkDatoInputGenerator")
    @SequenceGenerator(name = "RecoveryBPMfwkDatoInputGenerator", sequenceName = "S_BPM_DIP_DATOS_INPUT")
    @Column(name = "BPM_DIP_ID")
    private Long id;

    @Column(name = "BPM_DIP_NOMBRE")
    private String nombre;

    @ManyToOne
    @JoinColumn(name = "BPM_IPT_ID")
    private RecoveryBPMfwkInput input;

    @Column(name = "BPM_DIP_VALOR")
    private String valor;
    
    @Column(name = "BPM_DIP_VALOR_CLOB")
    private String valorLargo;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    public Long getId() {
        return id;
    }

    public void setId(final Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(final String nombre) {
        this.nombre = nombre;
    }

    public RecoveryBPMfwkInput getInput() {
        return input;
    }

    public void setInput(final RecoveryBPMfwkInput input) {
        this.input = input;
    }

    public String getValor() {
    	if (!Checks.esNulo(valorLargo)){
    		return valorLargo;
    	} else {
    		return valor;
    	}
    }

    public void setValor(final String valor) {
        if (Checks.esNulo(valor))
            return;
        
        if (MAX_SIZE_VALOR_CORTO < valor.length()){
            this.valorLargo = valor;
        }else{
            this.valor = valor;
        }
    }

    public String getValorLargo() {
        return valorLargo;
    }

    public void setValorLargo(final String valorLargo) {
        this.valorLargo = valorLargo;
    }

    public Auditoria getAuditoria() {
        return auditoria;
    }

    public void setAuditoria(final Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    public Integer getVersion() {
        return version;
    }

    public void setVersion(final Integer version) {
        this.version = version;
    }
    
}
