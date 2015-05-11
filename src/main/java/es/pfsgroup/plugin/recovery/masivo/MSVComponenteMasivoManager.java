package es.pfsgroup.plugin.recovery.masivo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.plugin.recovery.masivo.api.MSVComponenteMasivoApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResultadoOperacionMasivaDto;

@Component
public class MSVComponenteMasivoManager implements MSVComponenteMasivoApi{

	@Autowired(required=false)
	private List<MSVComponenteMasivoListener> listeners;
	
	@Override
	@BusinessOperation(MSV_BO_EJECUTA_OPERACION_MASIVA)
	//FIXME Quitar la dependencia del WebRequest (perteneciente a una capa superior)
	//Se ha detectado una dependencia en el plugin de busqueda de tareas. Esto ha de hacerse con cuidado.
	public MSVResultadoOperacionMasivaDto ejecutaOperacionMasiva(List<Long> lista, String nombre,
			WebRequest request) {
		MSVResultadoOperacionMasivaDto map =new MSVResultadoOperacionMasivaDto();
		if(listeners!=null){
			for (int i = 0; i < listeners.size(); i++){
				MSVComponenteMasivoListener l=listeners.get(i);
				if (l.getNombreOperacionMasiva().equals(nombre)){
					map= l.ejecuta(lista, request.getParameterMap());
				}
			}
		}
		return map;
	}

}
