package es.pfsgroup.plugin.recovery.mejoras.historicoProcedimiento;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.registro.HistoricoProcedimientoBuilder;
import es.capgemini.pfs.registro.HistoricoProcedimientoDto;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;

@Component
public class MEJHistoricoRecursoRevisadoBuilder implements HistoricoProcedimientoBuilder{
	
	public static final String NOMBRE_TAREA = "RecursoRevisado";

	protected static final long ID_TIPO_ENTIDAD_INFORMACION = 15 ;

	protected static final boolean REQUIERE_RESPUESTA = false;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	public List<HistoricoProcedimientoDto> getHistorico(long idProcedimiento) {
		List<? extends MEJRegistroInfo> registro = proxyFactory.proxy(MEJRegistroApi.class).buscaTrazasEvento(dtoBusqueda(idProcedimiento));
		ArrayList<HistoricoProcedimientoDto> historico = new ArrayList<HistoricoProcedimientoDto>();
		if (registro != null){
			for (MEJRegistroInfo traza : registro){
				historico.add(dtoHistorico(idProcedimiento,traza));
			}
		}
		
		return historico;
	}
	
	private MEJTrazaDto dtoBusqueda(final long idProcedimiento) {
		
		HashMap<String, Object> params = new HashMap<String, Object>();
		
		params.put("tipoUnidadGestion", DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
		params.put("tipoEvento", MEJDDTipoRegistro.CODIGO_REVISION_RECURSO);
		params.put("idUnidadGestion", idProcedimiento);
		
		return DynamicDtoUtils.create(MEJTrazaDto.class, params);
	}
	
	private HistoricoProcedimientoDto dtoHistorico(final long idProcedimiento, final MEJRegistroInfo traza) {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("tipoEntidad", ID_TIPO_ENTIDAD_INFORMACION);
		params.put("respuesta", REQUIERE_RESPUESTA);
		params.put("nombreUsuario", traza.getUsuario().getUsername());
		params.put("nombreTarea", traza.getTipo().getDescripcionLarga());
		params.put("idProcedimiento",idProcedimiento);
		params.put("idEntidad",traza.getId());
		params.put("fechaIni", traza.getFecha());
		return DynamicDtoUtils.create(HistoricoProcedimientoDto.class, params);
	}

}
