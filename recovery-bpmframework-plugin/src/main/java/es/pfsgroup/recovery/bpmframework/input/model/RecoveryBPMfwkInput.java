package es.pfsgroup.recovery.bpmframework.input.model;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputInfo;

/**
 * Entidad persitible INPUT
 * @author bruno
 *
 */
@Entity
@Table(name = "BPM_IPT_INPUT", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class RecoveryBPMfwkInput implements RecoveryBPMfwkInputInfo, Auditable, Serializable{
    
    private static final long serialVersionUID = -2704253470986658233L;
    
    @Id
    @Column(name = "BPM_IPT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RecoveryBPMfwkInputGenerator")
    @SequenceGenerator(name = "RecoveryBPMfwkInputGenerator", sequenceName = "S_BPM_IPT_INPUT")
    private Long id;
    
    @Column(name = "PRC_ID", nullable = false)
    private Long idProcedimiento;
    
    @ManyToOne
    @JoinColumn(name = "BPM_DD_TIN_ID", nullable = false)
    private RecoveryBPMfwkDDTipoInput tipo;
    
    @Column(name = "BPM_IPT_ADJUNTO", nullable = true)
    private FileItem adjunto;
    
    //@OneToMany(mappedBy = "input", fetch = FetchType.LAZY)
    @OneToMany(mappedBy = "input", fetch = FetchType.EAGER)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "BPM_IPT_ID")
    private Set<RecoveryBPMfwkDatoInput> datosPersistidos;
    
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    public Long getIdProcedimiento() {
        return idProcedimiento;
    }

    public RecoveryBPMfwkDDTipoInput getTipo() {
        return tipo;
    }

    public FileItem getAdjunto() {
        return adjunto;
    }

    public Set<RecoveryBPMfwkDatoInput> getDatosPersistidos() {
        return datosPersistidos;
    }

    public Long getId() {
        return id;
    }

    public void setId(final Long id) {
        this.id = id;
    }

    public void setIdProcedimiento(final Long idProcedimiento) {
        this.idProcedimiento = idProcedimiento;
    }

    public void setTipo(final RecoveryBPMfwkDDTipoInput tipo) {
        this.tipo = tipo;
    }

    public void setAdjunto(final FileItem adjunto) {
        this.adjunto = adjunto;
    }

    public void setDatosPersistidos(final Set<RecoveryBPMfwkDatoInput> datos) {
        this.datosPersistidos = datos;
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

    @Override
    public String getCodigoTipoInput() {
        String codigo = null;
        if (! Checks.esNulo(this.getTipo())){
            codigo = this.getTipo().getCodigo();
        }
        return codigo;
    }

    @Override
    public Map<String, Object> getDatos() {
        HashMap<String, Object> mapa = new  HashMap<String, Object>();
        if (!Checks.estaVacio(this.getDatosPersistidos())){
            for (RecoveryBPMfwkDatoInput dato : this.getDatosPersistidos()){
                mapa.put(dato.getNombre(), Checks.esNulo(dato.getValor())?dato.getValorLargo():dato.getValor());
            }
        }
        return mapa;
    }

}
