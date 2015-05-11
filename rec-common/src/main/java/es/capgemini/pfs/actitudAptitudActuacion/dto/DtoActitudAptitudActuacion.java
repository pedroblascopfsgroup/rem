package es.capgemini.pfs.actitudAptitudActuacion.dto;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.actitudAptitudActuacion.model.ActitudAptitudActuacion;

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

}
