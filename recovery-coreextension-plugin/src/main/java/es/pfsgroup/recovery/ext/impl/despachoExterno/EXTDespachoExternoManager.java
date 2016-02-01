package es.pfsgroup.recovery.ext.impl.despachoExterno;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.despachoExterno.dao.DespachoExternoDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.dao.EXTTipoGestorPropiedadDao;
import es.capgemini.pfs.multigestor.model.EXTTipoGestorPropiedad;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.api.DespachoExternoApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;

@Component
public class EXTDespachoExternoManager extends
		BusinessOperationOverrider<DespachoExternoApi> implements
		DespachoExternoApi {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private DespachoExternoDao despachoExternoDao;
	
    /**
     * Devuelve una lista de despachos segun la lista de zonas
     * @param zonas
     * @return
     */
	@Override
    public List<DespachoExterno> getDespachosPorTipoZona(String zonas, String tipoDespacho) {
        return despachoExternoDao.buscarDespachosPorTipoZona(zonas, tipoDespacho);
    }	

	/**
	 * DOV - 14/12/2011 
	 * tanto si es multiGestor o no solo se deben obtener
	 * los gestores del despacho.
	 * 
	 */
	@Override
	@BusinessOperation(overrides = "despachoExternoManager.getGestoresDespacho")
	public List<GestorDespacho> getGestoresDespacho(Long arg0) {
		//if (proxyFactory.proxy(EXTAsuntoApi.class).modeloMultiGestor()) {
			//return getTodosLosGestoresOSupervisoresDelDespacho(arg0);
		//} else {
			return parent().getGestoresDespacho(arg0);
		//}
	}

	private List<GestorDespacho> getTodosLosGestoresOSupervisoresDelDespacho(
			Long idDespacho) {
		return genericDao.getList(GestorDespacho.class, genericDao
				.createFilter(FilterType.EQUALS, "despachoExterno.id",
						idDespacho));
	}

	@Override
	public String managerName() {
		return "despachoExternoManager";
	}
	
	@BusinessOperation("despachoExternoManager.getDespachosTipoGestorZona")
    public List<DespachoExterno> getDespachosTipoGestorZona(String zonas, Long idTipoGestor) {
    	//Primero obtenemos los tipoDespachos codigo del TipoGestor
    	List<EXTTipoGestorPropiedad> listTiposDespachoCodigo = genericDao.getList(EXTTipoGestorPropiedad.class, genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", idTipoGestor),
    													genericDao.createFilter(FilterType.EQUALS, "clave", EXTTipoGestorPropiedad.TGP_CLAVE_DESPACHOS_VALIDOS),
    													genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
    	
    	//Por cada registro, y valor separado por comas recibido, obtenemos sus despachos externos
    	List<DespachoExterno> despachos = new ArrayList<DespachoExterno>();
    	
    	for (EXTTipoGestorPropiedad propiedad : listTiposDespachoCodigo) {
			String[] valores = propiedad.getValor().split(",");
			
			for (String valor : valores) {
				if (!valor.equals("")) {
					//Por cada valor obtenemos los despachos
					List<DespachoExterno> listaDelValor = this.getDespachosPorTipoZona(zonas, valor);
					
					//Y ahora insertamos los que no hubieramos obtenido en otra iteracción para no enviar duplicados
					for (DespachoExterno despachoExterno : listaDelValor) {
						if (!despachos.contains(despachoExterno)) {
							despachos.add(despachoExterno);
						}
					}
				}
			}
		}

    	//Devolvemos los despachos obtenidos
        return despachos;
    }

}
