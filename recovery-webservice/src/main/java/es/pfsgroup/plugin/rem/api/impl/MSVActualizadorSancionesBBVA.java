package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.controller.AgendaController;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoPeticionesPrecios;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;
import es.pfsgroup.plugin.rem.rest.dto.HistoricoPropuestasPreciosDto;

@Component
public class MSVActualizadorSancionesBBVA extends AbstractMSVActualizador implements MSVLiberator {
	
	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	@Autowired
	private AgendaAdapter agendaAdapter;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SANCIONES_BBVA;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws Exception {
		Oferta oferta = ofertaApi.getOfertaByNumOfertaRem(Long.parseLong(exc.dameCelda(fila, 0)));
		String fechaRespuestaComite = exc.dameCelda(fila, 1);
		String resolucionComite = exc.dameCelda(fila, 2); 	
		String importeContraoferta = exc.dameCelda(fila, 3);
		
		TransactionStatus transaction = null;
		//Long idTareaExterna = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
		//ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);
		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		
		Filter filterTap01 = genericDao.createFilter(FilterType.EQUALS, "codigo", "T013_ResolucionComite");
		Long idResolucionComite = genericDao.get(TareaProcedimiento.class, filterTap01).getId();
		
		// Obtenemos el tramite del expediente, y de este sus tareas.
		List<ActivoTramite> listaTramites = activoTramiteApi
				.getTramitesActivoTrabajoList(expedienteComercial.getTrabajo().getId());
		List<TareaExterna> tareasTramite = activoTareaExternaApi
				.getActivasByIdTramiteTodas(listaTramites.get(0).getId());
		//idTareaExterna = tareasTramite.get(0).getId();

		
		Map<String, String[]> valoresTarea = new HashMap<String, String[]>();
		DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
		Date date = format.parse(fechaRespuestaComite);
		valoresTarea.put("fechaRespuesta", new String[] { format.format(date) });
		valoresTarea.put("comboResolucion", new String[] { resolucionComite });
		if(resolucionComite.equals("03")) {
			valoresTarea.put("numImporteContra",  new String[] { importeContraoferta });
		} 
		valoresTarea.put("observaciones", new String[] { "Masivo Sanciones BBVA" });
		valoresTarea.put("idTarea", new String[] { tareasTramite.get(0).getTareaPadre().getId().toString() });
		
		agendaAdapter.save(valoresTarea);
		transactionManager.commit(transaction);
		
	} catch (Exception e) {
		transactionManager.rollback(transaction);
		throw e;
	}
		
		/*ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		if(fechaRespuestaComite != null && !fechaRespuestaComite.isEmpty()) { 
			expediente.setFechaSancion(new SimpleDateFormat("dd/MM/yyyy").parse(fechaRespuestaComite));
		}*/
		
		

	
		return new ResultadoProcesarFila();
	}

}