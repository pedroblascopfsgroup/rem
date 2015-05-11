package es.pfsgroup.recovery.ext.impl.adjunto;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.ext.api.adjunto.AdjuntoAsuntoApi;
import es.pfsgroup.recovery.ext.api.tipoFicheroAdjunto.dao.DDTipoFicheroAdjuntoDao;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Component
public class AdjuntoAsuntoManager implements AdjuntoAsuntoApi {

	@Autowired
	private DDTipoFicheroAdjuntoDao tipoFicheroAdjuntoDao;
	
	@Override
	@BusinessOperation(BO_GET_LISTA_DD_TIPO_FICHERO_ADJUNTOS)
	public List<DDTipoFicheroAdjunto> getList(List<DDTipoActuacion> listaActuaciones) {
		if(!Checks.estaVacio(listaActuaciones)){
			return tipoFicheroAdjuntoDao.getListaPorTipoDeActuacion(listaActuaciones);
		}else
			return tipoFicheroAdjuntoDao.getList();
	}

}
