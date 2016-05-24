package es.pfsgroup.recovery.ext.impl.adjunto;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.tipoFicheroAdjuntoEntidad.DDTipoAdjuntoEntidad;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.recovery.ext.api.adjunto.AdjuntoAsuntoApi;
import es.pfsgroup.recovery.ext.api.tipoAdjuntoEntidad.dao.DDTipoAdjuntoEntidadDao;
import es.pfsgroup.recovery.ext.api.tipoFicheroAdjunto.dao.DDTipoFicheroAdjuntoDao;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Component
public class AdjuntoAsuntoManager implements AdjuntoAsuntoApi {

	@Autowired
	private DDTipoFicheroAdjuntoDao tipoFicheroAdjuntoDao;
	
	@Autowired
	private DDTipoAdjuntoEntidadDao tipoAdjuntoEntidadDao;
	
	@Autowired(required=false)
	private CoreProjectContext coreProjectContext;
	
	@Override
	@BusinessOperation(BO_GET_LISTA_DD_TIPO_FICHERO_ADJUNTOS)
	public List<DDTipoFicheroAdjunto> getList(List<DDTipoActuacion> listaActuaciones) {
		if(!Checks.estaVacio(listaActuaciones)){
			return tipoFicheroAdjuntoDao.getListaPorTipoDeActuacion(listaActuaciones);
		}else
			return tipoFicheroAdjuntoDao.getList();
	}
	
	@Override
	@BusinessOperation(BO_GET_LISTA_DD_TIPO_ADJUNTO_ENTIDAD)
	public List<DDTipoAdjuntoEntidad> getListTipoAdjuntoEntidad(String tipoEntidad){
		return tipoAdjuntoEntidadDao.obtenerTiposAdjuntosPorEntidad(tipoEntidad);
	}

	@Override
	public boolean esFechaCaducidadVisible(String codigoFichero) {
		
		boolean visible = false;
		
		if(coreProjectContext != null && coreProjectContext.getCodigosDocumentosConFechaCaducidad() != null) {
			List<String> codigosDocumentosConFechaCaducidad = coreProjectContext.getCodigosDocumentosConFechaCaducidad();
			if(codigosDocumentosConFechaCaducidad.contains(codigoFichero)) {
				visible = true;
			}
		}

		return visible;
	}

}
