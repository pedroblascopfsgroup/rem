package es.pfsgroup.plugin.recovery.busquedaTareas.prorroga;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.MSVComponenteMasivoListener;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResultadoOperacionMasivaDto;

@Component
public class BTAAutoprorrogaMasivaListener implements MSVComponenteMasivoListener{
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired 
	private Executor executor;
	
	@Override
	public String getNombreOperacionMasiva() {
		return "autoprorrogaMasivaTareas";
	}

	@Override
	public MSVResultadoOperacionMasivaDto ejecuta(List<Long> lista, Map request) {
		MSVResultadoOperacionMasivaDto dto = new MSVResultadoOperacionMasivaDto();
		dto.setNumeroOperacionesRealizadas(0);
		dto.setNumeroOperacionesFallidas(0);
		
		for(Long idTarea : lista){
			try{
			
			DtoSolicitarProrroga autoprorrogaDto = generarDto(request,idTarea);
			executor.execute("plugin.mejoras.tareaNotificacion.generarAutoprorroga", autoprorrogaDto);
			dto.setNumeroOperacionesRealizadas(dto.getNumeroOperacionesRealizadas()+1);
			}catch (Exception e) {
				dto.setNumeroOperacionesFallidas(dto.getNumeroOperacionesFallidas()+1);
			}
		}
		return dto;
	}

	private DtoSolicitarProrroga generarDto(Map request, Long idTarea){
		DtoSolicitarProrroga dto= new DtoSolicitarProrroga();
		TareaNotificacion tn = proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea)	;
		dto.setIdEntidadInformacion(tn.getIdEntidad());
		dto.setIdTipoEntidadInformacion(tn.getTipoEntidad().getCodigo());
		dto.setCodigoCausa(((Object[])request.get("codigoCausa"))[0].toString());
		//dto.setCodigoCausa(request.get("codigoCausa").toString());
		//dto.setDescripcionCausa(request.get("descripcionCausa").toString());
		dto.setDescripcionCausa(((Object[])request.get("descripcionCausa"))[0].toString());
		
		if(DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(dto
				.getIdTipoEntidadInformacion())){
			if (Checks.esNulo(tn.getTareaExterna())){
				dto.setIdTareaAsociada(tn.getId());
				dto.setIdTipoEntidadInformacion(DDTipoEntidad.CODIGO_ENTIDAD_TAREA);
			}else{
				dto.setIdTareaAsociada(tn.getTareaExterna().getId());
			}
		}else{
			dto.setIdTareaAsociada(tn.getId());
		}
		
		try {
			String fecha=((Object[])request.get("fechaPropuesta"))[0].toString();
			dto.setFechaPropuesta(DateFormat.toDate(fecha));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return dto;

	}


}
