package es.pfsgroup.recovery.panelcontrol.letrados.manager;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.panelcontrol.judicial.dao.PCTipoPlazaDao;
import es.pfsgroup.recovery.panelcontrol.letrados.api.PanelControlLetradosApi;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoCampanya;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoCartera;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoColumnas;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoDetallePanelControlLetrados;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoLetrado;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoLote;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoPanelControlFiltros;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoPanelControlLetrados;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.PCDtoQuery;
import es.pfsgroup.recovery.panelcontrol.letrados.manager.model.DDRangoImportePanelControl;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.columnaTareaExp.dao.PCColumnaTareaExpDao;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.columnaTareaExp.model.PCColumnaTareaExp;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTarea.dao.PCExpedienteTareaDao;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTareaResumen.dao.PCExpedienteTareaResumenDao;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTareaResumen.model.PCExpedienteTareaResumen;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.nivel.model.PCNivel;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.zona.dao.PCZonaDao;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.zona.model.PCZona;

@Component("panelControlLetradosManager")
public class PanelControlLetradosManager implements PanelControlLetradosApi {

	@Autowired
	private PCZonaDao zonaDao;

	@Autowired
	private PCExpedienteTareaDao expedienteTareaDao;

	@Autowired
	private PCExpedienteTareaResumenDao expedienteTareaResumenDao;

	@Autowired
	private PCColumnaTareaExpDao columnaTareaExpDao;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private PCTipoPlazaDao tipoPlazaDao;

	@Override
	@BusinessOperation(PANEL_CONTROL_LETRADOS_GET_DATOS_POR_JERARQUIA)
	public List<DtoPanelControlLetrados> getDatosPorJerarquia(DtoPanelControlFiltros dtoFiltros) {
		List<DtoPanelControlLetrados> lista = new ArrayList<DtoPanelControlLetrados>();
		
		//Si se rellena el combo de importes, calculamos el valor min y max.
		if (StringUtils.hasText(dtoFiltros.getRangoImporte())){
			Filter filtroRangoImportes = genericDao.createFilter(FilterType.EQUALS, "codigo",dtoFiltros.getRangoImporte());
			DDRangoImportePanelControl rangoImporte = genericDao.get(DDRangoImportePanelControl.class, filtroRangoImportes);
			dtoFiltros.setMinImporteFiltro(rangoImporte.getValorInicial().doubleValue());
			dtoFiltros.setMaxImporteFiltro(rangoImporte.getValorFinal().doubleValue());
		} 
		List<PCZona> listaZonas = new ArrayList<PCZona>();
		
//		if(!Checks.esNulo(dtoFiltros.getLote()) && (Checks.esNulo(dtoFiltros.getCod()) || "0".equals(dtoFiltros.getCod()) )){
//			PCZona zona=genericDao.get(PCZona.class, genericDao.createFilter(FilterType.EQUALS, "descripcion", dtoFiltros.getLote()));
//			dtoFiltros.setCod(zona.getCodigo());
//		}
		if (!Checks.esNulo(dtoFiltros.getCartera()) && (Checks.esNulo(dtoFiltros.getCod()) || "0".equals(dtoFiltros.getCod()) )){
			PCZona zona=genericDao.get(PCZona.class, genericDao.createFilter(FilterType.EQUALS, "descripcion", dtoFiltros.getCartera()));
			dtoFiltros.setCod(zona.getCodigo());
		}
		
		if (dtoFiltros.getCod() != null && !dtoFiltros.getCod().equals("0")) {
			if (dtoFiltros.getNivel().equals(305L))
				listaZonas = zonaDao.getLetrados(dtoFiltros.getNivel(), dtoFiltros.getCod());
			else
				listaZonas = zonaDao.getListaZonas(dtoFiltros.getNivel(), dtoFiltros.getCod());
		} else {
			listaZonas = zonaDao.getListaZonas(dtoFiltros.getNivel());
		}
		

		if (dtoFiltros.getNivel().equals(305L)) {
			if (!Checks.estaVacio(listaZonas)) {
				for (PCZona zona : listaZonas) {
					List<String> listaIdLetrados = expedienteTareaDao.getLetrados(zona.getCodigo());
					rellenaListaConLetrados(lista, zona, listaIdLetrados,dtoFiltros);
				}
			} else {
				List<String> listaIdLetrados = expedienteTareaDao.getTodosLetrados();
				rellenaListaConLetrados(lista, null, listaIdLetrados,dtoFiltros);
			}

		} else {
			
			for (PCZona zona : listaZonas) {
				DtoPanelControlLetrados dto = new DtoPanelControlLetrados();
				dto.setNivel(zona.getDescripcion());
				dto.setId(zona.getId());
				dto.setCod(zona.getCodigo());
				
			    Boolean sentencia=((dtoFiltros.getTipoProcedimiento() != null && !dtoFiltros.getTipoProcedimiento().equals(""))
			    		||(dtoFiltros.getIdPlaza()!=null && !dtoFiltros.getIdPlaza().equals(""))
			    		||(dtoFiltros.getIdJuzgado()!=null && !dtoFiltros.getIdJuzgado().equals(""))  
			    		|| (dtoFiltros.getTipoTarea() != null && !dtoFiltros.getTipoTarea().equals("")) 
			    		|| (dtoFiltros.getCampanya() != null && !dtoFiltros.getCampanya().equals(""))
			    		||(dtoFiltros.getCartera() != null && !dtoFiltros.getCartera().equals("")) 
			    		||(dtoFiltros.getLote() != null && !dtoFiltros.getLote().equals("")) 
			    		|| (dtoFiltros.getLetradoGestor() != null && !dtoFiltros.getLetradoGestor().equals("")) 
			    		|| dtoFiltros.getMaxImporteFiltro() != null || dtoFiltros.getMinImporteFiltro() != null );

				Long numeroExpedientes;
				
				if (sentencia)
					numeroExpedientes = expedienteTareaDao.getNumeroExpedientes(zona.getCodigo(),dtoFiltros);
				else
					numeroExpedientes = expedienteTareaResumenDao.getNumeroExpedientes(zona.getCodigo());
				dto.setTotalExpedientes(numeroExpedientes);

				Float importeExpedientes = null;
				if (sentencia)  
					importeExpedientes = expedienteTareaDao.getImporteExpedientes(zona.getCodigo(),dtoFiltros);
				else
					importeExpedientes = expedienteTareaResumenDao.getImporteExpedientes(zona.getCodigo());
				dto.setImporte(importeExpedientes);

				Long tareasVencias;
				if (sentencia)  
					tareasVencias = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "TV",dtoFiltros);
				else
					tareasVencias = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 1);
				dto.setTareasVencidas(tareasVencias);
				
				Float importeVencidas;
				
				importeVencidas = expedienteTareaDao.getImportePorTareas(zona.getCodigo(), "TV",dtoFiltros);
				
				dto.setImporteVencido(importeVencidas);
				
				Float importePendientes; 
				importePendientes = expedienteTareaDao.getImportePorTareas(zona.getCodigo(), "PM",dtoFiltros);
				dto.setImportePendiente(importePendientes);
				
				Long vencidasMas6Meses;
				if (sentencia)  
					vencidasMas6Meses = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "VM6M",dtoFiltros);
				else
					vencidasMas6Meses = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 21);
				dto.setVencidasMas6Meses(vencidasMas6Meses);
				
				Long vencidas6Meses;
				if (sentencia)  
					vencidas6Meses = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "V6M",dtoFiltros);
				else
					vencidas6Meses = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 20);
				dto.setVencidas6Meses(vencidas6Meses);
				
				Long vencidas5Meses;
				if (sentencia)  
					vencidas5Meses = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "V5M",dtoFiltros);
				else
					vencidas5Meses = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 19);
				dto.setVencidas5Meses(vencidas5Meses);
				
				Long vencidas4Meses;
				if (sentencia)  
					vencidas4Meses = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "V4M",dtoFiltros);
				else
					vencidas4Meses = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 18);
				dto.setVencidas4Meses(vencidas4Meses);
				
				Long vencidas3Meses;
				if (sentencia)  
					vencidas3Meses = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "V3M",dtoFiltros);
				else
					vencidas3Meses = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 17);
				dto.setVencidas3Meses(vencidas3Meses);
				
				Long vencidas2Meses;
				if (sentencia)  
					vencidas2Meses = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "V2M",dtoFiltros);
				else
					vencidas2Meses = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 16);
				dto.setVencidas2Meses(vencidas2Meses);
				
				Long vencidas1Mes;
				if (sentencia)  
					vencidas1Mes = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "V1M",dtoFiltros);
				else
					vencidas1Mes = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 15);
				dto.setVencidas1Mes(vencidas1Mes);
				
				Long vencidasSemana;
				if (sentencia)  
					vencidasSemana = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "VS",dtoFiltros);
				else
					vencidasSemana = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 14);
				dto.setVencidasSemana(vencidasSemana);

				Long pendientesHoy;
				if (sentencia)  
					pendientesHoy = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "PH",dtoFiltros);
				else
					pendientesHoy = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 4);
				dto.setTareasPendientesHoy(pendientesHoy);

				Long pendientesSemana;
				if (sentencia)  
					pendientesSemana = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "PS",dtoFiltros);
				else
					pendientesSemana = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 3);
				dto.setTareasPendientesSemana(pendientesSemana);

				Long pendientesMes;
				if (sentencia)  
					pendientesMes = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "PM",dtoFiltros);
				else
					pendientesMes = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 2);
				dto.setTareasPendientesMes(pendientesMes);
				
				Long tareasPendientes2Meses;
				if (sentencia)  
					tareasPendientes2Meses = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "P2M",dtoFiltros);
				else
					tareasPendientes2Meses = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 22);
				dto.setTareasPendientes2Meses(tareasPendientes2Meses);
				
				Long tareasPendientes3Meses;
				if (sentencia)  
					tareasPendientes3Meses = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "P3M",dtoFiltros);
				else
					tareasPendientes3Meses = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 23);
				dto.setTareasPendientes3Meses(tareasPendientes3Meses);
				
				Long tareasPendientes4Meses;
				if (sentencia)  
					tareasPendientes4Meses = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "P4M",dtoFiltros);
				else
					tareasPendientes4Meses = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 24);
				dto.setTareasPendientes4Meses(tareasPendientes4Meses);
				
				Long tareasPendientes5Meses;
				if (sentencia)  
					tareasPendientes5Meses = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "P5M",dtoFiltros);
				else
					tareasPendientes5Meses = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 25);
				dto.setTareasPendientes5Meses(tareasPendientes5Meses);
				
				Long tareasPendientesMas6Meses;
				if (sentencia)  
					tareasPendientesMas6Meses = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "PM6M",dtoFiltros);
				else
					tareasPendientesMas6Meses = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 26);
				dto.setTareasPendientesMas6Meses(tareasPendientesMas6Meses);

				Long pendientesMasMes;
				if (sentencia)  
					pendientesMasMes = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "PMM",dtoFiltros);
				else
					pendientesMasMes = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 5);
				dto.setTareasPendientesMasMes(pendientesMasMes);

				Long pendientesMasAnyo;
				if (sentencia)  
					pendientesMasAnyo = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "PA",dtoFiltros);
				else
					pendientesMasAnyo = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 6);
				dto.setTareasPendientesMasAnyo(pendientesMasAnyo);

				Long finalizadasAyer;
				if (sentencia)  
					finalizadasAyer = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "FH",dtoFiltros);
				else
					finalizadasAyer = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 9);
				dto.setTareasFinalizadasAyer(finalizadasAyer);
				
				Long finalizadasSemana;
				if (sentencia)   
					finalizadasSemana = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "FS",dtoFiltros);
				else
					finalizadasSemana = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 10);
				dto.setTareasFinalizadasSemana(finalizadasSemana);
				
				Long finalizadasMes;
				if (sentencia)   
					finalizadasMes = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "FM",dtoFiltros);
				else
					finalizadasMes = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 11);
				dto.setTareasFinalizadasMes(finalizadasMes);
				
				Long finalizadasAnyo;
				if (sentencia)   
					finalizadasAnyo = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "FA",dtoFiltros);
				else
					finalizadasAnyo = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 12);
				dto.setTareasFinalizadasAnyo(finalizadasAnyo);
				
				Long finalizadas;
				if (sentencia)   
					finalizadas = expedienteTareaDao.totalTareasPendientes(zona.getCodigo(), "TF",dtoFiltros);
				else
					finalizadas = expedienteTareaResumenDao.totalTareasPendientes(zona.getCodigo(), 13);
				dto.setTareasFinalizadas(finalizadas);
				
				lista.add(dto);
			}
		}
		return lista;
	}
	
	
	@Override
	@BusinessOperation(PANEL_CONTROL_LETRADOS_GET_DATOS_POR_JERARQUIA_CONF)
	public Page getDatosPorJerarquiaV2(DtoPanelControlFiltros dto) {
		PageSql page = new PageSql();

		List<Map<String, Object>> lista = new ArrayList<Map<String, Object>>();

		List<PCColumnaTareaExp> colunmas = columnaTareaExpDao.getColumns(dto.getTipo());
		
		
		List<DtoPanelControlLetrados> datos = this.getDatosPorJerarquia(dto);

		if (!Checks.estaVacio(datos)) {
			for (DtoPanelControlLetrados o : datos) {
				lista.add(createMapaDTO(colunmas, o));
			}
		}

		int size = lista.size();

		int fromIndex = dto.getStart();
		int toIndex = dto.getStart() + dto.getLimit();

		// Paginado, si no existe, creamos la paginación nosotros
		if (fromIndex < 0 || toIndex < 0) {
			fromIndex = 0;
			toIndex = 25;
		}

		if (lista.size() >= dto.getStart() + dto.getLimit())
			lista = lista.subList(fromIndex, toIndex);
		else
			lista = lista.subList(fromIndex, size);

		page.setTotalCount(size);
		page.setResults(lista);

		return page;
	}


	private List<Object[]> getDatosPorJerarquiaConfigurable(
			DtoPanelControlFiltros dto) {
		List<Object[]> lista =new ArrayList<Object[]>();
		
		return lista;
	}


	private void rellenaListaConLetrados(List<DtoPanelControlLetrados> lista,PCZona zona, List<String> listaIdLetrados,DtoPanelControlFiltros dtoFiltros) {
		for (String idLetrado : listaIdLetrados) {
			
			
			Filter filtroLetrado = genericDao.createFilter(FilterType.EQUALS, "id",idLetrado);
			PCExpedienteTareaResumen letrado = genericDao.get(PCExpedienteTareaResumen.class, filtroLetrado);
			
			Boolean sentencia=((dtoFiltros.getTipoProcedimiento() != null && !dtoFiltros.getTipoProcedimiento().equals(""))  || (dtoFiltros.getTipoTarea() != null && !dtoFiltros.getTipoTarea().equals("")) || (dtoFiltros.getLetradoGestor() != null && !dtoFiltros.getLetradoGestor().equals("")) || (dtoFiltros.getCampanya() != null && !dtoFiltros.getCampanya().equals("")) || (dtoFiltros.getMinImporteFiltro()!= null && !dtoFiltros.getMinImporteFiltro().equals("")) || (dtoFiltros.getMaxImporteFiltro()!= null && !dtoFiltros.getMaxImporteFiltro().equals("")));
			
			if (sentencia){
				if ((dtoFiltros.getLetradoGestor() != null && !dtoFiltros.getLetradoGestor().equals(""))){
					if (dtoFiltros.getLetradoGestor().equals(letrado.getLetrado())){
						DtoPanelControlLetrados dto = creaDTOPanelParaLetradoConFiltros(zona,idLetrado,dtoFiltros);
						lista.add(dto);
					}	
				}else{
					DtoPanelControlLetrados dto = creaDTOPanelParaLetradoConFiltros(zona,idLetrado,dtoFiltros);
					lista.add(dto);
				}
			}else{
				DtoPanelControlLetrados dto = creaDTOPanelParaLetrado(zona,idLetrado,dtoFiltros);
				lista.add(dto);
			}

		}
	}
	
	private DtoPanelControlLetrados creaDTOPanelParaLetradoConFiltros(PCZona zona,String idLetrado,DtoPanelControlFiltros dtoFiltros) {
		DtoPanelControlLetrados dto = new DtoPanelControlLetrados();
		
		dto.setUserName(idLetrado);
		if (!Checks.esNulo(zona)) {
			dto.setId(zona.getId());
			dto.setCod(zona.getCodigo());
		}
		
		Filter filtroLetrado = genericDao.createFilter(FilterType.EQUALS, "id",idLetrado);
		PCExpedienteTareaResumen letrado = genericDao.get(PCExpedienteTareaResumen.class, filtroLetrado);
		
		dto.setNivel(letrado.getLetrado());
		
		dto.setTotalExpedientes(expedienteTareaDao.getNumeroExpedientesPorLetrado(idLetrado,dtoFiltros));
		dto.setImporte(expedienteTareaDao.getImporteExpedientesPorLetrado(idLetrado,dtoFiltros));
		dto.setTareasVencidas(expedienteTareaDao.totalTareasPendientesPorLetrado("TV", idLetrado, dtoFiltros));
		dto.setVencidasMas6Meses(expedienteTareaDao.totalTareasPendientesPorLetrado("VM6M", idLetrado, dtoFiltros));
		dto.setVencidas6Meses(expedienteTareaDao.totalTareasPendientesPorLetrado("V6M", idLetrado, dtoFiltros));
		dto.setVencidas5Meses(expedienteTareaDao.totalTareasPendientesPorLetrado("V5M", idLetrado, dtoFiltros));
		dto.setVencidas4Meses(expedienteTareaDao.totalTareasPendientesPorLetrado("V4M", idLetrado, dtoFiltros));
		dto.setVencidas3Meses(expedienteTareaDao.totalTareasPendientesPorLetrado("V3M", idLetrado, dtoFiltros));
		dto.setVencidas2Meses(expedienteTareaDao.totalTareasPendientesPorLetrado("V2M", idLetrado, dtoFiltros));
		dto.setVencidas1Mes(expedienteTareaDao.totalTareasPendientesPorLetrado("V1M", idLetrado, dtoFiltros));
		dto.setVencidasSemana(expedienteTareaDao.totalTareasPendientesPorLetrado("VS", idLetrado, dtoFiltros));
		dto.setTareasPendientesHoy(expedienteTareaDao.totalTareasPendientesPorLetrado("PH", idLetrado, dtoFiltros));
		dto.setTareasPendientesSemana(expedienteTareaDao.totalTareasPendientesPorLetrado("PS", idLetrado, dtoFiltros));
		dto.setTareasPendientesMes(expedienteTareaDao.totalTareasPendientesPorLetrado("PM", idLetrado, dtoFiltros));
		dto.setTareasPendientes2Meses(expedienteTareaDao.totalTareasPendientesPorLetrado("P2M", idLetrado, dtoFiltros));
		dto.setTareasPendientes3Meses(expedienteTareaDao.totalTareasPendientesPorLetrado("P3M", idLetrado, dtoFiltros));
		dto.setTareasPendientes4Meses(expedienteTareaDao.totalTareasPendientesPorLetrado("P4M", idLetrado, dtoFiltros));
		dto.setTareasPendientes5Meses(expedienteTareaDao.totalTareasPendientesPorLetrado("P5M", idLetrado, dtoFiltros));
		dto.setTareasPendientesMas6Meses(expedienteTareaDao.totalTareasPendientesPorLetrado("PM6", idLetrado, dtoFiltros));
		dto.setTareasPendientesMasMes(expedienteTareaDao.totalTareasPendientesPorLetrado("PMM", idLetrado, dtoFiltros));
		dto.setTareasPendientesMasAnyo(expedienteTareaDao.totalTareasPendientesPorLetrado("PA", idLetrado, dtoFiltros));
		dto.setTareasFinalizadasAyer(expedienteTareaDao.totalTareasPendientesPorLetrado("FH", idLetrado, dtoFiltros));
		dto.setTareasFinalizadasSemana(expedienteTareaDao.totalTareasPendientesPorLetrado("FS", idLetrado, dtoFiltros));
		dto.setTareasFinalizadasMes(expedienteTareaDao.totalTareasPendientesPorLetrado("FM", idLetrado, dtoFiltros));
		dto.setTareasFinalizadasAnyo(expedienteTareaDao.totalTareasPendientesPorLetrado("FA", idLetrado, dtoFiltros));
		dto.setTareasFinalizadas(expedienteTareaDao.totalTareasPendientesPorLetrado("TF", idLetrado, dtoFiltros));
		dto.setUserName(idLetrado);

		return dto;
	}
	
	private DtoPanelControlLetrados creaDTOPanelParaLetrado(PCZona zona,String idLetrado,DtoPanelControlFiltros dtoFiltros) {
		DtoPanelControlLetrados dto = new DtoPanelControlLetrados();
		
		dto.setUserName(idLetrado);
		if (!Checks.esNulo(zona)) {
			dto.setId(zona.getId());
			dto.setCod(zona.getCodigo());
		}
		
		Filter filtroLetrado = genericDao.createFilter(FilterType.EQUALS, "id",idLetrado);
		PCExpedienteTareaResumen letrado = genericDao.get(PCExpedienteTareaResumen.class, filtroLetrado);
		
		dto.setNivel(letrado.getLetrado());
		
		List<PCExpedienteTareaResumen> listaTareasPendientes = expedienteTareaResumenDao.buscaTareasPendientesLetradosPanelControl(idLetrado);
		for (PCExpedienteTareaResumen listaTareas : listaTareasPendientes) {
			dto.setTotalExpedientes(listaTareas.getExpediente());
			dto.setImporte(listaTareas.getSaldo());
			dto.setTareasVencidas(listaTareas.getNum_tv());
			dto.setVencidasMas6Meses(listaTareas.getNum_vm6m());
			dto.setVencidas6Meses(listaTareas.getNum_v6m());
			dto.setVencidas5Meses(listaTareas.getNum_v5m());
			dto.setVencidas4Meses(listaTareas.getNum_v4m());
			dto.setVencidas3Meses(listaTareas.getNum_v3m());
			dto.setVencidas2Meses(listaTareas.getNum_v2m());
			dto.setVencidas1Mes(listaTareas.getNum_v1m());
			dto.setVencidasSemana(listaTareas.getNum_vs());
			dto.setTareasPendientesHoy(listaTareas.getNum_ph());
			dto.setTareasPendientesSemana(listaTareas.getNum_ps());
			dto.setTareasPendientesMes(listaTareas.getNum_pm());
			dto.setTareasPendientes2Meses(listaTareas.getNum_p2m());
			dto.setTareasPendientes3Meses(listaTareas.getNum_p3m());
			dto.setTareasPendientes4Meses(listaTareas.getNum_p4m());
			dto.setTareasPendientes5Meses(listaTareas.getNum_p5m());
			dto.setTareasPendientesMas6Meses(listaTareas.getNum_p6m());
			dto.setTareasPendientesMasMes(listaTareas.getNum_pmm());
			dto.setTareasPendientesMasAnyo(listaTareas.getNum_pa());
			dto.setTareasFinalizadasAyer(listaTareas.getNum_fh());
			dto.setTareasFinalizadasSemana(listaTareas.getNum_fs());
			dto.setTareasFinalizadasMes(listaTareas.getNum_fm());
			dto.setTareasFinalizadasAnyo(listaTareas.getNum_fa());
			dto.setTareasFinalizadas(listaTareas.getNum_tf());
			dto.setUserName(listaTareas.getId());
		}

		return dto;
	}

	@Override
	@BusinessOperation(GET_ASUNTOS)
	public Page getAsuntos(DtoDetallePanelControlLetrados dto) {

		PageSql page = new PageSql();

		List<Map<String, Object>> lista = new ArrayList<Map<String, Object>>();

		//Si se rellena el combo de importes, calculamos el valor min y max.
		if (StringUtils.hasText(dto.getRangoImporte())){
			Filter filtroRangoImportes = genericDao.createFilter(FilterType.EQUALS, "codigo",dto.getRangoImporte());
			DDRangoImportePanelControl rangoImporte = genericDao.get(DDRangoImportePanelControl.class, filtroRangoImportes);
			dto.setMinImporteFiltro(rangoImporte.getValorInicial().doubleValue());
			dto.setMaxImporteFiltro(rangoImporte.getValorFinal().doubleValue());
		}
		
		List<PCColumnaTareaExp> colunmas = columnaTareaExpDao.getColumns(dto.getTipo());

		
		//TODO:Esto habría que cambiarlo porque recupera todas las filas y luego pagina. Tendría que paginar en la query directamente.
		List<Object[]> datos = expedienteTareaDao.getExpedientes(dto);

		if (!Checks.estaVacio(datos)) {
			for (Object[] o : datos) {
				lista.add(createMapa(colunmas, o));
			}
		}

		int size = lista.size();

		int fromIndex = dto.getStart();
		int toIndex = dto.getStart() + dto.getLimit();

		// Paginado, si no existe, creamos la paginación nosotros
		if (fromIndex < 0 || toIndex < 0) {
			fromIndex = 0;
			toIndex = 25;
		}

		if (lista.size() >= dto.getStart() + dto.getLimit())
			lista = lista.subList(fromIndex, toIndex);
		else
			lista = lista.subList(fromIndex, size);

		page.setTotalCount(size);
		page.setResults(lista);

		return page;

	}

	@Override
	@BusinessOperation(GET_FECHA_REFRESCO)
	public String getFechaRefresco() {
		return expedienteTareaResumenDao.getFechaRefresco();
	}

	@Override
	@BusinessOperation(GET_COLUMNS)
	public List<DtoColumnas> getColumns(String tipo) {

		List<DtoColumnas> lista = new ArrayList<DtoColumnas>();

		List<PCColumnaTareaExp> listaColumnas = columnaTareaExpDao
				.getColumns(tipo);

		for (PCColumnaTareaExp col : listaColumnas) {
			DtoColumnas dto = new DtoColumnas();

			dto.setHeader(col.getHeader());
			dto.setAlign(col.getAlign());
			dto.setDataindex(col.getDataindex());
			dto.setId(col.getId());
			dto.setSortable(col.getSortable());
			dto.setWidth(col.getWidth());
			dto.setHidden(col.getHidden());
			dto.setType(col.getType());
			dto.setFlowClick(col.getFlowClick());
			dto.setPanelTareas(col.getPanelTareas());
			dto.setEtiqueta(col.getEtiqueta());
			
			lista.add(dto);
		}

		return lista;
	}

	/**
	 * Obtiene los datos que se van a mostrar en el grid dinámico
	 * 
	 * @return lista de Resultados
	 */
	@Override
	@BusinessOperation(GET_TAREAS_PANEL_CONTROL)
	public Page generaDatosStore(DtoDetallePanelControlLetrados dto) {

		PageSql page = new PageSql();

		List<Map<String, Object>> lista = new ArrayList<Map<String, Object>>();
		
		//Si se rellena el combo de importes, calculamos el valor min y max.
		if (StringUtils.hasText(dto.getRangoImporte())){
			Filter filtroRangoImportes = genericDao.createFilter(FilterType.EQUALS, "codigo",dto.getRangoImporte());
			DDRangoImportePanelControl rangoImporte = genericDao.get(DDRangoImportePanelControl.class, filtroRangoImportes);
			dto.setMinImporteFiltro(rangoImporte.getValorInicial().doubleValue());
			dto.setMaxImporteFiltro(rangoImporte.getValorFinal().doubleValue());
		}

		List<PCColumnaTareaExp> colunmas = columnaTareaExpDao.getColumns(dto
				.getTipo());

		List<Object[]> datos = getTareasPendientesPanelControl(dto);

		if (!Checks.estaVacio(datos)) {
			for (Object[] o : datos) {
				lista.add(createMapa(colunmas, o));
			}
		}
 
		int size = lista.size();

		int fromIndex = dto.getStart();
		int toIndex = dto.getStart() + dto.getLimit();

		// Paginado, si no existe, creamos la paginación nosotros
		if (fromIndex < 0 || toIndex < 0) {
			fromIndex = 0;
			toIndex = 25;
		}

		if (lista.size() >= dto.getStart() + dto.getLimit())
			lista = lista.subList(fromIndex, toIndex);
		else
			lista = lista.subList(fromIndex, size);

		page.setTotalCount(size);
		page.setResults(lista);

		return page;

	}

	private Map<String, Object> createMapa(List<PCColumnaTareaExp> colunmas,Object[] o) {
		LinkedHashMap<String, Object> mapa = new LinkedHashMap<String, Object>();

		for (PCColumnaTareaExp col : colunmas) {
			mapa.put(col.getDataindex(), o[col.getColIndex() - 1]);
		}

		return mapa;
	}
	
	private Map<String, Object> createMapaDTO(List<PCColumnaTareaExp> colunmas,
			DtoPanelControlLetrados o) {
		LinkedHashMap<String, Object> mapa = new LinkedHashMap<String, Object>();

		for (PCColumnaTareaExp col : colunmas) {
			mapa.put(col.getDataindex(), getPropiedadDTO(o, col.getDataindex()));
		}

		return mapa;
	}

	private Object getPropiedadDTO(DtoPanelControlLetrados o, String dataindex) {
		if (Checks.esNulo(o) || Checks.esNulo(dataindex)){
			return null;
		}
		
		try {
			Field f = o.getClass().getDeclaredField(dataindex);
			if (f != null){
				f.setAccessible(true);
				return f.get(o);
			}else{
				return null;
			}
		} catch (SecurityException e) {
			return null;
		} catch (NoSuchFieldException e) {
			return null;
		} catch (IllegalArgumentException e) {
			return null;
		} catch (IllegalAccessException e) {
			return null;
		}
		
	}


	@SuppressWarnings("unchecked")
	private List<Object[]> getTareasPendientesPanelControl(
			DtoDetallePanelControlLetrados dto) {

		List<Object[]> p = null;
		
		if (dto.getNivel().equals(305L)) {
			if (!Checks.esNulo(dto.getPanelTareas())){
				p = expedienteTareaDao.getTareasPendientes(dto, true, dto.getPanelTareas());
			}else {
			if (dto.getDetalle().equals(3L)) { // TOTAL TAREAS PENDIENTES VENCIDAS
				p = expedienteTareaDao.getTareasPendientes(dto, true, "TV");

			} else if (dto.getDetalle().equals(4L)) { // TAREAS PENDIENTES HOY
				p = expedienteTareaDao.getTareasPendientes(dto, true, "PH");

			} else if (dto.getDetalle().equals(5L)) { // TAREAS PENDIENTES SEMANA
				p = expedienteTareaDao.getTareasPendientes(dto, true, "PS");

			} else if (dto.getDetalle().equals(6L)) { // TAREAS PENDIENTES MES
				p = expedienteTareaDao.getTareasPendientes(dto, true, "PM");

			} else if (dto.getDetalle().equals(7L)) { // TAREAS PENDIENTES +1mes
				p = expedienteTareaDao.getTareasPendientes(dto, true, "PMM");

			} else if (dto.getDetalle().equals(8L)) { // TAREAS PENDIENTES +1Anyo
				p = expedienteTareaDao.getTareasPendientes(dto, true, "PA");
				
			} else if (dto.getDetalle().equals(9L)) { // TAREAS FINALIZADAS AYER
				p = expedienteTareaDao.getTareasPendientes(dto, true, "FH");
				
			} else if (dto.getDetalle().equals(10L)) { // TAREAS FINALIZADAS SEMANA
				p = expedienteTareaDao.getTareasPendientes(dto, true, "FS");
				
			} else if (dto.getDetalle().equals(11L)) { // TAREAS FINALIZADAS MES
				p = expedienteTareaDao.getTareasPendientes(dto, true, "FM");
				
			} else if (dto.getDetalle().equals(12L)) { // TAREAS FINALIZADAS ANYO
				p = expedienteTareaDao.getTareasPendientes(dto, true, "FA");
				
			} else if (dto.getDetalle().equals(13L)) { // TAREAS FINALIZADAS
				p = expedienteTareaDao.getTareasPendientes(dto, true, "TF");
				
			}
			}
		} else {
			if (!Checks.esNulo(dto.getPanelTareas())){
				p = expedienteTareaDao.getTareasPendientes(dto, false, dto.getPanelTareas());
			}else{	
			if (dto.getDetalle().equals(3L)) { // TOTAL TAREAS PENDIENTES VENCIDAS
				p = expedienteTareaDao.getTareasPendientes(dto, false, "TV");

			} else if (dto.getDetalle().equals(4L)) { // TAREAS PENDIENTES HOY
				p = expedienteTareaDao.getTareasPendientes(dto, false, "PH");

			} else if (dto.getDetalle().equals(5L)) { // TAREAS PENDEINTES SEMANA
				p = expedienteTareaDao.getTareasPendientes(dto, false, "PS");

			} else if (dto.getDetalle().equals(6L)) { // TAREAS PENDIENTES MES
				p = expedienteTareaDao.getTareasPendientes(dto, false, "PM");

			} else if (dto.getDetalle().equals(7L)) { // TAREAS PENDIENTES +1mes
				p = expedienteTareaDao.getTareasPendientes(dto, false, "PMM");

			} else if (dto.getDetalle().equals(8L)) { // TAREAS PENDIENTES +1Anyo
				p = expedienteTareaDao.getTareasPendientes(dto, false, "PA");
			
			} else if (dto.getDetalle().equals(9L)) { // TAREAS FINALIZADAS AYER
				p = expedienteTareaDao.getTareasPendientes(dto, false, "FH");
				
			} else if (dto.getDetalle().equals(10L)) { // TAREAS FINALIZADAS SEMANA
				p = expedienteTareaDao.getTareasPendientes(dto, false, "FS");
				
			} else if (dto.getDetalle().equals(11L)) { // TAREAS FINALIZADAS MES
				p = expedienteTareaDao.getTareasPendientes(dto, false, "FM");
				
			} else if (dto.getDetalle().equals(12L)) { // TAREAS FINALIZADAS ANYO
				p = expedienteTareaDao.getTareasPendientes(dto, false, "FA");
				
			} else if (dto.getDetalle().equals(13L)) { // TAREAS FINALIZADAS
				p = expedienteTareaDao.getTareasPendientes(dto, false, "TF");
			}
		}
		}
		return p;
	}

	@Override
	@BusinessOperation(PANEL_CONTROL_LETRADOS_GET_NIVELES)
	public List<PCNivel> getDDNiveles() {

		List<PCNivel> lista = genericDao.getList(PCNivel.class);
		return lista;
	}
	
	@Override
	@BusinessOperation(INS_MGR_LISTAPROCEDIMIENTOS)
	public List<TipoProcedimiento> listaProcedimientos() {	
	//public List<TipoProcedimiento> listaProcedimientos(String codigo) {
		//Filter filtroActuacion = genericDao.createFilter(FilterType.EQUALS, "tipoActuacion.codigo" , codigo);
		//List<TipoProcedimiento> lista = genericDao.getList(TipoProcedimiento.class, filtroActuacion);
		List<TipoProcedimiento> lista = genericDao.getList(TipoProcedimiento.class);
		return lista;
	}
	
	@Override
	@BusinessOperation(INS_MGR_LISTATIPOSACTUACION)
	public List<DDTipoActuacion> listaTiposActuacion() {
		List<DDTipoActuacion> lista = genericDao.getList(DDTipoActuacion.class);
		return lista;
	}
	
	@Override
	@BusinessOperation(PANEL_CONTROL_LETRADOS_LISTARANGOIMPORTES)
	public List<DDRangoImportePanelControl> listaRangoImportes() {
		List<DDRangoImportePanelControl> lista = genericDao.getList(DDRangoImportePanelControl.class);
		return lista;
	}

	/**
	 * 
	 * @param id del procedimiento
	 * @return lista de todas las tareas que pertenecen a ese procedimiento
	 */
	@Override
	@BusinessOperation(PTE_MGR_BUSCATAREAS)
	public List<TareaProcedimiento> buscaTareas (String codigo){
		Filter filtroProcedimiento = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento.codigo", codigo);
		List<TareaProcedimiento> listaTareas = genericDao.getList(TareaProcedimiento.class,filtroProcedimiento);
		Filter filtroProcedimientoGenerico = genericDao.createFilter(FilterType.EQUALS, "codigo", "P70_Generica");
		List<TareaProcedimiento> listaTareasGerecias = genericDao.getList(TareaProcedimiento.class,filtroProcedimientoGenerico);	
		listaTareas.addAll(listaTareasGerecias);
		return listaTareas;
	}

	@Override
	@BusinessOperation(PANEL_CONTROL_LETRADOS_GET_CAMPANYAS)
	public List<DtoCampanya> getDDCampanyas() {
		List<String> listaCampanyas = expedienteTareaDao.getCampanyas();

		List<DtoCampanya> lista = new ArrayList<DtoCampanya>();

        DtoCampanya dto;
        for (String c : listaCampanyas) {
            dto = new DtoCampanya();
            dto.setCampanya(c);
            
            lista.add(dto);
        }
		return lista;
	}

	@Override
	@BusinessOperation(PANEL_CONTROL_LETRADOS_GET_LETRADOGESTOR)
	public List<DtoLetrado> getDDLetradoGestor() {
		List<String> listaLetrados = expedienteTareaDao.getLetradoGestor();
		
		List<DtoLetrado> lista = new ArrayList<DtoLetrado>();

		DtoLetrado dto;
        for (String l : listaLetrados) {
            dto = new DtoLetrado();
            dto.setLetrado(l);
            
            lista.add(dto);
        }
        
		return lista;
	}

	@Override
	@BusinessOperation(EXPEDIENTES_EXCEL)
	public List<Map<String, Object>> getAsuntosListadoExcel(DtoDetallePanelControlLetrados dto) {
		
		List<Map<String, Object>> lista = new ArrayList<Map<String, Object>>();
		
		//Si se rellena el combo de importes, calculamos el valor min y max.
		if (StringUtils.hasText(dto.getRangoImporte())){
			Filter filtroRangoImportes = genericDao.createFilter(FilterType.EQUALS, "codigo",dto.getRangoImporte());
			DDRangoImportePanelControl rangoImporte = genericDao.get(DDRangoImportePanelControl.class, filtroRangoImportes);
			dto.setMinImporteFiltro(rangoImporte.getValorInicial().doubleValue());
			dto.setMaxImporteFiltro(rangoImporte.getValorFinal().doubleValue());
		}

		List<PCColumnaTareaExp> colunmas = columnaTareaExpDao.getColumns(dto.getTipo());
		
		List<Object[]> datos = expedienteTareaDao.getExpedientes(dto);

		if (!Checks.estaVacio(datos)) {
			for (Object[] o : datos) {
				lista.add(createMapa(colunmas, o));
			}
		}
		return lista;

	}
	
	@Override
	@BusinessOperation(TAREAS_EXCEL)
	public List<Map<String, Object>> getTareasListadoExcel(DtoDetallePanelControlLetrados dto) {
		 
		List<Map<String, Object>> lista = new ArrayList<Map<String, Object>>();
		
		//Si se rellena el combo de importes, calculamos el valor min y max.
		if (StringUtils.hasText(dto.getRangoImporte())){
			Filter filtroRangoImportes = genericDao.createFilter(FilterType.EQUALS, "codigo",dto.getRangoImporte());
			DDRangoImportePanelControl rangoImporte = genericDao.get(DDRangoImportePanelControl.class, filtroRangoImportes);
			dto.setMinImporteFiltro(rangoImporte.getValorInicial().doubleValue());
			dto.setMaxImporteFiltro(rangoImporte.getValorFinal().doubleValue());
		}
		
		List<PCColumnaTareaExp> colunmas = columnaTareaExpDao.getColumns(dto.getTipo());
		
		List<Object[]> datos = getTareasPendientesPanelControl(dto);

		if (!Checks.estaVacio(datos)) {
			for (Object[] o : datos) {
				lista.add(createMapa(colunmas, o));
			}
		}
	
		return lista;

	}
	
	@Override
	@BusinessOperation(NUMERO_COLUMNAS_EXCEL)
	public int getNumeroColumnas(String tipo) {
		
		return columnaTareaExpDao.getColumns(tipo).size();

	}
	
	@Override
	@BusinessOperation(TITULO_COLUMNAS_EXCEL)
	public List<String> getTituloColumnas(String tipo) {
		
		List<PCColumnaTareaExp> colunmas= columnaTareaExpDao.getColumns(tipo);
		List<String> lista = new ArrayList<String>();
		
		for (PCColumnaTareaExp col : colunmas) {
			lista.add(col.getHeader());
		}
	
		return lista;

	}


	@Override
	@BusinessOperation(PANEL_CONTROL_LETRADOS_GET_CARTERAS)
	public List<DtoCartera> getCarteras() {
		List<String> listaCarteras = expedienteTareaDao.getCarteras();

		List<DtoCartera> lista = new ArrayList<DtoCartera>();

        DtoCartera dto;
        for (String c : listaCarteras) {
            dto = new DtoCartera();
            dto.setCartera(c);
            
            lista.add(dto);
        }
		return lista;
	}


	@Override
	@BusinessOperation(PANEL_CONTROL_LETRADOS_GET_LOTES)
	public List<DtoLote> getLotesPorCartera(String cartera) {
		List<String> listaLotes = expedienteTareaDao.getLotes(cartera);

		List<DtoLote> lista = new ArrayList<DtoLote>();

        DtoLote dto;
        for (String l : listaLotes) {
            dto = new DtoLote();
            dto.setLote(l);
            
            lista.add(dto);
        }
		return lista;
	}


	@Override
	@BusinessOperation(PANEL_CONTROL_LETRADOS_PLAZAS_BYDESC)
	public Page buscarPorDescripcion(PCDtoQuery dto) {
		return tipoPlazaDao.buscarPorDescripcion(dto);
	}


	@Override
	@BusinessOperation(PANEL_CONTROL_LETRADOS_PAGINA_PLAZA)
	public Integer findPaginaPlazaByCod(String codigo) {
		int pagina = 0;
		int i = 0;
		for (TipoPlaza p : tipoPlazaDao.getListOrderedByDescripcion()){
			if (p.getCodigo().compareTo(codigo)==0) {
				pagina = i;
				break;				
			}
			i += 1;
		}	
		return pagina;
	}


	@Override
	@BusinessOperation(PANEL_CONTROL_LETRADOS_LISTAJUZGADOSPLAZA)
	public List<TipoJuzgado> buscaJuzgadosPlaza(String codigo) {
		Filter filtroPlaza = genericDao.createFilter(FilterType.EQUALS,
				"plaza.codigo", codigo);
		List<TipoJuzgado> juzgados = genericDao.getList(TipoJuzgado.class,
				filtroPlaza);
		return juzgados;
	}


	@Override
	@BusinessOperation(PANEL_CONTROL_LETRADOS_PROCEDIMIENTOSIMPLICADOS)
	public List<TipoProcedimiento> getProcedimientosImplicados() {
		List<TipoProcedimiento> procedimientosImplicados= new ArrayList<TipoProcedimiento>();
		List<String> listaCodigosProcedimiento = expedienteTareaDao.getCodigosTipoProcedimiento();
		List<TipoProcedimiento> listaProcedimientos = genericDao.getList(TipoProcedimiento.class);
		for (TipoProcedimiento tpo : listaProcedimientos){
			if (listaCodigosProcedimiento.contains(tpo.getCodigo())){
				procedimientosImplicados.add(tpo);
			}
		}
		return procedimientosImplicados;
	}


	@Override
	@BusinessOperation(PANEL_CONTROL_LETRADOS_GETLIST_LOTES)
	public List<DtoLote> getListLotes() {
		List<String> listaLotes = expedienteTareaDao.getListaLotes();

		List<DtoLote> lista = new ArrayList<DtoLote>();

        DtoLote dto;
        for (String l : listaLotes) {
            dto = new DtoLote();
            dto.setLote(l);
            
            lista.add(dto);
        }
		return lista;
	}

	

	
}
