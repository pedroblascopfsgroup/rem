package es.pfsgroup.concursal.convenio.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.concursal.convenio.model.ConvenioCredito;

public interface ConvenioCreditoDao extends AbstractDao<ConvenioCredito, Long>{

	/**
	 * Devuelve los convenioCréditos asociados a un convenio.
	 * @param idConvenio Tenemos que pasar el id de un convenio
	 * @return
	 */
	public List<ConvenioCredito> findByIdConvenio(Long idConvenio);
	
	/**
	 * Devuelve los convenioCréditos asociados a un convenio y un credito.
	 * @param 	idConvenio id del convenio a buscar
	 * @param 	idCredito id del credito a buscar
	 * @return  Lista de ConvenioCreditos encontrados según los parametros recividos
	 */
	public List<ConvenioCredito> findByIdConvenioIdCredito(Long idConvenio, Long idCredito);

	/**
	 * Eliminar los convenioCreditos que pertenezcan al IdCredito recivido
	 * @param 	idCredito
	 * @return  true o false según la operación
	 */
	public List<ConvenioCredito> findByIdCredito(Long idCredito);
	
}
