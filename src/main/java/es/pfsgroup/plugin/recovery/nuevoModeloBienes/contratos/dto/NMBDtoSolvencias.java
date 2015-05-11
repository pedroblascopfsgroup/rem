package es.pfsgroup.plugin.recovery.nuevoModeloBienes.contratos.dto;

import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBPersonasBienInfo;

public class NMBDtoSolvencias extends WebDto {

    /**
     * serial.
     */
    private static final long serialVersionUID = -6637787116506547314L;

    private String nombreApellidos;
    
    private Long id;
    
    private List <? extends NMBPersonasBienInfo> solvencias;

	/**
	 * @param solvencias the solvencias to set
	 */
	public void setSolvencias(List <? extends NMBPersonasBienInfo> solvencias) {
		this.solvencias = solvencias;
	}

	/**
	 * @return the solvencias
	 */
	public List <? extends NMBPersonasBienInfo> getSolvencias() {
		return solvencias;
	}

	/**
	 * @param nombreApellidos the nombreApellidos to set
	 */
	public void setNombreApellidos(String nombreApellidos) {
		this.nombreApellidos = nombreApellidos;
	}

	/**
	 * @return the nombreApellidos
	 */
	public String getNombreApellidos() {
		return nombreApellidos;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}


    
}
