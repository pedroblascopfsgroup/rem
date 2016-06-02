package es.capgemini.pfs.actitudAptitudActuacion.dto;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.actitudAptitudActuacion.model.ActitudAptitudActuacion;
import es.capgemini.pfs.expediente.model.Expediente;

/**
 * Clase que transfiere información desde la vista hacia el modelo.
 * @author mtorrado
 *
 */
public class DtoActitudAptitudActuacion extends WebDto {

    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = -750630200328882018L;

    private ActitudAptitudActuacion aaa;
    
    private Long exp;

    /**
     * Retorna el atributo aaa.
     * @return aaa
     */
    public ActitudAptitudActuacion getAaa() {
        return aaa;
    }

    /**
     * Setea el atributo aaa.
     * @param aaa ActitudAptitudActuacion
     */
    public void setAaa(ActitudAptitudActuacion aaa) {
        this.aaa = aaa;
    }

	public Long getExp() {
		return exp;
	}

	public void setExp(Long expId) {
		this.exp = expId;
	}

}
