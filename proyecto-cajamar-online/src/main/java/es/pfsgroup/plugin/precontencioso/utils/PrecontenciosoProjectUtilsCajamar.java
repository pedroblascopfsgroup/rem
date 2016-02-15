package es.pfsgroup.plugin.precontencioso.utils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectUtils;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.DDPropietarioPCODto;

@Service("PrecontenciosoProjectUtils")
public class PrecontenciosoProjectUtilsCajamar implements
		PrecontenciosoProjectUtils {

	private static final String SEPARADOR = "|";
	private static final String PATRON_SEPARADOR = Pattern.quote(SEPARADOR);
	
	@Autowired
	private Map<String, String> listaEntidades;
	
	@Autowired
	private List<String> listaLocalidades;

	@Override
	public void setListaEntidades(Map<String, String> listaEntidades) {
		this.listaEntidades = listaEntidades;
	}

	@Override
	public void setListaLocalidades(List<String> listaLocalidades) {
		this.listaLocalidades = listaLocalidades;
	}

	@Override
	public Map<String, String> getListaEntidades() {
		return listaEntidades;
	}

	@Override
	public List<String> getListaLocalidades() {
		return listaLocalidades;
	}

	public List<DDPropietarioPCODto> getListaEntidadesPropietarias() {
		List<DDPropietarioPCODto> lista = new ArrayList<DDPropietarioPCODto>();
		if (!Checks.esNulo(listaEntidades)) {
			for (Map.Entry<String, String> entry : listaEntidades.entrySet()) {
				DDPropietarioPCODto prop = new DDPropietarioPCODto();
				prop.setCodigo(entry.getKey());
				prop.setDescripcion(obtenerNombre(entry.getValue()));
				lista.add(prop);
			}
		}
		Collections.sort(lista);
		return lista;
	}

	public String obtenerNombre(String valor) {
		if (!Checks.esNulo(valor)) {
			if (valor.contains(SEPARADOR)) {
				return valor.split(PATRON_SEPARADOR)[0];
			} else {
				return valor;
			}
		} else {
			return "";
		}
	}
	
	public String obtenerInfoExtra(String valor) {
		if (!Checks.esNulo(valor)) {
			if (valor.contains(SEPARADOR) && valor.split(PATRON_SEPARADOR).length>1) {
				return valor.split(PATRON_SEPARADOR, 2)[1];
			} else {
				return valor;
			}
		} else {
			return "";
		}
	}
	
	public String obtenerNombrePorClave(String clave) {
		if (!Checks.esNulo(clave) && !Checks.esNulo(listaEntidades) && !Checks.esNulo(listaEntidades.get(clave))) {
			return obtenerNombre(listaEntidades.get(clave));
		} else {
			return "";
		}
	}
	
	public String obtenerInfoPorClave(String clave) {
		if (!Checks.esNulo(clave) && !Checks.esNulo(listaEntidades) && !Checks.esNulo(listaEntidades.get(clave))) {
			return obtenerInfoExtra(listaEntidades.get(clave));
		} else {
			return "";
		}
	}
	
}
