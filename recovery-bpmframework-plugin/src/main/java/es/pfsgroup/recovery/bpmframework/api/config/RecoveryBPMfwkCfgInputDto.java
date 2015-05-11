package es.pfsgroup.recovery.bpmframework.api.config;

import java.io.Serializable;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

//import edu.emory.mathcs.backport.java.util.Arrays;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;

/**
 * DTO para la configuración de un INPUT
 * 
 * @author bruno
 * 
 */
public class RecoveryBPMfwkCfgInputDto implements Serializable {

	private static final long serialVersionUID = -7629169937395007935L;

    private String codigoTipoInput;

    private String codigoTipoAccion;

    private String codigoTipoProcedimiento;

    private boolean defaultNodesIncluded;

    private String[] nodesIncluded;

    private String[] nodesExcluded;
    
    private String codigoPlantilla;
    
    private String nombreTransicion;
    
    private String postProcessBo;
    
    private String preProcessBo;

    private Map<String, RecoveryBPMfwkGrupoDatoDto> configDatos;

    /**
     * Devuelve el código del tipo de input
     * 
     * @return
     */
    public String getCodigoTipoInput() {
        return codigoTipoInput;
    }

    /**
     * Setea el código del tipo de input
     * 
     * @param codigoTipoInput
     */
    public void setCodigoTipoInput(final String codigoTipoInput) {
        this.codigoTipoInput = codigoTipoInput;
    }

    /**
     * Devuelve el código del tipo de acción
     * 
     * @return
     */
    public String getCodigoTipoAccion() {
        return codigoTipoAccion;
    }

    /**
     * Setea el código del tipo de acción
     * 
     * @param codigoTipoAccion
     */
    public void setCodigoTipoAccion(final String codigoTipoAccion) {
        this.codigoTipoAccion = codigoTipoAccion;
    }

    /**
     * Devuelve el código del tipo de procedimiento.
     * 
     * @return
     */
    public String getCodigoTipoProcedimiento() {
        return codigoTipoProcedimiento;
    }

    /**
     * Setea el código del tipo de procedimiento.
     * 
     * @param codigoTipoProcedimiento
     */
    public void setCodigoTipoProcedimiento(final String codigoTipoProcedimiento) {
        this.codigoTipoProcedimiento = codigoTipoProcedimiento;
    }

    /**
     * Nos dice si, por defecto, todos los nodos del procedimiento son válidos
     * para el tipo de input.
     * 
     * @return
     */
    public boolean isDefaultNodesIncluded() {
        return defaultNodesIncluded;
    }

    /**
     * Setea si, por defecto, todos los nodos del procedimiento son válidos para
     * el tipo de input.
     * 
     * @param defaultNodesIncluded
     */
    public void setDefaultNodesIncluded(final boolean defaultNodesIncluded) {
        this.defaultNodesIncluded = defaultNodesIncluded;
    }

    /**
     * Nodos explícitamente válidos.
     * 
     * @return <strong>Devuelve un array vacío, nunca NULL, si no hay valores</strong>
     */
    public String[] getNodesIncluded() {
        String[] toreturn = new String[]{};
        if ((nodesIncluded != null) && (nodesIncluded.length > 0)) {
            toreturn = (String[]) Arrays.copyOf(nodesIncluded, nodesIncluded.length);
        }
        return toreturn;
    }

    /**
     * Nodos explícitamente válidos.
     * 
     * @param nodesIncluded
     *            <strong> No puede ser null</strong>
     */
    public void setNodesIncluded(final String[] nodesIncluded) {
        Assertions.assertNotNull(nodesExcluded, "El parámetro no puede ser null");
        this.nodesIncluded = (String[]) Arrays.copyOf(nodesIncluded, nodesIncluded.length);
    }

    /**
     * Nodos explícitamente inválidos.
     * 
     * @return <strong>Devuelve un array vacío, nunca NULL, si no hay valores</strong>
     */
    public String[] getNodesExcluded() {
        String[] toreturn = new String[]{};
        if ((nodesExcluded != null) && (nodesExcluded.length > 0)) {
            toreturn = (String[]) Arrays.copyOf(nodesExcluded, nodesExcluded.length);
        }
        return toreturn;
    }

    /**
     * Nodos explícitamente inválidos.
     * 
     * @param nodesExcluded
     *            <strong>No puede ser null</strong>
     */
    public void setNodesExcluded(final String[] nodesExcluded) {
        Assertions.assertNotNull(nodesExcluded, "El parámetro no puede ser null");
        this.nodesExcluded = (String[]) Arrays.copyOf(nodesExcluded, nodesExcluded.length);
    }

    /**
     * Configuración para los datos introducidos en el Input.
     * <p>
     * Se trata de un mapa cuya clave es el nombre del dato y el valor un objeto
     * que indica en qué grupo y con qué nombre ha de persistirse el dato en el
     * contexto del procedimiento.
     * </p>
     * 
     * @return <strong>Devuelve un mapa vacío (no null) si no hay configuración
     *         de daatos</strong>
     */
    public Map<String, RecoveryBPMfwkGrupoDatoDto> getConfigDatos() {
        Map<String, RecoveryBPMfwkGrupoDatoDto> toreturn = new HashMap<String, RecoveryBPMfwkGrupoDatoDto>();
        if (!Checks.estaVacio(configDatos)) {
            toreturn = Collections.unmodifiableMap(configDatos);
        }
        return toreturn;
    }

    /**
     * Configuración para los datos introducidos en el Input.
     * <p>
     * Se trata de un mapa cuya clave es el nombre del dato y el valor un objeto
     * que indica en qué grupo y con qué nombre ha de persistirse el dato en el
     * contexto del procedimiento.
     * </p>
     * 
     * @param configDatos
     *            <strong> No puede ser null</strong>
     */
    public void setConfigDatos(final Map<String, RecoveryBPMfwkGrupoDatoDto> configDatos) {
        Assertions.assertNotNull(configDatos, "El parámetro no puede ser null ni estar vacío");
        this.configDatos = Collections.unmodifiableMap(configDatos);
    }

	/**
	 * Devuelve el código de plantilla. Opcional.
	 * Hay que rellenarlo si el tipo de acción es generar documentación. 
	 * @return
	 */
	public String getCodigoPlantilla() {
		return codigoPlantilla;
	}

	public void setCodigoPlantilla(String codigoPlantilla) {
		this.codigoPlantilla = codigoPlantilla;
	}

	/**
	 * Transición a la que hay que enviar el BMP. Opcional.
	 * Hay que rellenarlo en el caso de tipo de acción avanzar BMP ó forward BMP.
	 * @return
	 */
	public String getNombreTransicion() {
		return nombreTransicion;
	}

	public void setNombreTransicion(String nombreTransicion) {
		this.nombreTransicion = nombreTransicion;
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
    @Override
	public String toString() {
		return "RecoveryBPMfwkCfgInputDto [codigoTipoInput=" + codigoTipoInput
				+ "\n, codigoTipoAccion=" + codigoTipoAccion
				+ "\n, codigoTipoProcedimiento=" + codigoTipoProcedimiento
				+ "\n, defaultNodesIncluded=" + defaultNodesIncluded
				+ "\n, nodesIncluded=" + Arrays.toString(nodesIncluded)
				+ "\n, nodesExcluded=" + Arrays.toString(nodesExcluded)
				+ "\n, codigoPlantilla=" + codigoPlantilla
				+ "\n, nombreTransicion=" + nombreTransicion + "\n, configDatos="
				+ this.getKeysToString() + "]";
	}
    
    private String getKeysToString(){
    	StringBuffer buffer = new StringBuffer();
    	buffer.append("{");
    	for(Map.Entry<String,RecoveryBPMfwkGrupoDatoDto> entry : this.getConfigDatos().entrySet()){
    		buffer.append(entry.getKey()).append(",");
    	}
    	buffer.append("}\n");
		return buffer.toString();
    	
    }

}
