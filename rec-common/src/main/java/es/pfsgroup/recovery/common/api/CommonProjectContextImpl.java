package es.pfsgroup.recovery.common.api;

import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.UsuarioManager;

public class CommonProjectContextImpl implements CommonProjectContext {

	private Map<String, Map<String, String>> formatoNroContrato;
	private Map<String, String> tipoGestores;
	
	private final Log logger = LogFactory.getLog(getClass());
	
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
	    			contratoSubstring = StringUtils.substring(nroContrato, Integer.parseInt(formatoSubstringStart));
	    		} 
	    		else {
	    			contratoSubstring = StringUtils.substring(nroContrato, Integer.parseInt(formatoSubstringStart), Integer.parseInt(formatoSubstringEnd));
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

	@Override
	public Map<String, String> getTipoGestores() {
		return tipoGestores;
	}	
	
	public void setTipoGestores(Map<String, String> gestores) {
		this.tipoGestores = gestores;
	}
	
	public String getTipoGestor(String tipoGestor) {
		
		String gestor = "";
		
		if(tipoGestores != null) {
			
			gestor = tipoGestores.get(tipoGestor);
			if(gestor == null || "".equals(gestor)) {
				try {
					gestor = (String) EXTDDTipoGestor.class.getDeclaredField(tipoGestor).get(new EXTDDTipoGestor());
				} 
				catch (Exception e) {
					logger.error("Error en el método getTipoGestor(" + tipoGestor + "): " + e.getMessage());
				} 
			}
		}
		else {
			try {
				gestor = (String) EXTDDTipoGestor.class.getDeclaredField(tipoGestor).get(new EXTDDTipoGestor());
			} 
			catch (Exception e) {
				logger.error("Error en el método getTipoGestor(" + tipoGestor + "): " + e.getMessage());
			}
		}
		
		return gestor;
	}
}
