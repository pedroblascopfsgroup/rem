package es.pfsgroup.plugin.recovery.nuevoModeloBienes.contratos;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBContratoBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBPersonasBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.contratos.dto.MEJDtoReportAcuerdo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.contratos.dto.NMBDtoIntervinientes;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.contratos.dto.NMBDtoProcedimientoOrigen;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.contratos.dto.NMBDtoSolvencias;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDEstadoBienContrato;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBPersonasBien;


@Component("plugin.nuevoModeloBienes.contratos.NMBContratoManager")
public class NMBContratoManager {
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@BusinessOperation("plugin.nuevoModeloBienes.contratos.NMBContratoManager.getSolvencias")
	public List<NMBDtoSolvencias> getSolvencias(Long idContrato) {
		
		Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
    	List<NMBDtoSolvencias> listaDtoSolvencias = new ArrayList<NMBDtoSolvencias>();
    	
		Contrato contrato = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET,idContrato);
		for (Persona p : contrato.getIntervinientes()){
			NMBDtoSolvencias dtoSolvencia = new NMBDtoSolvencias();
			List<NMBPersonasBienInfo> nmbPersonasBienInfo = new ArrayList<NMBPersonasBienInfo>();
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "persona.id", p.getId());
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "bien.auditoria.borrado", false);
			//nmbPersonasBienInfo.addAll(genericDao.getList(NMBPersonasBien.class, f1, f2));
			// recorrer lista para aplicar criterio de visibilidad para externos.
			for (NMBPersonasBienInfo pbi : genericDao.getList(NMBPersonasBien.class, f1, f2)){
				if (usuarioLogado.getUsuarioExterno()){
					if (pbi.getBien()!=null && pbi.getBien().getOrigen()!=null && "1".equals(pbi.getBien().getOrigen().getCodigo()) || (pbi.getBien()!=null && pbi.getBien().getMarcaExternos()!=null && pbi.getBien().getMarcaExternos()==1)) 
						nmbPersonasBienInfo.add(pbi);
				}else 
					nmbPersonasBienInfo.add(pbi);
			}
			if (nmbPersonasBienInfo!=null && nmbPersonasBienInfo.size()>0){
				dtoSolvencia.setNombreApellidos(p.getApellidoNombre());
				dtoSolvencia.setId(p.getId());
				dtoSolvencia.setSolvencias(nmbPersonasBienInfo);
				listaDtoSolvencias.add(dtoSolvencia);
			}
		}
		
		return listaDtoSolvencias;
	}
	
	
	@BusinessOperation("plugin.nuevoModeloBienes.contratos.NMBContratoManager.getBienes")
	public List<NMBContratoBien> getBienes(Long idContrato) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<NMBContratoBien> listNMBContratoBienTemp = new ArrayList<NMBContratoBien>();
		List<NMBContratoBien> listNMBContratoBien = new ArrayList<NMBContratoBien>();
		
		listNMBContratoBienTemp= genericDao.getList(NMBContratoBien.class, f1,f2);
		
		for(NMBContratoBien cb: listNMBContratoBienTemp){
			if(Checks.esNulo(cb.getEstado()) || cb.getEstado().getCodigo().equals(NMBDDEstadoBienContrato.COD_ESTADO_BIEN_ACTIVO)){
				listNMBContratoBien.add(cb);
				
			}
		}
		
		//Filter f3 = genericDao.createFilter(FilterType.EQUALS, "estado.codigo", NMBDDEstadoBienContrato.COD_ESTADO_BIEN_ACTIVO); // solo los que tienen la relaci�n con el bien activa
		//return genericDao.getList(NMBContratoBien.class, f1,f2,f3);
		return listNMBContratoBien;
    }
	
	@SuppressWarnings("unchecked")
	@BusinessOperation("plugin.nuevoModeloBienes.contratos.NMBContratoManager.createReportAcuerdo")
	public MEJDtoReportAcuerdo createReportAcuerdo (Long idContrato){
		
		MEJDtoReportAcuerdo response = new MEJDtoReportAcuerdo();
		
		TareaExterna te = new TareaExterna();
		boolean tareaEncontrada = false;  
		
		// cargar contrato y contratoPersonas 
		Contrato contrato = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET,idContrato);
		response.setContrato(contrato);
		//response.getContrato().setContratoPersona(contrato.getContratoPersona());
		
		// cargar personas por porcentaje sobre bienes ligados al contrato por ContratoBien
		//        cargar bienes relacionados con el contrato
		List<NMBContratoBienInfo> contratoBienes = new ArrayList<NMBContratoBienInfo>();
		contratoBienes.addAll(this.getBienes(idContrato));
		//        por cada bien encontrado agregar las personas relacionadas
		List<NMBPersonasBienInfo> personasBienes = new ArrayList<NMBPersonasBienInfo>();
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		for (NMBContratoBienInfo cb : contratoBienes){
			f1 = genericDao.createFilter(FilterType.EQUALS, "bien.id", cb.getBien().getId());
			personasBienes.addAll(genericDao.getList(NMBPersonasBien.class, f1, f2));
		}
		response.setPersonasBienContrato(personasBienes);	
		
		// Cargar actuaci�n actual y actuaciones previas
		List<Procedimiento> procedimientos = new ArrayList<Procedimiento>();
		if (contrato.getExpedienteContratoActivo() != null) {
			if (!Checks.estaVacio(contrato.getProcedimientos())){				
				// listado de todas las actuaciones asociadas al asunto activo.
				for (Asunto asu : contrato.getAsuntosActivos()) {
					procedimientos = asu.getProcedimientos();
					response.setActuacionesDerivadas(procedimientos);
				}
				response.setActuacionActual(procedimientos.get(procedimientos.size()-1));
				for (Procedimiento p : procedimientos){
					// si el procedimientos esta aceptado y tiene algun hijo me quedo con este procedimiento, si no con el �ltimo abierto
					if ((DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO.equals(p.getEstadoProcedimiento().getCodigo())) &&
						(p.getProcedimientoDerivado() != null || p.getProcedimientoDerivado().size() > 0)) 
						response.setActuacionActual(p);
				}
				// a partir de la actuaci�n actual seteamos los campos del dto que no incluye la actuaci�n
				// listado de tareas hist�ricas
				List<HistoricoProcedimiento> historicoProcedimiento = 
					(List<HistoricoProcedimiento>) executor.execute(ExternaBusinessOperation.BO_HIST_PRC_MGR_GET_BY_PROCEDIMIENTO,response.getActuacionActual().getId());
				for (HistoricoProcedimiento hp : historicoProcedimiento){
					f1 = genericDao.createFilter(FilterType.EQUALS, "tareaPadre.id", hp.getIdEntidad());
					te = genericDao.get(TareaExterna.class, f1);
					// recorreo los valores de la tarea en busca de la fecha registro de auto
					if (te!=null){
						for ( TareaExternaValor tev : te.getValores()){
							if (tev.getNombre().equals("fecha"))
								response.setActActFechaAuto(tev.getValor()); 
							if (tev.getNombre().equals("numProcedimiento")){
								tareaEncontrada = true;
								break;
							}
						}
						if (tareaEncontrada) break;
					}
				}
				Set<TareaNotificacion> hitosActuales = response.getActuacionActual().getTareas();
				response.setHitoActual("");
				for (TareaNotificacion tn : hitosActuales){
					if (response.getHitoActual().equals("")) 
						response.setHitoActual(response.getHitoActual() + " / ");
					response.setHitoActual(response.getHitoActual() + tn.getDescripcionTarea());					
				}
				Iterator<TareaNotificacion> it = response.getActuacionActual().getTareas().iterator();
				while (it.hasNext()){
					it.next().getTarea();
				}
			}
		}
		
		// Para localizar los procedimientos padre y mapear las propiedades en un dto
		List<Procedimiento> procedimientosOrigen= buscaProcedimientosOrigenDelContrato(contrato);
		
		List<NMBDtoProcedimientoOrigen> listaOrigen = mapeaListaOrigen (procedimientosOrigen);
		
		response.setProcedimientosOrigen(listaOrigen);
		
		// cargar bienes trabados, marcados.
		// recorrer todos los procedimientos y recoger los bienes marcados
		
		List <NMBBienInfo> bienesTrabados = new ArrayList<NMBBienInfo>();
		List <NMBPersonasBien> personasBien = new ArrayList<NMBPersonasBien>();
		NMBBien bienCandidato = new NMBBien();
		
		
		if (procedimientos!=null){
			for (Procedimiento p : procedimientos){
				for (Persona per : p.getPersonasAfectadas()) {
					// buscar bienes seg�n BIE_PER
					f1 = genericDao.createFilter(FilterType.EQUALS, "persona.id", per.getId());
					f2 = genericDao.createFilter(FilterType.EQUALS, "bien.auditoria.borrado", false);
					personasBien.addAll(genericDao.getList(NMBPersonasBien.class, f1, f2));
					for (NMBPersonasBien pb : personasBien){
						if (pb != null && pb.getBien() != null && pb.getBien().getEmbargoProcedimiento()!=null && pb.getBien().getEmbargoProcedimiento().getFechaSolicitud() != null){
							// bien marcado por tanto agregar a la lista de bienesinfo
							f1 = genericDao.createFilter(FilterType.EQUALS, "id", pb.getBien().getId());
							bienCandidato = genericDao.get(NMBBien.class, f1);
							if (!bienesTrabados.contains(bienCandidato)) 
								bienesTrabados.add(bienCandidato);
						}
					}
				}
			}
			response.setBienesTrabados(bienesTrabados);
		}
		
		List<NMBDtoIntervinientes> listaIntervinientesDemandados = new ArrayList<NMBDtoIntervinientes>();
		for (ContratoPersona cp : contrato.getContratoPersonaOrdenado()){
			NMBDtoIntervinientes dto = new NMBDtoIntervinientes();
			dto.setPersonaContrato(cp);
			dto.setDemandado(false);
			for (Procedimiento proc : procedimientos){
				if (proc.getPersonasAfectadas().contains(cp.getPersona())){
					dto.setDemandado(true);
				}
			}
			listaIntervinientesDemandados.add(dto);
		}
		response.setIntervinientesDemandados(listaIntervinientesDemandados);
		
		/* Buscar datos de subasta */
		if (procedimientos!=null){
			Float costasFloat = new Float(0);
			for (Procedimiento p : procedimientos){
				if (p.getTipoProcedimiento().getCodigo().equals("P11")){
					response.setSubastaPrincipal(p.getSaldoRecuperacion().floatValue());
					// recorrer las tareas
					List<HistoricoProcedimiento> historicoTareas = 
						(List<HistoricoProcedimiento>) executor.execute(ExternaBusinessOperation.BO_HIST_PRC_MGR_GET_BY_PROCEDIMIENTO,p.getId());
					for (HistoricoProcedimiento hp : historicoTareas){
						f1 = genericDao.createFilter(FilterType.EQUALS, "tareaPadre.id", hp.getIdEntidad());
						te = genericDao.get(TareaExterna.class, f1);
						// recorreo los valores de la tarea en busca de la fecha registro de auto
						if (te!=null){
							for ( TareaExternaValor tev : te.getValores()){
								if (tev.getNombre().equals("fechaSubasta"))	{
									DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
									try {
										Date fecha = df.parse(tev.getValor());   
										response.setSubastaFecha(fecha);
										//response.setSubastaFecha(DateFormat.toDate(tev.getValor().replace("-", "/")));
										
									} catch (ParseException e) {e.printStackTrace();}
								}
								if (tev.getTareaExterna().getTareaProcedimiento().getCodigo().equals("P11_SolicitudSubasta")){
									if (tev.getNombre().equals("costasLetrado") && tev.getValor()!=null){
										try {
											costasFloat =+ Float.valueOf(tev.getValor()).floatValue();
										} catch (NumberFormatException e){e.printStackTrace();};
									}
									if (tev.getNombre().equals("costasProcurador") && tev.getValor()!=null ){
										try {
											costasFloat =+ Float.valueOf(tev.getValor()).floatValue();
										} catch (NumberFormatException e){e.printStackTrace();};
									}
								}
								if (tev.getTareaExterna().getTareaProcedimiento().getCodigo().equals("P11_CelebracionSubasta") && 
									tev.getNombre().equals("observaciones")){
									response.setSubastaObservaciones(tev.getValor()); 
								}
							}
						}
					}
				}
			}
			response.setSubastaCosta(costasFloat);
			
		}
		
		return response;
	}

	private List<NMBContratoBien> getContratosBienActivos(Long idContrato) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter f3 = genericDao.createFilter(FilterType.EQUALS, "estado.codigo", NMBDDEstadoBienContrato.COD_ESTADO_BIEN_ACTIVO); // solo los que tienen la relaci�n con el bien activa
		return genericDao.getList(NMBContratoBien.class, f1,f2,f3);
		//        por cada bien encontrado agregar las personas relacionadas
	}
	private List<Procedimiento> buscaProcedimientosOrigenDelContrato(final Contrato contrato) {
		List<Procedimiento> procedimientosOrigen = new ArrayList<Procedimiento>();
		if (!Checks.esNulo(contrato.getExpedienteContratoActivo())){
			if (!Checks.esNulo(contrato.getProcedimientos()) && !Checks.estaVacio(contrato.getProcedimientos())){
				for(Procedimiento prc : contrato.getProcedimientos()){
					if (Checks.esNulo(prc.getProcedimientoPadre())){
						// si el procedimiento origen es contrato bloqueado 
						// y tiene alg�n hijo, el proc. origen pasa a ser el hijo
						if (prc.getTipoProcedimiento().getCodigo().equals("P22") ){
							// recorrer los procedimientos hijos y agregarlos como origen
							List<Procedimiento> derivados = dameFaseActualProcedimiento(prc);
							if (!Checks.estaVacio(derivados) && !Checks.esNulo(derivados)){
								for (Procedimiento p : derivados){
									procedimientosOrigen.add(p);
								}
							} else {
								// no tiene derivaciones y es origen por tanto lo agregamos a la lista
								procedimientosOrigen.add(prc);
							}
						} else {
							procedimientosOrigen.add(prc);
						}
					}
				}
			}
		}
		return procedimientosOrigen;
	}

	@SuppressWarnings("unchecked")
	private List<NMBDtoProcedimientoOrigen> mapeaListaOrigen(List<Procedimiento> procedimientosOrigen) {
		List<NMBDtoProcedimientoOrigen> listaOrigen = new ArrayList<NMBDtoProcedimientoOrigen>();
		if (!Checks.estaVacio(procedimientosOrigen) && !Checks.esNulo(procedimientosOrigen)){
			for (Procedimiento pOr : procedimientosOrigen){
				NMBDtoProcedimientoOrigen dto = new NMBDtoProcedimientoOrigen();
				dto.setProcedimientoOrigen(pOr.getTipoProcedimiento().getDescripcion());
				dto.setFechaEntrega(pOr.getFechaRecopilacion());
				List<Procedimiento> fasesActuales= new ArrayList<Procedimiento>();
				fasesActuales = buscaUltimasDerivaciones(pOr);

				if (Checks.esNulo(fasesActuales)|| Checks.estaVacio(fasesActuales)){
					dto.setNumeroAutos(pOr.getCodigoProcedimientoEnJuzgado());
					dto.setFaseActual("Procedimiento no derivado");
					if(!Checks.esNulo(pOr.getAsunto().getProcurador())){
						dto.setProcurador(pOr.getAsunto().getProcurador().getUsuario().getApellidoNombre());
					}
					if (!Checks.esNulo(pOr.getAsunto().getGestor())){
						dto.setLetrado(pOr.getAsunto().getGestor().getUsuario().getApellidoNombre());
					}
					if (!Checks.esNulo(pOr.getJuzgado())){
						dto.setPlaza(pOr.getJuzgado().getPlaza().getDescripcion());
						dto.setJuzgado(pOr.getJuzgado().getDescripcion());
						
					}
					List<TareaExterna> hitosActuales = (List<TareaExterna>) executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_POR_PROCEDIMIENTO, pOr.getId());;					
					if (!Checks.esNulo(hitosActuales) && !Checks.estaVacio(hitosActuales)){
						String stringTarea = "";
						for (TareaExterna te : hitosActuales){
							if (Checks.esNulo(te.getTareaPadre().getFechaFin())){
								stringTarea=stringTarea+te.getTareaPadre().getTarea()+"/  /";	
							}				
						}
						dto.setHitoActual(stringTarea);
					}
					if(!Checks.esNulo(pOr.getPersonasAfectadas()) && !Checks.estaVacio(pOr.getPersonasAfectadas())){
						String stringDemandados ="";
						for (Persona pers : pOr.getPersonasAfectadas()){
							stringDemandados=stringDemandados+pers.getApellidoNombre()+"/  /";	
						}
						dto.setDemandado(stringDemandados);
					}
					listaOrigen.add(dto);
				}else{
					dto.setNumeroAutos(fasesActuales.get(0).getCodigoProcedimientoEnJuzgado());
					dto.setCodigo(fasesActuales.get(0).getId());
					//dto.setFechaAuto(fasesActuales.get(0).getFechaRecopilacion());
					if(!Checks.esNulo(fasesActuales.get(0).getAsunto().getProcurador())){
						dto.setProcurador(fasesActuales.get(0).getAsunto().getProcurador().getUsuario().getApellidoNombre());
					}
					if (!Checks.esNulo(fasesActuales.get(0).getAsunto().getGestor())){
						dto.setLetrado(fasesActuales.get(0).getAsunto().getGestor().getUsuario().getApellidoNombre());
					}
					if (!Checks.esNulo(fasesActuales.get(0).getJuzgado())){
						dto.setPlaza(fasesActuales.get(0).getJuzgado().getPlaza().getDescripcion());
						dto.setJuzgado(fasesActuales.get(0).getJuzgado().getDescripcion());
						
					}
					dto.setFaseActual(fasesActuales.get(0).getTipoProcedimiento().getDescripcion());
					List<TareaExterna> hitosActuales = 	(List<TareaExterna>) executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_POR_PROCEDIMIENTO, fasesActuales.get(0).getId());				
					if (!Checks.esNulo(hitosActuales) && !Checks.estaVacio(hitosActuales)){
						String stringTarea = "";
						for (TareaExterna te : hitosActuales){
							if (Checks.esNulo(te.getTareaPadre().getFechaFin())){
								stringTarea=stringTarea+te.getTareaPadre().getTarea()+"/  /";	
							}					
						}
						dto.setHitoActual(stringTarea);
					}
					if (!Checks.esNulo(fasesActuales.get(0).getPersonasAfectadas()) && !Checks.estaVacio(fasesActuales.get(0).getPersonasAfectadas())){
						String stringDemandados ="";
						for (Persona pers : fasesActuales.get(0).getPersonasAfectadas()){
							stringDemandados=stringDemandados+pers.getApellidoNombre()+"/  /";	
						}
						dto.setDemandado(stringDemandados);
						}
					listaOrigen.add(dto);
					}
					if (fasesActuales.size()>1){
						for (int i=1; i<fasesActuales.size();i++){
							NMBDtoProcedimientoOrigen dtoMas = new NMBDtoProcedimientoOrigen();
							dtoMas.setFaseActual(fasesActuales.get(i).getTipoProcedimiento().getDescripcion());
							dtoMas.setNumeroAutos(fasesActuales.get(i).getCodigoProcedimientoEnJuzgado());
							dtoMas.setCodigo(fasesActuales.get(i).getId());
							//dtoMas.setFechaAuto(fasesActuales.get(i).getFechaRecopilacion());
							if(!Checks.esNulo(fasesActuales.get(i).getAsunto().getProcurador())){
								dtoMas.setProcurador(fasesActuales.get(i).getAsunto().getProcurador().getUsuario().getApellidoNombre());
							}
							if (!Checks.esNulo(fasesActuales.get(i).getAsunto().getGestor())){
								dtoMas.setLetrado(fasesActuales.get(i).getAsunto().getGestor().getUsuario().getApellidoNombre());
							}
							if (!Checks.esNulo(fasesActuales.get(i).getJuzgado())){
								dtoMas.setPlaza(fasesActuales.get(i).getJuzgado().getPlaza().getDescripcion());
								dtoMas.setJuzgado(fasesActuales.get(i).getJuzgado().getDescripcion());
								
							}
							dtoMas.setFaseActual(fasesActuales.get(i).getTipoProcedimiento().getDescripcion());
							List<TareaExterna> hitosActuales = (List<TareaExterna>) executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_POR_PROCEDIMIENTO, fasesActuales.get(i).getId());					
							if (!Checks.esNulo(hitosActuales) && !Checks.estaVacio(hitosActuales)){
								String stringTarea = "";
								for (TareaExterna te : hitosActuales){
									if (Checks.esNulo(te.getTareaPadre().getFechaFin())){
										stringTarea=stringTarea+te.getTareaPadre().getTarea()+"/  /";	
									}				
								}
								dtoMas.setHitoActual(stringTarea);
							}
							if(!Checks.esNulo(fasesActuales.get(i).getPersonasAfectadas()) && !Checks.estaVacio(fasesActuales.get(i).getPersonasAfectadas())){
								String stringDemandados ="";
								for (Persona pers : fasesActuales.get(i).getPersonasAfectadas()){
									stringDemandados=stringDemandados+pers.getApellidoNombre()+"/  /";	
								}
								dtoMas.setDemandado(stringDemandados);
							}
							listaOrigen.add(dtoMas);
						}
					}	
				}
			
		}
		
		return listaOrigen;
	}

	private List<Procedimiento> dameFaseActualProcedimiento(Procedimiento pOr) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "procedimientoPadre.id", pOr.getId());
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "estadoProcedimiento.codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO);
		List<Procedimiento> derivados = genericDao.getList(Procedimiento.class, f1,f2);
		return derivados;
	}
	
	private List<Procedimiento> buscaUltimasDerivaciones(Procedimiento procedimiento){
		List<Procedimiento> resultado = new ArrayList<Procedimiento>();
		List<Procedimiento> derivados = dameFaseActualProcedimiento(procedimiento);
		if (!Checks.estaVacio(derivados) && !Checks.esNulo(derivados)){
			for (Procedimiento p : derivados){
				List<Procedimiento> aux = dameFaseActualProcedimiento(p);
				if (Checks.estaVacio(aux) || Checks.esNulo(aux)) {
					resultado.add(p);
				}else {
					resultado.addAll(buscaUltimasDerivaciones(p));
				}
			}
		}
		return resultado;
	}

	
	
}
