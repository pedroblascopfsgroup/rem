package es.pfsgroup.recovery.bpmframework.config.model;

import java.io.Serializable;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkGrupoDatoDto;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;
import es.pfsgroup.recovery.geninformes.model.GENINFInforme;

/**
 * Clase que relaciona los tipos de input con los tipos de procedimiento.
 * @author manuel
 *
 */
@Entity
@Table(name = "BPM_TPI_TIPO_PROC_INPUT", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class RecoveryBPMfwkTipoProcInput  implements Auditable, Serializable{

	private static final long serialVersionUID = 8153283259128158815L;
    
    public static final String ALL_INCLUDED = "ALL";

    public static final String NONE_EXCLUDED = "NONE";   
    
    @Id
    @Column(name = "BPM_TPI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RecoveryBPMfwkTipoProcInputGenerator")
    @SequenceGenerator(name = "RecoveryBPMfwkTipoProcInputGenerator", sequenceName = "S_BPM_TPI_TIPO_PROC_INPUT")
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "BPM_DD_TIN_ID", nullable = false)
    private RecoveryBPMfwkDDTipoInput tipoInput;   
    
    @ManyToOne
    @JoinColumn(name = "DD_TPO_ID", nullable = false)
    private TipoProcedimiento tipoProcedimiento;
    
    @Column(name = "BPM_TPI_NODE_INC")
    private String nodesIncluded;

	@Column(name = "BPM_TPI_NODE_EXC")
    private String nodesExcluded;
	
    @ManyToOne
    @JoinColumn(name = "DD_INFORME_ID")
    private GENINFInforme plantilla;

	@Column(name = "BPM_TPI_NOMBRE_TRANSICION")
    private String nombreTransicion;
   
	@OneToMany(mappedBy = "tipoProcInput", fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "BPM_TPI_ID")
    private Set<RecoveryBPMfwkInputDatos> inputDatos;
    
    @ManyToOne
    @JoinColumn(name = "BPM_DD_TAC_ID", nullable = false)
    private RecoveryBPMfwkDDTipoAccion tipoAccion;

    @Column(name = "BPM_TPI_POST_PROCESS_BO")
    private String postProcessBo;

	@Column(name = "BPM_TPI_PRE_PROCESS_BO")
    private String preProcessBo;
    
	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    public Long getId() {
        return this.id;
    }
    
    public void setId(final Long id) {
        this.id = id;
    }    

    public Auditoria getAuditoria() {
        return auditoria;
    }

    public void setAuditoria(final Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    public RecoveryBPMfwkDDTipoInput getTipoInput() {
		return tipoInput;
	}

	public void setTipoInput(final RecoveryBPMfwkDDTipoInput tipoInput) {
		this.tipoInput = tipoInput;
	}

	public TipoProcedimiento getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setTipoProcedimiento(final TipoProcedimiento tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}

	public String getNodesIncluded() {
		return this.eliminaEspaciosEnBlaco(nodesIncluded);
	}
	
	public void setNodesIncluded(final String nodesIncluded) {
		this.nodesIncluded = nodesIncluded;
	}
	
	public void setNodesIncludedAsArray(final String[] nodesIncluded) {
		
		this.nodesIncluded = this.concatNodes(nodesIncluded, ",", RecoveryBPMfwkTipoProcInput.ALL_INCLUDED);
		
	}

	public String[] getNodesIncludedAsArray() {
		
		if (this.nodesIncluded == null || RecoveryBPMfwkTipoProcInput.ALL_INCLUDED.equals(this.getNodesIncluded()))
			return new String[]{RecoveryBPMfwkTipoProcInput.ALL_INCLUDED};
		return this.getNodesIncluded().split(",");
	}

	public void setNodesExcludedAsArray(final String[] nodesIncluded) {
		
		this.nodesExcluded = this.eliminaEspaciosEnBlaco(concatNodes(nodesIncluded, ",", RecoveryBPMfwkTipoProcInput.NONE_EXCLUDED));
		
	}
	
	public String[] getNodesExcludedAsArray() {
		if (this.nodesExcluded == null || RecoveryBPMfwkTipoProcInput.NONE_EXCLUDED.equals(this.getNodesExcluded()))
			return new String[]{RecoveryBPMfwkTipoProcInput.NONE_EXCLUDED};
		return this.getNodesExcluded().split(",");
	}

	public String getNodesExcluded() {
		return this.eliminaEspaciosEnBlaco(nodesExcluded);
	}

	public void setNodesExcluded(final String nodesExcluded) {
		this.nodesExcluded = this.eliminaEspaciosEnBlaco(nodesExcluded);
	}
	
    /**
     * Indica el tipo de acción a realizar. {@link RecoveryBPMfwkDDTipoAccion}
     * @return
     */
    public RecoveryBPMfwkDDTipoAccion getTipoAccion() {
        return tipoAccion;
    }

    public void setTipoAccion(RecoveryBPMfwkDDTipoAccion tipoAccion) {
        this.tipoAccion = tipoAccion;
    }	
    
	
    /**
     * Nombre de la transición hacia que la avanza el BMP. Para el caso de accciones de avanzar BPM.
     * @return
     */
    public String getNombreTransicion() {
		return nombreTransicion;
	}

	public void setNombreTransicion(String nombreTransicion) {
		this.nombreTransicion = nombreTransicion;
	}
	
    
	/**
	 * Plantilla que se generará. {@link GENINFInforme}
	 * @return
	 */
	public GENINFInforme getPlantilla() {
		return plantilla;
	}

	public void setPlantilla(GENINFInforme plantilla) {
		this.plantilla = plantilla;
	}
	
    
    public String getPostProcessBo() {
		return postProcessBo;
	}

	public void setPostProcessBo(String postProcessBo) {
		this.postProcessBo = postProcessBo;
	}

	public String getPreProcessBo() {
		return preProcessBo;
	}

	public void setPreProcessBo(String preProcessBo) {
		this.preProcessBo = preProcessBo;
	}

    public Integer getVersion() {
        return version;
    }
    
	public void setVersion(final Integer version) {
		this.version = version;
	}
	
	private String concatNodes(final String[] s, final String separator, String nullResult) {  
	    if (s != null && s.length > 0) {
	        StringBuilder sb = new StringBuilder(s[0]);  
	        for (int i = 1; i < s.length; i++) {  
	            sb.append(separator);  
	            sb.append(s[i]);  
	        }
	        return sb.toString();
	    }
	    return nullResult;
	}
	
	private String eliminaEspaciosEnBlaco(final String s){
		if (s!= null)
			return s.replaceAll("\\s","");
		else
			return null;
		
	}
	
    public Set<RecoveryBPMfwkInputDatos> getInputDatos() {
		return inputDatos;
	}

	public void setInputDatos(Set<RecoveryBPMfwkInputDatos> inputDatos) {
		this.inputDatos = inputDatos;
	}
	
    /**
     * Crea el Map del dto de configuración de datos a partir de la configuración de base de datos.
     * @param configTipoProcInput
     * @return
     */
    public Map<String, RecoveryBPMfwkGrupoDatoDto> getInputDatosAsCfgInputDtoMap() {
    	
    	Map<String, RecoveryBPMfwkGrupoDatoDto> mapa = new  HashMap<String, RecoveryBPMfwkGrupoDatoDto>();
        if (!Checks.estaVacio(this.getInputDatos())){
            for (RecoveryBPMfwkInputDatos dato : this.getInputDatos()){
            	RecoveryBPMfwkGrupoDatoDto dto = new RecoveryBPMfwkGrupoDatoDto();
            	dto.setDato(dato.getDato());
            	dto.setGrupo(dato.getGrupo());
            	dto.setNombreInput(dato.getNombre());
                mapa.put(dato.getNombre(), dto);
            }
        }
        return mapa;
    }
    
    /**
     * Método que comprueba si un nodo está incluido en la lista de nodos de esta configuración.
     * Devuelve true si:
     * 		- El nodo está en el campo de nodos incluidos.
     * 		- El nodo no está en la lista de nodos excluidos cuando aparece "ALL" en nodos incluidos.
     * @param nombreNodo nombre del nodo a buscar
     * @return true o false
     */
    public Boolean contieneElNodo(String nombreNodo){
    	
    	List<String> nodosIncluidos = Arrays.asList(this.getNodesIncludedAsArray());
    	List<String> nodosExcluidos = Arrays.asList(this.getNodesExcludedAsArray());

    	return (nodosIncluidos.contains(nombreNodo) 
    			|| (nodosIncluidos.contains(RecoveryBPMfwkTipoProcInput.ALL_INCLUDED) && !nodosExcluidos.contains(nombreNodo)));
    }

}
