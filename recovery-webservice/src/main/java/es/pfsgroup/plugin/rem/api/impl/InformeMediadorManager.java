package es.pfsgroup.plugin.rem.api.impl;

import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.rem.api.InformeMediadorApi;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.rest.dto.InformeMediadorDto;

@Service("informeMediadorManager")
public class InformeMediadorManager implements InformeMediadorApi {

	private HashMap<String, HashMap<String, Boolean>> obligatorios;

	public InformeMediadorManager() {
		obligatorios = new HashMap<String, HashMap<String, Boolean>>();

		// codEstadoConservacion
		HashMap<String, Boolean> codEstadoConservacion = new HashMap<String, Boolean>();
		codEstadoConservacion.put(DDTipoActivo.COD_SUELO, true);
		codEstadoConservacion.put(DDTipoActivo.COD_COMERCIAL, true);
		codEstadoConservacion.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		codEstadoConservacion.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("codestadoconservacion", codEstadoConservacion);
	}

	@Override
	public void validateInformeField(List<String> errorsList, String fiedlName, Object fieldValor,
			String codigoTipoBien) {
		fiedlName = fiedlName.substring(3);
		HashMap<String, Boolean> permisos = obligatorios.get(fiedlName.toLowerCase());
		if (permisos != null) {
			if (permisos.containsKey(codigoTipoBien)
					&& (fieldValor == null || (fieldValor instanceof String && ((String) fieldValor).isEmpty()))) {
				errorsList.add("El campo ".concat(fiedlName).concat(" no puede ser null para el tipo activo ".concat(codigoTipoBien)));
			}
		}
	}

	@Override
	public void validateInformeMediadorDto(InformeMediadorDto informe, String codigoTipoBien,List<String> errorsList)
			throws IntrospectionException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		for (PropertyDescriptor propertyDescriptor : Introspector.getBeanInfo(InformeMediadorDto.class)
				.getPropertyDescriptors()) {
			Object obj = propertyDescriptor.getReadMethod().invoke(informe);
			this.validateInformeField(errorsList, propertyDescriptor.getReadMethod().getName(), obj, codigoTipoBien);
		}

	}

}
