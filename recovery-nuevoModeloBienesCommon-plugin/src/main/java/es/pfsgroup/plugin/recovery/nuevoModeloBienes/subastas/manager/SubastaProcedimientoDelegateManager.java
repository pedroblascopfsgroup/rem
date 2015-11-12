package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.manager;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.core.api.registro.HistoricoProcedimientoApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.BienLoteDto;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.InformeValidacionCDDDto;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dao.SubastaDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteBien;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContext;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.cierreDeuda.InformeValidacionCDDBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdicionalBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;

/**
 *
 */
@Service("subastaProcedimientoDelegateManager")
public class SubastaProcedimientoDelegateManager implements SubastaProcedimientoDelegateApi {

	@Autowired
	private GenericABMDao genericDao;	

	@Autowired
	private Executor executor;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private NMBProjectContext nmbProjectContext;
	
	
	/**
	 * Método que devuelve si el bien tiene el tipo subasta informado
	 */
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_IS_BIEN_WITH_TIPO_SUBASTA)
	public Boolean isTipoSubasta(Long bienId){
		
		NMBBien bien = (NMBBien) genericDao.get(NMBBien.class, genericDao.createFilter(FilterType.EQUALS, "id", bienId));
		if(bien.getTipoSubasta() != null && bien.getTipoSubasta() > 0){
			return true;
		}
		return false;
	}
	

	/**
	 * Método que devuelve true si al menos uno de los bienes asociados a la
	 * subasta se encuentra en obras
	 */
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_COMPROBAR_OBRA_EN_CURSO)
	public boolean comprobarObraEnCurso(Long prcId) {
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		if (!Checks.esNulo(sub)) {

			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {
					if (!Checks.estaVacio(ls.getBienes())) {
						for (Bien b : ls.getBienes()) {
							if (b instanceof NMBBien) {
								NMBBien nmbBien = (NMBBien) b;
								if (!nmbBien.getObraEnCurso()) {
									return false;
								}
							}
						}
					} else
						return false;
				}
			} else
				return false;
		}
		return true;
	}
	
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_GENERAR_INFORME_VALIDACION_CDD)
	public InformeValidacionCDDDto generarInformeValidacionCDD( Long idSubasta, String idsBien) {
		InformeValidacionCDDDto informe = new InformeValidacionCDDDto();
		List<BienLoteDto> listBienLote = new ArrayList<BienLoteDto>(); 
		if(!Checks.esNulo(idsBien)) {
			String[] arrLoteBien = idsBien.split(",");			
						
			for (String loteBien : arrLoteBien) {
				BienLoteDto dto;
				
				if(loteBien.contains(";")) {
					String bien = loteBien.substring(0,loteBien.indexOf(";")); 
					String lote = loteBien.substring(loteBien.indexOf(";")+1); 
					dto = new BienLoteDto(Long.valueOf(bien), "", Long.valueOf(lote));
					listBienLote.add(dto);					
				} else {					
					String bien = loteBien;
					dto = new BienLoteDto(Long.valueOf(bien), "", null);
				}
				listBienLote.add(dto);

			}
			informe.setBienesLote(listBienLote);
		}

		informe.setIdSubasta(idSubasta);
		InformeValidacionCDDBean informeBean = new InformeValidacionCDDBean();
		informeBean.setProxyFactory(proxyFactory);
		informeBean.setNmbProjectContext(nmbProjectContext);
		informeBean.create(informe);
		return informeBean.getInformeDTO();
	}

	@Override
	@BusinessOperation(overrides = BO_SUBASTA_COMPROBAR_BIEN_INFORMADO)
	public boolean comprobarBienInformado(Long prcId) {

		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		if (!Checks.esNulo(sub)) {
			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {
					if (!Checks.estaVacio(ls.getBienes())) {
						for (Bien b : ls.getBienes()) {
							if (b instanceof NMBBien) {
								NMBBien bien = (NMBBien) b;
								// primera comprobación: tiene informado el
								// campo vivienda habitual. Si no pasa esta
								// comprobación, ya ni seguimos
								
								if (Checks.esNulo(bien.getViviendaHabitual())) {
									return false;
								} else{
									//List<NMBBienCargas> listaCargas = bien.getBienCargas();
									
									//segunda condición
									//debe estar la fecha revision rellenada									
									NMBAdicionalBien adicionalBien = ((NMBBien) bien).getAdicional();
									if (Checks.esNulo(adicionalBien.getFechaRevision())) {
										return false;
									} 									
								}
							}
						}								
					}
				}
			}
		}

		return true;
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_TIENE_ALGUN_BIEN_CON_FICHA_SUBASTA)
	public boolean tieneAlgunBienConFichaSubasta2(Long prcId) {
		
		List<Bien> bienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		if(!Checks.estaVacio(bienes)){
			for(Bien b: bienes){
				if(b instanceof NMBBien){
					NMBBien bien = (NMBBien) b;
					if(!Checks.estaVacio(bien.getInstruccionesSubasta())){
						return true;
					}
				}
			}
		} else {
			//Todas las personas son jurídicas
			return true;
		}
		return false;
	}
	
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_IMPORTE_ENTIDAD_ADJUDICACION_BIENES)
	public boolean comprobarImporteEntidadAdjudicacionBienes(Long prcId) {
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		if (!Checks.esNulo(sub)) {
			
			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {
					if (!Checks.estaVacio(ls.getBienes())) {
						for (Bien b : ls.getBienes()) {
							if(b instanceof NMBBien){					
								if (Checks.esNulo(((NMBBien) b).getAdjudicacion()) || Checks.esNulo(((NMBBien) b).getAdjudicacion().getEntidadAdjudicataria()) || Checks.esNulo((((NMBBien) b)).getAdjudicacion().getImporteAdjudicacion())) {
									return false;
								}
							}
						}						
					}
				}
			}
		}
		return true;
	}
	
	/**
	 * 
	 */
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_ADJUDICACION)
	public boolean comprobarAdjudicacionBienesCelebracionSubasta(Long prcId) {
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		if (!Checks.esNulo(sub)) {
			
			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {
					if (!Checks.estaVacio(ls.getBienes())) {
						for (Bien b : ls.getBienes()) {
							if(b instanceof NMBBien){					
								if (Checks.esNulo(((NMBBien) b).getAdjudicacion())){
									return false;
								} else if(Checks.esNulo(((NMBBien) b).getAdjudicacion().getEntidadAdjudicataria())){
										return false;
								} else if(Checks.esNulo((((NMBBien) b)).getAdjudicacion().getImporteAdjudicacion())){
											return false;
								} else if(!Checks.esNulo(((NMBBien) b).getAdjudicacion().getCesionRemate()) && ((NMBBien) b).getAdjudicacion().getCesionRemate()){
									if(!((NMBBien) b).getAdjudicacion().getEntidadAdjudicataria().getCodigo().equals(DDEntidadAdjudicataria.ENTIDAD)){
										return false;
									} else if(Checks.esNulo(((NMBBien) b).getAdjudicacion().getImporteCesionRemate())){
										return false;
									}							
								}
							}
						}						
					}
				}
			}
		}
		return true;
	}
	
	/**
	 * 
	 */
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_ADJUDICACION_DOC)
	public boolean comprobarAdjudicacionDocBienesCelebracionSubasta(Long prcId) {
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		if (!Checks.esNulo(sub)) {
			
			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {
					if (!Checks.estaVacio(ls.getBienes())) {
						for (Bien b : ls.getBienes()) {
							if(b instanceof NMBBien){					
								if (Checks.esNulo(((NMBBien) b).getAdjudicacion())){
									return false;
								} else if(Checks.esNulo(((NMBBien) b).getAdjudicacion().getEntidadAdjudicataria())){
									return false;
								} else if(Checks.esNulo((((NMBBien) b)).getAdjudicacion().getImporteAdjudicacion())){
									return false;
								} else if(((NMBBien) b).getAdjudicacion().getEntidadAdjudicataria().getCodigo().compareTo(DDEntidadAdjudicataria.ENTIDAD) == 0 && Checks.esNulo(((NMBBien) b).getAdjudicacion().getTipoDocAdjudicacion())){
									return false;
								}else if(!Checks.esNulo(((NMBBien) b).getAdjudicacion().getCesionRemate()) && ((NMBBien) b).getAdjudicacion().getCesionRemate()){
									if(!((NMBBien) b).getAdjudicacion().getEntidadAdjudicataria().getCodigo().equals(DDEntidadAdjudicataria.ENTIDAD)){
										return false;
									} else if(Checks.esNulo(((NMBBien) b).getAdjudicacion().getImporteCesionRemate())){
										return false;
									}							
								}
							}
						}						
					}
				}
			}
		}
		return true;
	}
	
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_DECIDIR_REGISTRAR_ACTA_SUBASTA)
	public String decidirRegistrarActaSubasta(Long prcId) {

		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		boolean terceros = false;
		boolean entidad = false;

		if (!Checks.esNulo(sub)) {
			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {
					if (!Checks.estaVacio(ls.getBienes())) {
						for (Bien b : ls.getBienes()) {
							if (b instanceof NMBBien) {
								NMBAdjudicacionBien adj = ((NMBBien) b).getAdjudicacion();
								if (!Checks.esNulo(adj) && !Checks.esNulo(adj.getEntidadAdjudicataria())) {
									if (DDEntidadAdjudicataria.TERCEROS.equals(adj.getEntidadAdjudicataria().getCodigo())) {
										terceros = true;
									} else {
										entidad = true;
									}
								}
							}
						}
					}
				}
			}
		}

		if (entidad && terceros)
			return "mixto";
		if (entidad)
			return "entidad";
		if (terceros)
			return "terceros";
		
		return null;
	}
	
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_OBTENER_INSTRUCCIONES_CESION_REMATE)
	public String obtenerInstruccionesCesionRemate(Long prcId) {

		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId);
		Procedimiento padre = prc.getProcedimientoPadre();
		
		HistoricoProcedimiento tareaPrepararCesionRemate = null;
		List<TareaExternaValor> listadoValores = new ArrayList<TareaExternaValor>();
		
		if(SubastaDao.CODIGO_TIPO_SUBASTA_BANKIA.compareTo(padre.getTipoProcedimiento().getCodigo())==0 || SubastaDao.CODIGO_TIPO_SUBASTA_SAREB.compareTo(padre.getTipoProcedimiento().getCodigo())==0){
			// Proceso para obtener estos dos últimos valores: honorarios y derechos suplidos
			// A partir del procedimiento obtendremos sus tareas de su histórico de tareas			
			List<HistoricoProcedimiento> listadoTareasProc = proxyFactory.proxy(HistoricoProcedimientoApi.class).getListByProcedimiento(padre.getId());
			if (!Checks.estaVacio(listadoTareasProc)) {
				for (HistoricoProcedimiento hp : listadoTareasProc) {
					// Filtramos por el nombre de la tarea donde están los campos
					// que necesitamos y nos quedamos con el último
					if ("Preparar cesión de remate".compareTo(hp.getNombreTarea()) == 0) {
						tareaPrepararCesionRemate = hp;
					}
				}
			}
		}

		// Si hemos encontrado una tarea del tipo especificado
		if (tareaPrepararCesionRemate != null) {
			TareaNotificacion tareaSS = proxyFactory.proxy(TareaNotificacionApi.class).get(tareaPrepararCesionRemate.getIdEntidad());
			
			// Obtenemos la lista de valores de esa tarea
			listadoValores = tareaSS.getTareaExterna().getValores();
			for (TareaExternaValor val : listadoValores)
				if ("instrucciones".compareTo(val.getNombre()) == 0)
					return val.getValor();
		}
		
		return null;
	}
	
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_COMPROBAR_TIPO_SUBASTA_INFORMADO)
	public boolean comprobarTipoSubastaInformado(Long prcId) {
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		if (!Checks.esNulo(sub)) {
			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {
					if (!Checks.estaVacio(ls.getBienes())) {
						for (Bien b : ls.getBienes()) {
							if (b instanceof NMBBien) {
								NMBBien bien = (NMBBien) b;
								if (!isTipoSubasta(b.getId())) {
									return false;
								}
							}
						}
					}					
				}
			}
		}
		
		return true;
	}

	/**
	 * HAYA
	 * Metodo que devuelve true si al menos uno de los bienes asociados a la
	 * subasta tiene marcado el check Due Dilligence
	 */
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_COMPROBAR_DUE_DILLIGENCE)
	public boolean comprobarDueDilligence(Long prcId) {
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		boolean marcadoDue = false;
		if (!Checks.esNulo(sub)) {
			
			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {
					if (!Checks.estaVacio(ls.getBienes())) {
						for (Bien b : ls.getBienes()) {
							if (b instanceof NMBBien) {
								NMBBien nmbBien = (NMBBien) b;
								if (!Checks.esNulo(nmbBien.getDueDilligence()) && nmbBien.getDueDilligence()) {
									marcadoDue = true;
								}
							}
						}
					}
				}
			} 
		}
		return marcadoDue;
	}
	
	/**
	 * HAYA
	 * Metodo que devuelve true si al menos uno de los bienes asociados a la
	 * subasta tiene marcado el check Due Dilligence
	 */
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_COMPROBAR_FECHA_RECEPCION_DUE_DILLIGENCE)
	public boolean comprobarFechaRecepcionDue(Long prcId) {
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		boolean recepcionDue = true;
		if (!Checks.esNulo(sub)) {
			
			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {
					if (!Checks.estaVacio(ls.getBienes())) {
						for (Bien b : ls.getBienes()) {
							if (b instanceof NMBBien) {
								NMBBien nmbBien = (NMBBien) b;
								if (!Checks.esNulo(nmbBien.getDueDilligence()) && nmbBien.getDueDilligence()) {
									if (Checks.esNulo(nmbBien.getFechaDueD())) {
										recepcionDue = false;
									}
								}
							}
						}
					}else{
						recepcionDue = false;
					}
				}
			}else{
				recepcionDue = false;
			}
		}else{
			recepcionDue = false;
		}
		return recepcionDue;
	}
	

	/**
	 * BANKIA
	 * Metodo que devuelve null en caso de todo ir bien, en caso contrario devuelve el mensaje de error
	 * Validaciones PRE
	 */
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_PRE)
	public String validacionesCelebracionSubastaPRE(Long prcId) {
		return null;
	}

	
	/**
	 * BANKIA
	 * Metodo que devuelve null en caso de todo ir bien, en caso contrario devuelve el mensaje de error
	 * Validaciones POST
	 */
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_POST)
	public String validacionesCelebracionSubastaPOST(Long prcId) {
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		
		if (!Checks.esNulo(sub)) {
			
			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {
					if (!Checks.estaVacio(ls.getBienes())) {
						for (Bien b : ls.getBienes()) {
							if (b instanceof NMBBien) {
								if(!Checks.esNulo(((NMBBien) b).getAdjudicacion())){
									if(Checks.esNulo(((NMBBien) b).getAdjudicacion().getEntidadAdjudicataria())){
										return "Debe completar la entidad adjudicataria";
									}
									if(Checks.esNulo(((NMBBien) b).getAdjudicacion().getImporteAdjudicacion())){
										return "Debe completar el importe de adjudicaci&oacute;n";
									}
									else if(((NMBBien) b).getAdjudicacion().getImporteAdjudicacion().equals(0)){
										return "El importe de adjudicaci&oacute;n debe ser mayor que cero";
									}
									if(DDEntidadAdjudicataria.ENTIDAD.equals((((NMBBien) b).getAdjudicacion().getEntidadAdjudicataria().getCodigo()))){
										if(Checks.estaVacio(((NMBBien) b).getContratos())){
											return "Todos los bienes afectos deben tener al menos un contrato relacionado";
										}										
									}	
								}
								else{
									// En caso de que no exista adjudicación, significa que el
									// usuario no ha introducido nada en la pestaña de
									// adjudicaciones. Es por ello que le hacemos saltar la primera
									// de las condiciones
									return "Debe completar la entidad adjudicataria";
								}
							}
						}
					}
				}
			}
		}

		return null;
	}
	
	/**
	 * BANKIA
	 * Metodo que devuelve null en caso de todo ir bien, en caso contrario devuelve el mensaje de error
	 * Validaciones PRE
	 */
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_VALIDACIONES_CONFIRMAR_TESTIMONIO_PRE)
	public String validacionesConfirmarTestimonioPRE(Long prcId) {
		
		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId);	
		List<ProcedimientoBien> listadoBienes = prc.getBienes();				
		
		for(ProcedimientoBien pb: listadoBienes){
			NMBBien b = genericDao.get(NMBBien.class, genericDao.createFilter(FilterType.EQUALS, "id", pb.getBien().getId()));
			if(!Checks.estaVacio( b.getValoraciones())){
				for(NMBValoracionesBien v: b.getValoraciones()){
					if(Checks.esNulo(v.getFechaValorTasacion())){
						return "<div align=\"justify\" style=\"font-size: 8pt; font-family: Arial; margin-bottom: 10px;\">Debe completar la fecha valor tasaci&oacute;n</div>";
					}
					if(Checks.esNulo(v.getImporteValorTasacion())){
						return "<div align=\"justify\" style=\"font-size: 8pt; font-family: Arial; margin-bottom: 10px;\">Debe completar el importe de tasaci&oacute;n</div>";
					}else if (v.getImporteValorTasacion() == 0){
						return "<div align=\"justify\" style=\"font-size: 8pt; font-family: Arial; margin-bottom: 10px;\">El importe de tasaci&oacute;n debe ser mayor que cero</div>";
					}
				}
			
				if(!b.tieneNumeroActivo()){
					return "<div align=\"justify\" style=\"font-size: 8pt; font-family: Arial; margin-bottom: 10px;\">Debe solicitar el n&uacute;mero de activo previamente</div>";
				}				
			}
			else{
				// En caso de que no existe valoración, significa que el
				// usuario no ha introducido nada en la pestaña de
				// valoraciones. Es por ello que le hacemos saltar la primera
				// de las condiciones
				return "<div align=\"justify\" style=\"font-size: 8pt; font-family: Arial; margin-bottom: 10px;\">Debe completar la fecha valor tasaci&oacute;n</div>";
			}
		}
		
		return null;
	}
	
	/**
	 * BANKIA
	 * Metodo que devuelve null en caso de todo ir bien, en caso contrario devuelve el mensaje de error
	 * Validaciones POST
	 */
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_VALIDACIONES_CONFIRMAR_TESTIMONIO_POST)
	public String validacionesConfirmarTestimonioPOST(Long prcId) {
		
		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId);
		List<ProcedimientoBien> listadoBienes = prc.getBienes();
		
		for(ProcedimientoBien pb: listadoBienes){
			
			NMBBien b = genericDao.get(NMBBien.class, genericDao.createFilter(FilterType.EQUALS, "id", pb.getBien().getId()));
			
			if(!Checks.esNulo(b.getAdjudicacion())){
				if(Checks.esNulo(b.getAdjudicacion().getImporteAdjudicacion())){
					return "Debe completar el importe de adjudicaci&oacute;n";
				}
				else if(b.getAdjudicacion().getImporteAdjudicacion().equals(0)){
					return "El importe de adjudicaci&oacute;n debe ser mayor que cero";
				}
				if(Checks.esNulo(b.getAdjudicacion().getEntidadAdjudicataria())){
					return "Debe completar la entidad adjudicataria";
				}
			}
			else{
				// En caso de que no exista adjudicación, significa que el
				// usuario no ha introducido nada en la pestaña de
				// adjudicaciones. Es por ello que le hacemos saltar la primera
				// de las condiciones
				return "Debe completar el importe de adjudicaci&oacute;n";
			}
		}
		
		return null;
	}
	

	
	/**
	 * 
	 * @param prcId
	 * @return
	 */
	private List<Bien> getBienesSubastaByPrcId(Long prcId){
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		
		List<Bien> bienes = new ArrayList<Bien>();
		
		if (!Checks.esNulo(sub)) {

			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			
			if (!Checks.estaVacio(listadoLotes)) {
				for(int i=0; i<listadoLotes.size(); i++){		
					bienes.addAll(listadoLotes.get(i).getBienes());
				}
			}
		}
		
		return bienes;
	}
	
	/**
	 * BANKIA
	 * Metodo que devuelve null en caso de todo ir bien, en caso contrario devuelve el mensaje de error
	 * Validaciones POST
	 */
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_COMPROBAR_NUMERO_ACTIVO)
	public boolean comprobarNumeroActivo(Long prcId) {

		boolean respuesta = true;
		
		List<Bien> listadoBienes = getBienesSubastaByPrcId(prcId);
		
		for(Bien bien: listadoBienes) {			
			NMBBien nmbBien = (NMBBien) bien;			
			if (!nmbBien.tieneNumeroActivo()) {
				respuesta = false;
				
			}
		}

		return respuesta;
	}
	
	/**
	 * BANKIA
	 * Método que comprueba que, si el trámite de adjudicación viene de un tramite de subasta SAREB, todos bienes asociados al procedimiento tienen al menos un contrato activo
	 * Validaciones POST
	 */
	@Override
	@BusinessOperation(overrides = BO_SUBASTA_VALIDACIONES_CONTRATOS_CONFIRMAR_TESTIMONIO_POST)
	public boolean validacionesContratosConfirmarTestimonioPOST(Long idProcedimiento){
	
		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);	
		List<ProcedimientoBien> listadoBienes = prc.getBienes();
		Procedimiento pAux = prc.getProcedimientoPadre();
		
	
		//Comprobamos si el trámite de adjudicación proviene de uno de los trámites de subasta contemplados para la validación de contrato activo por cada bien FASE-1347
		boolean vieneDeSubastaContemplada = false;
		while (pAux!=null && vieneDeSubastaContemplada==false){
				
			// Si el procedimiento padre es de tipo subasta
			if(nmbProjectContext.getCodigosSubastas().contains(pAux.getTipoProcedimiento().getCodigo())){
				// Si el procedimiento padre es de uno de los tipos de tramite de subasta contemplados por la validación
				if(nmbProjectContext.getCodigosSubastaValidacion().contains(pAux.getTipoProcedimiento().getCodigo())){
					vieneDeSubastaContemplada = true;
				}
				else{
					pAux = null;
				}
			}
			else{
				pAux = pAux.getProcedimientoPadre();
			}
		}
				
		//Si el procedimiento viene de una de las subastas contempladas, se realiza la comprobación
		if(vieneDeSubastaContemplada){
					
					boolean bienSinContratoActivo = false;
					//Comprobamos que todos los bienes asociados al procedimiento, tienen al menos un contrato activo
					for(ProcedimientoBien pb: listadoBienes){
						NMBBien b = genericDao.get(NMBBien.class, genericDao.createFilter(FilterType.EQUALS, "id", pb.getBien().getId()));
						List<NMBContratoBien> listaContratos = b.getContratos();
						boolean tieneContratoActivo = false;
					
						for(NMBContratoBien c : listaContratos){
							
							//Si el contrato está activo
							if (c.getContrato().getEstadoContrato().getCodigo().equals(DDEstadoContrato.ESTADO_CONTRATO_ACTIVO)){				
								tieneContratoActivo = true;
							}								
						}
						
						//Si el bien no tiene ningún contrato activo
						if(tieneContratoActivo==false){
							bienSinContratoActivo = true;
							//Salimos del for al encontrar un bien sin contrato activo.
							break;
						}
					}
		
					if(bienSinContratoActivo==true){
						return false;
					}
					else{
						return true;
					}
		}
		return true;
	}


	@Override
	@BusinessOperation(overrides = BO_SUBASTA_GET_LOTE_BY_PRC_BIEN)
	public LoteBien getLoteByPrcBien(Long idProcedimiento, Long idBien) {
		LoteBien loteBien = genericDao.get(LoteBien.class, 
				genericDao.createFilter(FilterType.EQUALS, "bien.id", idBien),
				genericDao.createFilter(FilterType.EQUALS, "loteSubasta.subasta.procedimiento.id", idProcedimiento));
		return loteBien;

	}	

}
