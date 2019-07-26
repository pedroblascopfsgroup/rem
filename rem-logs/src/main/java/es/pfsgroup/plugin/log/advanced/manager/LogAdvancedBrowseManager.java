package es.pfsgroup.plugin.log.advanced.manager;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.Authentication;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.pfsgroup.plugin.log.advanced.api.LogAdvancedRem;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.log.advanced.api.LogAdvancedBrowseApi;
import es.pfsgroup.plugin.log.advanced.dto.LogAdvancedDto;

@Component
public class LogAdvancedBrowseManager extends LogAdvancedManager implements LogAdvancedBrowseApi {

	@Autowired
	private UsuarioApi usuarioApi;

	@Autowired
	LogAdvancedRem logAdvanceRem;

	@Override
	public void registerLog(String uri, Map<String, Object> parameters) {

		HashMap<String, HashMap<String, HashMap<String, String>>> mapAccesRegistrer = logAdvanceRem
				.getRegisterLogAccesDevo();

		if (!Checks.esNulo(mapAccesRegistrer) && !mapAccesRegistrer.isEmpty()) {

			Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
			UsuarioSecurity userSec = (UsuarioSecurity) authentication.getPrincipal();

			HashMap<String, String> carteraEntidad = logAdvanceRem.getEntidadPadreCartera();

			if (!Checks.esNulo(carteraEntidad) && !carteraEntidad.isEmpty()) {

				String codigoEntidad = carteraEntidad.get(userSec.getEntidad().getCodigo());

				if (!Checks.esNulo(codigoEntidad)) {

					HashMap<String, HashMap<String, String>> mapEntidad = mapAccesRegistrer.get(codigoEntidad);
					if (!Checks.esNulo(mapEntidad)) {
						HashMap<String, String> mapDataLog = mapEntidad.get(uri);
						if (!Checks.esNulo(mapDataLog)) {
							String msg = mapDataLog.get(MAP_KEY_TYPE) + "|" + mapDataLog.get(MAP_KEY_ENTIDADCODE) + "|"
									+ getIdEntidad(parameters, mapDataLog.get(MAP_KEY_NAMEID)) + "|"
									+ userSec.getUsername() + "|" + mapDataLog.get(MAP_KEY_DESCRIPTION) + "| " + "| "
									+ "| ";
							// String msgSyslog = "["+mapDataLog.get(MAP_KEY_TYPE)+"]"+" El usuario
							// "+userSec.getUsername()+" ha realizado la accion:
							// "+mapDataLog.get(MAP_KEY_DESCRIPTION)+" ,para el identificador
							// "+getIdEntidad(parameters,mapDataLog.get(MAP_KEY_NAMEID));
							String msgSyslog = "[" + mapDataLog.get(MAP_KEY_TYPE) + "] |"
									+ mapDataLog.get(MAP_KEY_ENTIDADCODE) + "|"
									+ getIdEntidad(parameters, mapDataLog.get(MAP_KEY_NAMEID)) + "|"
									+ userSec.getUsername() + "|" + mapDataLog.get(MAP_KEY_DESCRIPTION);
							writeLog(new LogAdvancedDto(msg, Integer.parseInt(mapDataLog.get(MAP_KEY_PRIORITY)),
									msgSyslog));
						}
					}
				}
			}
		}

	}

	private String getIdEntidad(Map<String, Object> parameters, String key) {
		if (!Checks.esNulo(key) && !Checks.esNulo(parameters.get(key))) {
			return ((String[]) parameters.get(key))[0];
		} else {
			return "";
		}
	}

}
