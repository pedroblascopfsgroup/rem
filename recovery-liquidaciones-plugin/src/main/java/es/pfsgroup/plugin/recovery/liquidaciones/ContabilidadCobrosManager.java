package es.pfsgroup.plugin.recovery.liquidaciones;

import java.sql.Date;
import java.text.ParseException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.asunto.dao.AsuntoDao;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.liquidaciones.api.ContabilidadCobrosApi;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.ContabilidadCobrosDao;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.DtoContabilidadCobros;
import es.pfsgroup.plugin.recovery.liquidaciones.model.ContabilidadCobros;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableConceptoEntrega;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableTipoEntrega;


/**
 * Servicio para los documentos de precontencioso.
 * @author Kevin
 */
@Service
public class ContabilidadCobrosManager implements ContabilidadCobrosApi {
	
	@Autowired ContabilidadCobrosDao contabilidadCobrosDao;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private DictionaryManager dictionary;
	
	@Autowired
	private AsuntoDao asuntoDao;
	
	@Override
	@Transactional(readOnly=false)
	public void saveContabilidadCobro(DtoContabilidadCobros dto) {
		// Obtener los diccionarios por su columna 'CODIGO'.
		Dictionary tipoEntrega = dictionary.getByCode(DDAdjContableTipoEntrega.class, dto.getTipoEntrega());
		Dictionary conceptoEntrega = dictionary.getByCode(DDAdjContableConceptoEntrega.class, dto.getConceptoEntrega());
	
		ContabilidadCobros cnt = new ContabilidadCobros();
		
		if(!Checks.esNulo(dto.getId())){
			cnt = contabilidadCobrosDao.get(dto.getId());
		}
		
		/**Seteamos los valores de los campos**/
		cnt.setAsunto(asuntoDao.get(dto.getAsunto()));
		cnt.setConceptoEntrega((DDAdjContableConceptoEntrega) conceptoEntrega);
		cnt.setDemoras(dto.getDemoras());
		try {
			Date sqlFE = new java.sql.Date(DateFormat.toDate(dto.getFechaEntrega()).getTime());
			//cnt.setFechaEntrega(DateFormat.toDate(dto.getFechaEntrega()));
			cnt.setFechaEntrega(sqlFE);
			Date sqlFV = new java.sql.Date(DateFormat.toDate(dto.getFechaValor()).getTime());
			//cnt.setFechaValor(DateFormat.toDate(dto.getFechaValor()));
			cnt.setFechaValor(sqlFV);
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		cnt.setGastosLetrado(dto.getGastosLetrado());
		cnt.setGastosProcurador(dto.getGastosProcurador());
		cnt.setImporte(dto.getImporte());
		cnt.setImpuestos(dto.getImpuestos());
		cnt.setIntereses(dto.getIntereses());
		cnt.setNominal(dto.getNominal());
		cnt.setNumCheque(dto.getNumCheque());
		cnt.setNumEnlace(dto.getNumEnlace());
		cnt.setNumMandamiento(dto.getNumMandamiento());
		cnt.setObservaciones(dto.getObservaciones());
		cnt.setOtrosGastos(dto.getOtrosGastos());
		cnt.setQuitaDemoras(dto.getQuitaDemoras());
		cnt.setQuitaGastosLetrado(dto.getQuitaGastosLetrado());
		cnt.setQuitaGastosProcurador(dto.getQuitaGastosProcurador());
		cnt.setQuitaImpuestos(dto.getQuitaImpuestos());
		cnt.setQuitaIntereses(dto.getQuitaIntereses());
		cnt.setQuitaNominal(dto.getQuitaNominal());
		cnt.setQuitaOtrosGastos(dto.getOtrosGastos());
		cnt.setTipoEntrega((DDAdjContableTipoEntrega) tipoEntrega);
		cnt.setTotalEntrega(dto.getTotalEntrega());

		genericDao.save(ContabilidadCobros.class, cnt);
	}

	@Override
	public void deleteContabilidadCobro(Long idContabilidadCobro) {
		contabilidadCobrosDao.deleteById(idContabilidadCobro);
	}

	@Override
	public List<ContabilidadCobros> getListadoContabilidadCobros(
			DtoContabilidadCobros dto) {
		return (List<ContabilidadCobros>) contabilidadCobrosDao.getListadoContabilidadCobros(dto);
	}

	@Override
	public ContabilidadCobros getContabilidadCobroByID(DtoContabilidadCobros dto) {
		return contabilidadCobrosDao.getContabilidadCobroByID(dto);
	}

   
	
}
