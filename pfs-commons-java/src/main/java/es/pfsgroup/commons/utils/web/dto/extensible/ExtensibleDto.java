package es.pfsgroup.commons.utils.web.dto.extensible;

import java.util.HashMap;
import java.util.Map;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;

/**
 * Funcionalidad genérica que dota a los DTO que extiendan la capacidad de ser
 * extensibles.
 * 
 * @author bruno
 * 
 */
public abstract class ExtensibleDto extends WebDto {
    

    private static final long serialVersionUID = -169019718603055143L;

    private String dynamicParams;

    private Map<String, String> pmap;

    /**
     * Devuelve un mapa con los parámetros dinámicos.
     * 
     * @return
     */
    public final Map<String, String> getParametersMap() {
        return (!Checks.esNulo(pmap)) ? pmap : null;
    }

    public final void setDynamicParams(final String string) {
        if (!Checks.esNulo(string)) {
            this.dynamicParams = string;
            this.pmap = compruebaFormatoYconvierteAmap(this.dynamicParams);
        }

    }



    private final Map<String, String> compruebaFormatoYconvierteAmap(final String params) {
        final HashMap<String, String> paramMap = new HashMap<String, String>();
        final String[] claveValor = params.split(";");

        String[] param;
        for (int i = 0; i < claveValor.length; i++) {
            param = claveValor[i].split(":");
            if (param.length == 2){
            paramMap.put(param[0], param[1]);
            }else if (param.length == 1){
                // No hamemos nada, simplemente no fallamos.
            }else{
                throw new ExtensibleDtoBadFormatException(params);
            }
        }
        return paramMap;
    }
}
