package es.pfsgroup.plugin.recovery.masivo.inputfactory.impl;

import java.util.Map;

import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.MSVSelectorTipoInput;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVAdmisionDemandaColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.liberators.impl.dinamicFields.MSVAdmisionDemandaDinamicFields;

@Component
public class MSVSelectorAdmisionDemanda implements MSVSelectorTipoInput{

	@Override
	public String getTipoInput(Map<String, Object> map) {
		//Si el procedimiento es un ejecutivo el input es autodespachando
		if (("1249".equals(map.get(MSVAdmisionDemandaColumns.TIPO_PROCEDIMIENTO))) 
				|| ("1441".equals(map.get(MSVAdmisionDemandaColumns.TIPO_PROCEDIMIENTO)))) {
			return "Total".equals(map.get(MSVAdmisionDemandaColumns.TIPO_ADMISION)) ?
				 MSVDDOperacionMasiva.CODIGO_INPUT_AUTO_DESPACHANDO_TOTAL_BATCH :
				 MSVDDOperacionMasiva.CODIGO_INPUT_AUTO_DESPACHANDO_PARCIAL_BATCH;
		} else {
			return "Total".equals(map.get(MSVAdmisionDemandaDinamicFields.getFields().get(MSVAdmisionDemandaColumns.TIPO_ADMISION))) ?				
				MSVDDOperacionMasiva.CODIGO_INPUT_ADMISION_TOTAL_DEMANDA_BATCH :
				MSVDDOperacionMasiva.CODIGO_INPUT_ADMISION_PARCIAL_DEMANDA_BATCH;
		}
	}

	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODIGO_ADMISION_DEMANDA.equals(tipoOperacion.getCodigo())){
				return true;
			}else {
				return false;
			}
		}else{
			return false;
		}
	}

	@Override
	public String getTipoResolucion() {
		return MSVDDOperacionMasiva.CODIGO_ADMISION_DEMANDA;
	}

}
