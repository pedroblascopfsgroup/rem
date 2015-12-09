package es.pfsgroup.recovery.common.api;

import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.users.UsuarioManager;

public class CommonProjectContextImpl implements CommonProjectContext {

	private Map<String, Map<String, String>> formatoNroContrato;
	
	@Autowired
	UsuarioManager usuarioManager;
	
	@Override
	public Map<String, String> getFormatoNroContrato() {
		
		Entidad entidad = usuarioManager.getUsuarioLogado().getEntidad();
		if(formatoNroContrato == null) {
			return null;
		}
		else {
			return formatoNroContrato.get(entidad.getDescripcion());
		}
	}
	
	public void setFormatoNroContrato(Map<String, Map<String, String>> formatoNroContrato) {
		this.formatoNroContrato = formatoNroContrato;
	}

	@Override
	public String getNroContratoFormateado(String nroContrato) {
		
		Map<String, String> formatoNroContrato = getFormatoNroContrato();
		
		if (formatoNroContrato == null ) {
    		return nroContrato;
    	}
		else {
			String contratoSubstring = nroContrato;
			String formato = formatoNroContrato.get(APPConstants.CNT_PROP_FORMATO_CONTRATO);
			String formatoSubstringStart = formatoNroContrato.get(APPConstants.CNT_PROP_FORMAT_SUBST_INI);
			String formatoSubstringEnd = formatoNroContrato.get(APPConstants.CNT_PROP_FORMAT_SUBST_FIN);
	    	
	    	if (formatoSubstringStart != null || formatoSubstringEnd != null) {
	    		
	    		if (formatoSubstringStart== null) {
	    			formatoSubstringStart="0";
	    		} 
	    		
	    		if (formatoSubstringEnd==null) {
	    			contratoSubstring = nroContrato.substring(Integer.parseInt(formatoSubstringStart));
	    		} 
	    		else {
	    			contratoSubstring = nroContrato.substring(Integer.parseInt(formatoSubstringStart), Integer.parseInt(formatoSubstringEnd));
	    		} 
	    	}
	    	
	    	if (formato!= null) {
		    	String[] formatDigitos = formato.split(",");
		    	int longitud = 0;
		    	for (int i=0;i<formatDigitos.length;i++) {
		    		longitud += Integer.parseInt(formatDigitos[i]);
		    	}
		    	
		    	String nroContratoCompleto = StringUtils.leftPad(contratoSubstring, longitud, "0");
		    	String nroContratoFormat = "";
		    	int digitoInicio = 0;
		    	int digitoFinal = 0;
		    	for (int i=0;i<formatDigitos.length;i++) {
		    		if (i>0) {
		    			nroContratoFormat += " ";
		    		}
		    		digitoFinal += Integer.parseInt(formatDigitos[i]);
		    		nroContratoFormat += nroContratoCompleto.substring(digitoInicio, digitoFinal);
		    		digitoInicio += Integer.parseInt(formatDigitos[i]);
		    	}
		    	return nroContratoFormat;
	    	} 
	    	else {
	    		return contratoSubstring;
	    	}
		}
	}
}
