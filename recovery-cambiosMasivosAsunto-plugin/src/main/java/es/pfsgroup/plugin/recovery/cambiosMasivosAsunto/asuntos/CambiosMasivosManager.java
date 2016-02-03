package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos.api.CambiosMasivosApi;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos.dao.CambiosMasivosDao;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos.dto.CambioMasivoGestoresPorAsuntosDtoImpl;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.model.PeticionCambioMasivoGestoresAsunto;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;

@Component
public class CambiosMasivosManager extends BusinessOperationOverrider<CambiosMasivosApi> implements CambiosMasivosApi{

	// tipos de acciones sobre el asunto nuevos 
	public static final String CODIGO_CAMBIO_MASIVO_GESTOR = "CAMBIO_MASIVO";
	
	// tipos de clave nuevos
	public static final String CODIGO_IRG_CLAVE_idUsuarioOld = "idUserOld";
	public static final String CODIGO_IRG_CLAVE_usuarioOld = "userOld";
	public static final String CODIGO_IRG_CLAVE_idUsuarioNew = "idUserNew";
	public static final String CODIGO_IRG_CLAVE_usuarioNew = "userNew";
	public static final String CODIGO_IRG_CLAVE_fechaInicio = "dateBegin";
	public static final String CODIGO_IRG_CLAVE_fechaFin = "dateEnd";
	// no hace falta pues el usuario que modifica es el que crea el registro
	//public static final String CODIGO_IRG_CLAVE_usuarioModifica = "userEdit";
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private CambiosMasivosDao cambiosMasivosDao;
	
	@Override
	@BusinessOperation("CambiosMasivosManager.getCambiosGestoresPendientes")
	public List<PeticionCambioMasivoGestoresAsunto> getCambiosGestoresPendientesPaginados(Long idAsunto) {
		return cambiosMasivosDao.buscarCambioGestoresPendientesPaginados(idAsunto);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation("CambiosMasivosManager.getCambiosGestoresHistorico")
	public List<? extends MEJRegistroInfo> getCambiosGestoresHistoricoPaginados(Long idAsunto) {

		@SuppressWarnings("rawtypes")
		List trazas;
		
		MEJTrazaDto dto = creaPeticionBusquedaTraza(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, idAsunto,CODIGO_CAMBIO_MASIVO_GESTOR);
		trazas = proxyFactory.proxy(MEJRegistroApi.class).buscaTrazasEvento(dto);
		
		return trazas;
	}

	private MEJTrazaDto creaPeticionBusquedaTraza(
			final String tipoUnidadGestion, final Long idUnidadGestion,
			final String tipoEvento) {
		MEJTrazaDto dto = new MEJTrazaDto() {

			@Override
			public long getUsuario() {
				return 0;
			}

			@Override
			public String getTipoUnidadGestion() {
				return tipoUnidadGestion;
			}

			@Override
			public String getTipoEvento() {
				return tipoEvento;
			}

			@Override
			public Map<String, Object> getInformacionAdicional() {
				return null;
			}

			@Override
			public long getIdUnidadGestion() {
				return idUnidadGestion;
			}
		};
		return dto;
	}

	@Override
	public String managerName() {
		return "CambiosMasivosManager";
	}

	@Override
	@BusinessOperation("CambiosMasivosManager.anotarCambiosPendientesPorAsuntos")
	public void anotarCambiosPendientesPorAsuntos(CambioMasivoGestoresPorAsuntosDtoImpl dto) {
		if (dto == null) {
			throw new IllegalArgumentException("dto no puede ser null");
		}

		cambiosMasivosDao.insertDirectoPeticionesPorAsuntos(dto.getSolicitante(), dto.getTipoGestor(), dto.getIdGestorOriginal(), dto.getFechaInicio(), dto.getFechaFin(), dto.getListaAsuntos() );
	}

	@BusinessOperation("CambiosMasivosManager.asunto.web.getTabs")
    public List<DynamicElement> getTabs() {
        List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("plugin.cambiosmasivos.web.asuntos.tabs", null);
        if (l == null) {
            return new ArrayList<DynamicElement>();
        } else {
            return l;
        }
    }
	
}
