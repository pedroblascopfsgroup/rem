package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.cierreDeuda;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.BienLoteDto;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.DatosLoteCDD;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.InfoBienesCDD;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.InformeValidacionCDDDto;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.ProcedimientoSubastaCDD;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoValidacionCDD;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContext;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContextImpl;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.BienApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.SubastaApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.manager.SubastaManager.ValorNodoTarea;
import es.pfsgroup.recovery.ext.impl.asunto.model.DDPropiedadAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

public class InformeValidacionCDDBean {

	private static final String VALOR_COSTAS_LETRADO = "costasLetrado";
	private static final String VALOR_COSTAS_PROCURADOR = "costasProcurador";
	private static final String VALOR_FECHA_TESTIMONIO = "fechaTestimonio";

	protected ApiProxyFactory proxyFactory;
	protected NMBProjectContext nmbProjectContext;
	
	private InformeValidacionCDDDto informeDTO;
	private String camposVacios="";

	public void create(InformeValidacionCDDDto informeDTO) {
		this.informeDTO = informeDTO;
		this.informeDTO.setSubasta((Subasta) proxyFactory.proxy(SubastaApi.class).getSubasta(this.informeDTO.getIdSubasta()));
		this.informeDTO.setProcedimientoSubastaCDD(rellenaProcedimientoSubastaCDD(this.informeDTO.getSubasta()));
		this.informeDTO.setDatosLoteCDD(rellenaDatosLoteCDD(this.informeDTO.getSubasta()));
		this.informeDTO.setMensajesValidacion(crearMensajeValidacion(this.informeDTO.getSubasta()));
		this.informeDTO.setValidacionOK(Checks.esNulo(this.informeDTO.getMensajesValidacion()));
	}

	private ProcedimientoSubastaCDD rellenaProcedimientoSubastaCDD(Subasta subasta) {
		StringBuilder sb = new StringBuilder();
		ProcedimientoSubastaCDD procedimientoSubastaCDD = new ProcedimientoSubastaCDD();

		if(Checks.esNulo(subasta.getProcedimiento().getTipoProcedimiento())) {
			procedimientoSubastaCDD.setTipoProcedimiento(null);
		}else{
			procedimientoSubastaCDD.setTipoProcedimiento(subasta.getProcedimiento().getTipoProcedimiento().getCodigo() + " - " + subasta.getProcedimiento().getTipoProcedimiento().getDescripcion());			
		}
		if (Checks.esNulo(procedimientoSubastaCDD.getTipoProcedimiento())) {
			sb.append("Tipo procedimiento; ");
		}

		procedimientoSubastaCDD.setLetrado(subasta.getAsunto().getGestor().getUsuario().getApellidoNombre());
		if (Checks.esNulo(procedimientoSubastaCDD.getLetrado())) {
			sb.append("Letrado; ");
		}

		if(Checks.esNulo(subasta.getProcedimiento().getJuzgado())) {
			procedimientoSubastaCDD.setJuzgado(null);
		}else{
			procedimientoSubastaCDD.setJuzgado(subasta.getProcedimiento().getJuzgado().getDescripcion());			
		}
		if (Checks.esNulo(procedimientoSubastaCDD.getJuzgado())) {
			sb.append("Juzgado; ");
		}

		procedimientoSubastaCDD.setPrincipal(convertObjectString(subasta.getProcedimiento().getSaldoRecuperacion()));
		if (Checks.esNulo(procedimientoSubastaCDD.getPrincipal())) {
			sb.append("Principal; ");
		}

		procedimientoSubastaCDD.setDeudaJudicial(convertObjectString(subasta.getDeudaJudicial()));
		if (Checks.esNulo(procedimientoSubastaCDD.getDeudaJudicial())) {
			sb.append("Deuda judicial; ");
		}

		procedimientoSubastaCDD.setCostasLetrado(getCostas(subasta, VALOR_COSTAS_LETRADO));
		if (Checks.esNulo(procedimientoSubastaCDD.getCostasLetrado())) {
			sb.append("Costas letrado; ");
		}

		procedimientoSubastaCDD.setCostasProcurador(getCostas(subasta, VALOR_COSTAS_PROCURADOR));
		if (Checks.esNulo(procedimientoSubastaCDD.getCostasProcurador())) {
			sb.append("Costas procurador; ");
		}

		procedimientoSubastaCDD.setFechaCelebracionSubasta(convertObjectString(subasta.getFechaSenyalamiento()));
		if (Checks.esNulo(procedimientoSubastaCDD.getFechaCelebracionSubasta())) {
			sb.append("Fecha celebracion subasta; ");
		}

		procedimientoSubastaCDD.setSubastaConPostores((getSubastaConPostores(subasta)) == "01" ? "Si" : "No");
		if (Checks.esNulo(procedimientoSubastaCDD.getSubastaConPostores())) {
			sb.append("Subasta con postores; ");
		}

		camposVacios += sb.toString();
		return procedimientoSubastaCDD;
	}

	private List<DatosLoteCDD> rellenaDatosLoteCDD(Subasta subasta) {
		List<DatosLoteCDD> datosLoteCDD = new ArrayList<DatosLoteCDD>();
		asignarLotesABienesSeleccionados(subasta);
		for (LoteSubasta loteSubasta : subasta.getLotesSubasta()) {
			if(!Checks.estaVacio(this.informeDTO.getBienesLote())){
				List<Long> lotes = new ArrayList<Long>();
				for(BienLoteDto bienLote : this.informeDTO.getBienesLote()) {
					if(!lotes.contains(bienLote.getLote()) && loteSubasta.getId().equals(bienLote.getLote())) {
						lotes.add(bienLote.getLote());
						datosLoteCDD.add(completaDatosLote(loteSubasta));
					}
				}
			}else {
				datosLoteCDD.add(completaDatosLote(loteSubasta));
			}
		}
		return datosLoteCDD;
	}
	
	private void asignarLotesABienesSeleccionados(Subasta subasta) {
		if(!Checks.estaVacio(this.informeDTO.getBienesLote())){
			for (LoteSubasta loteSubasta : subasta.getLotesSubasta()) {
				for(BienLoteDto bienLote : this.informeDTO.getBienesLote()) {
					for(Bien bien: loteSubasta.getBienes()) {
						if(bienLote.getIdBien().equals(bien.getId())) {
							bienLote.setLote(loteSubasta.getId());
						}
					}
				}
			}
		}
	}
	
	private DatosLoteCDD completaDatosLote(LoteSubasta loteSubasta) {
		StringBuilder sb = new StringBuilder();
		DatosLoteCDD datosLote = new DatosLoteCDD();
		datosLote.setNumLote(Checks.esNulo(loteSubasta.getNumLote()) ? null : loteSubasta.getNumLote().longValue());
		if (Checks.esNulo(datosLote.getNumLote())) {
			sb.append("Numero Lote; ");
		}

		datosLote.setSinPostores(convertObjectString(loteSubasta.getInsPujaSinPostores()));
		if (Checks.esNulo(datosLote.getSinPostores())) {
			sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Sin postores; ");
		}

		datosLote.setConPostoresDesde(convertObjectString(loteSubasta.getInsPujaPostoresDesde()));
		if (Checks.esNulo(datosLote.getConPostoresDesde())) {
			sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Con postores desde; ");
		}

		datosLote.setConPostoresHasta(convertObjectString(loteSubasta.getInsPujaPostoresHasta()));
		if (Checks.esNulo(datosLote.getConPostoresHasta())) {
			sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Con posteres hasta; ");
		}

		datosLote.setValorSubasta(convertObjectString(loteSubasta.getInsValorSubasta()));
		if (Checks.esNulo(datosLote.getValorSubasta())) {
			sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Valor subasta; ");
		}
		
		datosLote.setInfoBienes(rellenaInfoBienes(loteSubasta));
		if (Checks.estaVacio(datosLote.getInfoBienes())) {
			sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Info bienes; ");
		}
		camposVacios += sb.toString();
		return datosLote;
	}

	private List<InfoBienesCDD> rellenaInfoBienes(LoteSubasta loteSubasta) {
		List<InfoBienesCDD> listInfoBienes = new ArrayList<InfoBienesCDD>();
		List<Long> bienes = new ArrayList<Long>();
		StringBuilder sb = new StringBuilder();
		NMBBien nmbBien = null;
                
		Parametrizacion parametroLimite = (Parametrizacion) proxyFactory.proxy(SubastaApi.class).parametrizarLimite(Parametrizacion.LIMITE_EXPORT_EXCEL_BIENES_SUBASTA_CDD);
		Integer limite = Integer.parseInt(parametroLimite.getValor());
		
		if(!Checks.estaVacio(this.informeDTO.getBienesLote())){
			for(BienLoteDto bienLoteDTO : this.informeDTO.getBienesLote()) {
				if(loteSubasta.getId().equals(bienLoteDTO.getLote())) {					
					bienes.add(bienLoteDTO.getIdBien());
					if(bienes.size() == limite) {
						break;
					}
				}
			}
		}else{
			for(Bien bien : loteSubasta.getBienes()) {
				bienes.add(bien.getId());
				if(bienes.size() == limite) {
					break;
				}
			}
		}
		for(Long idBien : bienes) {
			nmbBien = (NMBBien) proxyFactory.proxy(BienApi.class).getBienById(idBien);
			
			InfoBienesCDD infobien = new InfoBienesCDD();

			infobien.setIdBien(nmbBien.getId());
			if (Checks.esNulo(infobien.getIdBien())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien ID; ");
			}
			infobien.setDescripcion(nmbBien.getDescripcionBien());
			if (Checks.esNulo(infobien.getDescripcion())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion; ");
			}
			if(Checks.esNulo(nmbBien.getDatosRegistralesActivo())) {
				infobien.setNumRegistro(null);
				infobien.setNumFinca(null);
			}else{
				infobien.setNumRegistro(nmbBien.getDatosRegistralesActivo().getNumRegistro());
				infobien.setNumFinca(nmbBien.getDatosRegistralesActivo().getNumFinca());
				if (!Checks.esNulo(nmbBien.getDatosRegistralesActivo().getLocalidad())) {
					final Localidad localidad = nmbBien.getDatosRegistralesActivo().getLocalidad();
					infobien.setLocalidadDatosRegistrales(localidad.getDescripcion());
					if(!Checks.esNulo(localidad.getProvincia())){
						infobien.setProvinciaDatosRegistrales(localidad.getProvincia().getDescripcion());
					}
				}
			}
			if (Checks.esNulo(infobien.getNumRegistro())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Numero registro; ");
			}
			infobien.setReferenciaCatastral(nmbBien.getReferenciaCatastral());
			if (Checks.esNulo(infobien.getNumFinca())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Numero finca; ");
			}
			infobien.setNumeroActivo(nmbBien.getNumeroActivo());
			if (Checks.esNulo(infobien.getNumeroActivo())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Numero activo; ");
			}
			if(Checks.esNulo(nmbBien.getValoracionActiva())) {
				infobien.setValorTasacion(null);
				infobien.setFechaTasacion(null);
			}else{
				infobien.setValorTasacion(convertObjectString(nmbBien.getValoracionActiva().getImporteValorTasacion()));
				infobien.setFechaTasacion(convertObjectString(nmbBien.getValoracionActiva().getFechaValorTasacion()));
			}
			if (Checks.esNulo(infobien.getValorTasacion())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Valor tasacion; ");
			}
			if (Checks.esNulo(infobien.getFechaTasacion())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Fecha tasacion; ");
			}
			infobien.setValorJudicial(convertObjectString(nmbBien.getTipoSubasta()));
			if (Checks.esNulo(infobien.getValorJudicial())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Valor judicial; ");
			}
			if (!Checks.esNulo(nmbBien.getLocalizacionActual())) {
				if (!Checks.esNulo(nmbBien.getLocalizacionActual().getPais())) {
					infobien.setPais(nmbBien.getLocalizacionActual().getPais().getDescripcion());
				}				
				if (!Checks.esNulo(nmbBien.getLocalizacionActual().getProvincia())) {
					infobien.setProvincia(nmbBien.getLocalizacionActual().getProvincia().getDescripcion());
				}
				if (!Checks.esNulo(nmbBien.getLocalizacionActual().getLocalidad())) {
					infobien.setLocalidad(nmbBien.getLocalizacionActual().getLocalidad().getDescripcion());
				}
				if (!Checks.esNulo(nmbBien.getLocalizacionActual().getUnidadPoblacional())) {
					infobien.setUnidadPoblacional(nmbBien.getLocalizacionActual().getUnidadPoblacional().getDescripcion());
				}
				infobien.setCodigoPostal(nmbBien.getLocalizacionActual().getCodPostal());
				infobien.setDireccion(nmbBien.getLocalizacionActual().getDireccion());
			}

			infobien.setViviendaHabitual("1".equals(nmbBien.getViviendaHabitual()) ? "SI" : ("2".equals(nmbBien.getViviendaHabitual()) ? "NO" : ""));
			if (Checks.esNulo(infobien.getViviendaHabitual())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Vivienda habitual; ");
			}
			if(Checks.esNulo(nmbBien.getAdjudicacion()) || (!Checks.esNulo(nmbBien.getAdjudicacion()) && Checks.esNulo(nmbBien.getAdjudicacion().getEntidadAdjudicataria()))) {
				infobien.setResultadoAdjudicacion(null);
			}else{
				infobien.setResultadoAdjudicacion(nmbBien.getAdjudicacion().getEntidadAdjudicataria().getDescripcion());								
			}
			if(Checks.esNulo(nmbBien.getAdjudicacion()) || (!Checks.esNulo(nmbBien.getAdjudicacion()) && Checks.esNulo(nmbBien.getAdjudicacion().getImporteAdjudicacion()))) {
				infobien.setImporteAdjudicacion(null);
			}else{
				infobien.setImporteAdjudicacion(convertObjectString(nmbBien.getAdjudicacion().getImporteAdjudicacion()));				
			}
			if (Checks.esNulo(infobien.getResultadoAdjudicacion())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Resultado adjudicacion; ");
			}
			if (Checks.esNulo(infobien.getImporteAdjudicacion())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Importe adjudicacion; ");
			}
			
			if (!Checks.esNulo(nmbBien.getAdicional())) {
				if(!Checks.esNulo(nmbBien.getAdicional().getTipoInmueble())){
					infobien.setTipoInmueble(nmbBien.getAdicional().getTipoInmueble().getDescripcion());
				}				
			}

                        // Esta validaci�n no debe hacerse si el CDD proviene de un Subasta Bankia. En el resto de T. subasta del resto de clientes, si debe hacerse.
			if(!nmbProjectContext.getCodigoSubastaBankia().equals(loteSubasta.getSubasta().getProcedimiento().getTipoProcedimiento().getCodigo())) {
				infobien.setFechaTestimonioAdjudicacionSareb(getFechaTestimonioAdjudicacionSareb(nmbBien));
				if (Checks.esNulo(infobien.getFechaTestimonioAdjudicacionSareb())) {
					sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Fecha testimonio adjudicacion sareb; ");
				}				
			}
			listInfoBienes.add(infobien);
		}
		camposVacios += sb.toString();
		return listInfoBienes;
	}
	
//	private String rellenaDatosLocalizacion(InfoBienesCDD infobien) {
//		StringBuilder sb = new StringBuilder();
//		sb.append("Provincia: ").append(infobien.getProvincia()).append(",");
//		sb.append("Localidad: ").append(infobien.getLocalidad()).append(",");
//		sb.append("Unidad poblacional: ").append(infobien.getUnidadPoblacional()).append(",");
//		sb.append("Codigo postal: ").append(infobien.getCodigoPostal()).append(",");
//		sb.append("Direccion: ").append(infobien.getDireccion()).append("");
//		return sb.toString();
//	}

	private String getSubastaConPostores(Subasta subasta) {
		String tareaCelebracionSubasta = subasta.getProcedimiento().getTipoProcedimiento().getCodigo() + "_CelebracionSubasta";
		ValorNodoTarea vnt = null;
		
		String comboPostores = nmbProjectContext.getComboPostoresCelebracionSubasta();
		vnt = (ValorNodoTarea) proxyFactory.proxy(SubastaApi.class).obtenValorNodoPrc(subasta.getProcedimiento(), tareaCelebracionSubasta, comboPostores);	
		
		if(!Checks.esNulo(vnt)) {
			return vnt.getValor();
		}
		return null;
	}
	
	private String getCostas(Subasta subasta, String costas) {
		String tareaSenyalamientoSubasta = subasta.getProcedimiento().getTipoProcedimiento().getCodigo() + "_SenyalamientoSubasta";
		ValorNodoTarea vnt = (ValorNodoTarea) proxyFactory.proxy(SubastaApi.class).obtenValorNodoPrc(subasta.getProcedimiento(), tareaSenyalamientoSubasta, costas);
		if(!Checks.esNulo(vnt)) {
			return vnt.getValor();
		}
		return null;
	}

	private String getFechaTestimonioAdjudicacionSareb(NMBBien nmbBien) {
		Map<String, String> mapaTareasCierreDeuda = nmbProjectContext.getTareasCierreDeuda();
		String nombreTarea = mapaTareasCierreDeuda.get(NMBProjectContextImpl.ADJUDICACION_TAREA_CONFIRMAR_TESTIMONIO);
		
		Map<String, String> mapaTiposProcedimiento = nmbProjectContext.getMapaTiposPrc();
		String tipoProcedimiento = mapaTiposProcedimiento.get(NMBProjectContextImpl.CONST_TIPO_PROCEDIMIENTO_ADJUDICACION);
		
		Procedimiento prc = (Procedimiento) proxyFactory.proxy(SubastaApi.class).getProcedimientoBienByIdPadre(nmbBien, this.informeDTO.getSubasta(), tipoProcedimiento);
		ValorNodoTarea valor = (ValorNodoTarea) proxyFactory.proxy(SubastaApi.class).obtenValorNodoPrc(prc, nombreTarea, VALOR_FECHA_TESTIMONIO);

		if(!Checks.esNulo(valor)) {
			return valor.getValor();
		}
		return null;
	}
	
	private boolean getExisteTareaContabilizarCDD() {
		Map<String, String> mapaTareasCierreDeuda = nmbProjectContext.getTareasCierreDeuda();
		String nombreTarea = mapaTareasCierreDeuda.get(NMBProjectContextImpl.SUBASTA_BANKIA_TAREA_CONTABILIZAR_CDD);
		
		HistoricoProcedimiento historicoPrc = (HistoricoProcedimiento) proxyFactory.proxy(SubastaApi.class).tareaExiste(this.informeDTO.getSubasta().getProcedimiento(), nombreTarea);
		
		return !Checks.esNulo(historicoPrc);
	}

	// Crea el mensaje de validacion a partir de si cumple ciertas validaciones
	private String crearMensajeValidacion(Subasta subasta) {
		StringBuilder sb = new StringBuilder();
		EXTAsunto extAsunto = EXTAsunto.instanceOf(subasta.getAsunto());
		BooleanBienes booleanBienes = new BooleanBienes();
		List<String> resultadoValidacion = new ArrayList<String>();
		
		Map<String, String> mapaSubasta = nmbProjectContext.getMapaSubastas();
		String subastaSareb = mapaSubasta.get(NMBProjectContextImpl.SUBASTA_SAREB);
		String subastaBankia = mapaSubasta.get(NMBProjectContextImpl.SUBASTA_BANKIA);
		
		if (!Checks.esNulo(camposVacios)) {
			resultadoValidacion.add(DDResultadoValidacionCDD.VALIDACION_CAMPO_SIN_INFORMAR);
			sb.append("Hay campos obligatorios que estan sin informar;");
		}
		
		if (Checks.esNulo(extAsunto.getPropiedadAsunto())) {
			resultadoValidacion.add(DDResultadoValidacionCDD.VALIDACION_INFORMAR_PROPIEDAD_ASUNTO);
			sb.append("Se tiene que informar la Propiedad Asunto para poder enviar a Cierre de Deuda;");
		} else if (DDPropiedadAsunto.PROPIEDAD_BANKIA.equals(extAsunto.getPropiedadAsunto().getCodigo()) && 
				subasta.getProcedimiento().getTipoProcedimiento().getCodigo().equals(subastaSareb)) {
			resultadoValidacion.add(DDResultadoValidacionCDD.VALIDACION_PROPIEDAD_ASUNTO_BANKIA);
			sb.append("No se puede enviar a cierre de deuda una subasta sareb si la propiedad del asunto es bankia;");
		} else if (DDPropiedadAsunto.PROPIEDAD_SAREB.equals(extAsunto.getPropiedadAsunto().getCodigo()) && 
				subasta.getProcedimiento().getTipoProcedimiento().getCodigo().equals(subastaBankia)) {
			resultadoValidacion.add(DDResultadoValidacionCDD.VALIDACION_PROPIEDAD_ASUNTO_SAREB);
			sb.append("No se puede enviar a cierre de deuda una subasta bankia si la propiedad del asunto es sareb;");
		}
		
		if(!Checks.esNulo(extAsunto.getPropiedadAsunto()) && 
				DDPropiedadAsunto.PROPIEDAD_BANKIA.equals(extAsunto.getPropiedadAsunto().getCodigo()) && 
				subasta.getProcedimiento().getTipoProcedimiento().getCodigo().equals(subastaBankia) && 
				!getExisteTareaContabilizarCDD()) {
			resultadoValidacion.add(DDResultadoValidacionCDD.VALIDACION_TAREA_CONTABILIZAR);
			sb.append("No esta iniciada la tarea Contabilizar activos/cierre de deudas de la subasta bankia que intenta enviar a cierre de deuda;");
		}

		if(!Checks.esNulo(extAsunto.getPropiedadAsunto()) && 
				DDPropiedadAsunto.PROPIEDAD_BANKIA.equals(extAsunto.getPropiedadAsunto().getCodigo())) {
			if (!validaProcedimientoContratos(subasta)) {
				resultadoValidacion.add(DDResultadoValidacionCDD.VALIDACION_PRC_SIN_OPERACION_ACTIVA);
				sb.append("El procedimiento no tienen ninguna operaci\u00F3n activa;"); // Alguna deberia ser
			}			
		}
		
		if(!Checks.esNulo(extAsunto.getPropiedadAsunto()) && 
				DDPropiedadAsunto.PROPIEDAD_SAREB.equals(extAsunto.getPropiedadAsunto().getCodigo())) {
			booleanBienes = validaBienesContratos();
			if (!booleanBienes.isValidacionCorrecta()) {
				resultadoValidacion.add(DDResultadoValidacionCDD.VALIDACION_BIEN_SIN_CONTRATO);
				for (String descBien : booleanBienes.getListBienes()) {
					sb.append("El bien ");
					sb.append(descBien);
					sb.append(" no tiene relaci\u00F3n con nin\u00FAn contrato;");
				}
			}			
		}
		
//		booleanBienes = validaBienesPersonas();
//		if (!booleanBienes.isValidacionCorrecta()) {
//			for (String descBien : booleanBienes.getListBienes()) {
//				sb.append("El bien ");
//				sb.append(descBien);
//				sb.append(" no tiene relaci�n con ninguna persona;");
//			}
//		}
		
		if (validaSinLotes()) {
			resultadoValidacion.add(DDResultadoValidacionCDD.VALIDACION_SIN_LOTES_PRC);
			sb.append("Se ha de incluir, al menos, un lote en el procedimiento;");
		}
		
		booleanBienes = validaLoteSinBien();
		if (!booleanBienes.isValidacionCorrecta()) {
			resultadoValidacion.add(DDResultadoValidacionCDD.VALIDACION_SIN_BIEN_LOTES);
			for (String descBien : booleanBienes.getListBienes()) {
				sb.append("El lote ");
				sb.append(descBien);
				sb.append(" no contiene nin\u00FAn bien;");
			}
		}
		
		BooleanBienesLotes bienLotes = validaBienVariosLote();
		if (!bienLotes.isValidacionCorrecta()) {
			resultadoValidacion.add(DDResultadoValidacionCDD.VALIDACION_BIEN_VARIOS_LOTES);
			for (BienManyLotes bienLote : bienLotes.getBienLote()) {
				sb.append("El Bien ");
				sb.append(bienLote.getBien());
				sb.append(" se encuentra en m\u00E1s de un lote (");
				int contador = 1;
				for (Long numLote : bienLote.getLotes()) {
					sb.append(numLote);
					if (contador < bienLote.getLotes().size()) {
						sb.append(", ");
						contador++;
					}
				}
				sb.append(");");
			}
		}
		this.informeDTO.setResultadoValidacion(resultadoValidacion);
		return sb.toString();
	}

	// Si el procedimiento no tiene relación con algún contrato no cancelado
	private boolean validaProcedimientoContratos(Subasta subasta) {
		boolean correcto = false;
		if (subasta.getAsunto() != null && subasta.getAsunto().getContratos() != null) {
			for (Contrato contrato : subasta.getAsunto().getContratos()) {
				if (!contrato.estaCancelado()) {
					correcto = true;
					break;
				}
			}
		}
		return correcto;
	}

	// Si algún bien incluido en el envío no tiene relación con algún contrato
	// no cancelado
	private BooleanBienes validaBienesContratos() {
		BooleanBienes validacion = new BooleanBienes();
		validacion.setValidacionCorrecta(false);
		for (DatosLoteCDD datoLote : this.informeDTO.getDatosLoteCDD()) {
			for (InfoBienesCDD infoBien : datoLote.getInfoBienes()) {
				NMBBien nmbBien = (NMBBien) proxyFactory.proxy(BienApi.class).getBienById(infoBien.getIdBien());
				if (Checks.estaVacio(nmbBien.getContratos())) {
					validacion.getListBienes().add(nmbBien.getDescripcionBien());
				}
				for (NMBContratoBien contrato : nmbBien.getContratos()) {
					if (!contrato.getContrato().estaCancelado()) {
						validacion.setValidacionCorrecta(true);
					}
				}
			}
		}
		return validacion;
	}

	// Si algún bien incluido en el envío no tiene relación con alguna persona
//	private BooleanBienes validaBienesPersonas() {
//		BooleanBienes validacion = new BooleanBienes();
//		validacion.setValidacionCorrecta(true);
//		for (DatosLoteCDD datoLote : this.informeDTO.getDatosLoteCDD()) {
//			for (InfoBienesCDD infoBien : datoLote.getInfoBienes()) {
//				NMBBien nmbBien = (NMBBien) proxyFactory.proxy(BienApi.class).getBienById(infoBien.getIdBien());
//				if (Checks.estaVacio(nmbBien.getPersonas())) {
//					validacion.setValidacionCorrecta(false);
//					validacion.getListBienes().add(nmbBien.getDescripcionBien());
//				}
//			}
//		}
//		return validacion;
//	}

	// Comprueba si no existe ningun lote
	private boolean validaSinLotes() {
		boolean incorrecto = false;
		if (Checks.estaVacio(this.informeDTO.getDatosLoteCDD())) {
			incorrecto = true;
		}
		return incorrecto;
	}

	// Comprueba si existe algun lote sin bien
	private BooleanBienes validaLoteSinBien() {
		BooleanBienes validacion = new BooleanBienes();
		validacion.setValidacionCorrecta(true);
		for (DatosLoteCDD datoLote : this.informeDTO.getDatosLoteCDD()) {
			if (Checks.estaVacio(datoLote.getInfoBienes())) {
				validacion.setValidacionCorrecta(false);
				validacion.getListBienes()
						.add(datoLote.getNumLote().toString());
			}
		}
		return validacion;
	}

	// Comprueba si un bien esta en varios lotes
	private BooleanBienesLotes validaBienVariosLote() {
		BooleanBienesLotes validacion = new BooleanBienesLotes();
		List<Long> lIdBien = new ArrayList<Long>();
		List<BienLoteDto> bienLoteDup = new ArrayList<BienLoteDto>();
		List<BienLoteDto> listBienLote = new ArrayList<BienLoteDto>();
		validacion.setValidacionCorrecta(true);
		for (DatosLoteCDD datoLote : this.informeDTO.getDatosLoteCDD()) {
			for (InfoBienesCDD infoBien : datoLote.getInfoBienes()) {
				if (!lIdBien.contains(infoBien.getIdBien())) {
					lIdBien.add(infoBien.getIdBien());
					listBienLote.add(new BienLoteDto(infoBien.getIdBien(),
							infoBien.getDescripcion(), datoLote.getNumLote()));
				} else {
					validacion.setValidacionCorrecta(false);
					bienLoteDup.add(new BienLoteDto(infoBien.getIdBien(),
							infoBien.getDescripcion(), datoLote.getNumLote()));
				}
			}
		}

		if (!validacion.isValidacionCorrecta()) {
			for (Long idBien : lIdBien) {
				BienManyLotes bienLotes = new BienManyLotes();
				for (BienLoteDto dup : bienLoteDup) {
					if (idBien.equals(dup.getIdBien())) {
						bienLotes.setBien(dup.getBien());
						bienLotes.getLotes().add(dup.getLote());
					}
				}
				for (BienLoteDto aux : listBienLote) {
					if (idBien.equals(aux.getIdBien())) {
						bienLotes.getLotes().add(aux.getLote());
					}
				}
				validacion.getBienLote().add(bienLotes);
			}
		}

		return validacion;
	}

	// Convierte un Objet en String
	private String convertObjectString(Object variable) {
		String ret = null;
		if (!Checks.esNulo(variable)) {
			if (variable instanceof Date) {
				ret = DateFormat.toString((Date) variable);
			} else if (variable instanceof Float) {
				ret = Float.toString((Float) variable);
			} else if (variable instanceof Boolean) {
				ret = ((Boolean) variable ? "SI" : "NO");
			} else if (variable instanceof BigDecimal) {
				ret = ((BigDecimal) variable).toString();
			}
		}
		return ret;
	}

	public String getCamposVacios() {
		return camposVacios;
	}
	
	public void setCamposVacios(String camposVacios) {
		this.camposVacios = camposVacios;
	}

	private class BooleanBienesLotes {
		private boolean validacionCorrecta;
		private List<BienManyLotes> bienLote = new ArrayList<BienManyLotes>();

		public boolean isValidacionCorrecta() {
			return validacionCorrecta;
		}

		public void setValidacionCorrecta(boolean validacionCorrecta) {
			this.validacionCorrecta = validacionCorrecta;
		}

		public List<BienManyLotes> getBienLote() {
			return bienLote;
		}

		public void setBienLote(List<BienManyLotes> bienLote) {
			this.bienLote = bienLote;
		}
	}

	private class BienManyLotes {
		private String bien;
		private List<Long> lotes = new ArrayList<Long>();

		public String getBien() {
			return bien;
		}

		public void setBien(String bien) {
			this.bien = bien;
		}

		public List<Long> getLotes() {
			return lotes;
		}
		
		public void setLotes(List<Long> lotes) {
			this.lotes = lotes;
		}
	}

	private class BooleanBienes {
		private boolean validacionCorrecta;
		private List<String> listBienes = new ArrayList<String>();

		public boolean isValidacionCorrecta() {
			return validacionCorrecta;
		}

		public void setValidacionCorrecta(boolean validacionCorrecta) {
			this.validacionCorrecta = validacionCorrecta;
		}

		public List<String> getListBienes() {
			return listBienes;
		}

		public void setListBienes(List<String> listBienes) {
			this.listBienes = listBienes;
		}

	}

	public InformeValidacionCDDDto getInformeDTO() {
		return informeDTO;
	}

	public void setInformeDTO(InformeValidacionCDDDto informeDTO) {
		this.informeDTO = informeDTO;
	}
	
	public ApiProxyFactory getProxyFactory() {
		return proxyFactory;
	}
	
	public void setProxyFactory(ApiProxyFactory proxyFactory) {
		this.proxyFactory = proxyFactory;
	}
	
	public NMBProjectContext getNmbProjectContext() {
		return nmbProjectContext;
	}
	
	public void setNmbProjectContext(NMBProjectContext nmbProjectContext) {
		this.nmbProjectContext = nmbProjectContext;
	}

}