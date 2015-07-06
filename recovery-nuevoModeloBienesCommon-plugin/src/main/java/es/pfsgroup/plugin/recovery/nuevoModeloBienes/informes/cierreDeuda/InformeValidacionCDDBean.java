package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.cierreDeuda;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
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

	protected SubastaApi subastaApi;
	protected ApiProxyFactory proxyFactory;
	protected NMBProjectContext nmbProjectContext;
	
	private List<BienLoteDto> bienesLote;
	private Long idSubasta;
	private ProcedimientoSubastaCDD procedimientoSubastaCDD;
	private List<DatosLoteCDD> datosLoteCDD;
	private String mensajesValidacion="";
	private String camposVacios="";
	private Boolean validacionOK;
	private Subasta subasta;

	public List<Object> create() {
		InformeValidacionCDDBean informe = new InformeValidacionCDDBean();
		subasta = subastaApi.getSubasta(idSubasta);
		rellenaProcedimientoSubastaCDD(subasta);
		rellenaDatosLoteCDD(subasta);
		crearMensajeValidacion(subasta);
		validacionOK = Checks.esNulo(mensajesValidacion);
		return Arrays.asList((Object) informe);
	}

	private void rellenaProcedimientoSubastaCDD(Subasta subasta) {
		StringBuilder sb = new StringBuilder();
		procedimientoSubastaCDD = new ProcedimientoSubastaCDD();

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
	}

	private void rellenaDatosLoteCDD(Subasta subasta) {
		datosLoteCDD = new ArrayList<DatosLoteCDD>();
		for (LoteSubasta loteSubasta : subasta.getLotesSubasta()) {
			if(!Checks.estaVacio(getBienesLote())){
				List<Long> lotes = new ArrayList<Long>();
				for(BienLoteDto bienLote : getBienesLote()) {
					if(!lotes.contains(bienLote.getLote()) && loteSubasta.getId().equals(bienLote.getLote())) {
						lotes.add(bienLote.getLote());
						datosLoteCDD.add(completaDatosLote(loteSubasta));
					}
				}
			}else {
				datosLoteCDD.add(completaDatosLote(loteSubasta));
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
		
		if(!Checks.estaVacio(getBienesLote())){
			for(BienLoteDto bienLoteDTO : getBienesLote()) {
				if(loteSubasta.getId().equals(bienLoteDTO.getLote())) {					
					bienes.add(bienLoteDTO.getIdBien());
				}
			}
		}else{ 
			for(Bien bien : loteSubasta.getBienes()) {
				bienes.add(bien.getId());
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
			}
			if (Checks.esNulo(infobien.getNumRegistro())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Numero registro; ");
			}
			infobien.setReferenciaCatastral(nmbBien.getReferenciaCatastral());
//			if (Checks.esNulo(infobien.getReferenciaCatastral())) {
//				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Referencia catastral; ");
//			}
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
//			if(!Checks.esNulo(nmbBien.getLocalizacionActual())) {
//				if(!Checks.esNulo(nmbBien.getLocalizacionActual().getProvincia())) {
//					infobien.setProvincia(nmbBien.getLocalizacionActual().getProvincia().getDescripcion());									
//				}
//				if(!Checks.esNulo(nmbBien.getLocalizacionActual().getLocalidad())) {
//					infobien.setLocalidad(nmbBien.getLocalizacionActual().getLocalidad().getDescripcion());
//				}
//				if(!Checks.esNulo(nmbBien.getLocalizacionActual().getUnidadPoblacional())) {
//					infobien.setUnidadPoblacional(nmbBien.getLocalizacionActual().getUnidadPoblacional().getDescripcion());
//				}
//				infobien.setCodigoPostal(nmbBien.getLocalizacionActual().getCodPostal());
//				infobien.setDireccion(nmbBien.getLocalizacionActual().getDireccion());
//			}
//			
//			infobien.setDatosLocalizacion(rellenaDatosLocalizacion(infobien));
//			
//			if (Checks.esNulo(infobien.getProvincia())) {
//				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Provincia; ");
//			}
//			if (Checks.esNulo(infobien.getLocalidad())) {
//				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Localidad; ");
//			}
//			if (Checks.esNulo(infobien.getUnidadPoblacional())) {
//				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Unidad Poblacional; ");
//			}
//			if (Checks.esNulo(infobien.getDireccion())) {
//				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Dirección; ");
//			}
//			if (Checks.esNulo(infobien.getCodigoPostal())) {
//				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Codigo Postal; ");
//			}	
			infobien.setViviendaHabitual(convertObjectString(nmbBien.getViviendaHabitual()));
			if (Checks.esNulo(infobien.getViviendaHabitual())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Vivienda habitual; ");
			}
			if(Checks.esNulo(nmbBien.getAdjudicacion()) || (!Checks.esNulo(nmbBien.getAdjudicacion()) && Checks.esNulo(nmbBien.getAdjudicacion().getEntidadAdjudicataria()))) {
				infobien.setResultadoAdjudicacion(null);
				infobien.setImporteAdjudicacion(null);
			}else{
				infobien.setResultadoAdjudicacion(nmbBien.getAdjudicacion().getEntidadAdjudicataria().getDescripcion());
				infobien.setImporteAdjudicacion(convertObjectString(nmbBien.getAdjudicacion().getImporteAdjudicacion()));				
			}
			if (Checks.esNulo(infobien.getResultadoAdjudicacion())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Resultado adjudicacion; ");
			}
			if (Checks.esNulo(infobien.getImporteAdjudicacion())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Importe adjudicacion; ");
			}
			if(!"P401".equals(loteSubasta.getSubasta().getProcedimiento().getTipoProcedimiento().getCodigo())) {
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
		vnt = subastaApi.obtenValorNodoPrc(subasta.getProcedimiento(), tareaCelebracionSubasta, comboPostores);	
		
		if(!Checks.esNulo(vnt)) {
			return vnt.getValor();
		}
		return null;
	}
	
	private String getCostas(Subasta subasta, String costas) {
		String tareaSenyalamientoSubasta = subasta.getProcedimiento().getTipoProcedimiento().getCodigo() + "_SenyalamientoSubasta";
		ValorNodoTarea vnt = subastaApi.obtenValorNodoPrc(subasta.getProcedimiento(), tareaSenyalamientoSubasta, costas);
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
		
		Procedimiento prc = subastaApi.getProcedimientoBienByIdPadre(nmbBien, subasta, tipoProcedimiento);
		
		ValorNodoTarea valor = subastaApi.obtenValorNodoPrc(prc, nombreTarea, VALOR_FECHA_TESTIMONIO);
		if(!Checks.esNulo(valor)) {
			return valor.getValor();
		}
		return null;
	}
	
	private boolean getExisteTareaContabilizarCDD() {
		Map<String, String> mapaTareasCierreDeuda = nmbProjectContext.getTareasCierreDeuda();
		String nombreTarea = mapaTareasCierreDeuda.get(NMBProjectContextImpl.SUBASTA_BANKIA_TAREA_CONTABILIZAR_CDD);
		
		HistoricoProcedimiento historicoPrc = subastaApi.tareaExiste(subasta.getProcedimiento(), nombreTarea);
		
		return !Checks.esNulo(historicoPrc);
	}

	// Crea el mensaje de validacion a partir de si cumple ciertas validaciones
	private void crearMensajeValidacion(Subasta subasta) {
		StringBuilder sb = new StringBuilder();
		EXTAsunto extAsunto = EXTAsunto.instanceOf(subasta.getAsunto());
		BooleanBienes booleanBienes = new BooleanBienes();
		
		Map<String, String> mapaSubasta = nmbProjectContext.getMapaSubastas();
		String subastaSareb = mapaSubasta.get(NMBProjectContextImpl.SUBASTA_SAREB);
		String subastaBankia = mapaSubasta.get(NMBProjectContextImpl.SUBASTA_BANKIA);
		
		if (!Checks.esNulo(camposVacios)) {
			sb.append("Hay campos obligatorios que estan sin informar;");
		}
		
		if (Checks.esNulo(extAsunto.getPropiedadAsunto())) {
			sb.append("Se tiene que informar la Propiedad Asunto para poder enviar a Cierre de Deuda;");
		} else if (DDPropiedadAsunto.PROPIEDAD_BANKIA.equals(extAsunto.getPropiedadAsunto().getCodigo()) && 
				subasta.getProcedimiento().getTipoProcedimiento().getCodigo().equals(subastaSareb)) {
			sb.append("No se puede enviar a cierre de deuda una subasta sareb si la propiedad del asunto es bankia;");
		} else if (DDPropiedadAsunto.PROPIEDAD_SAREB.equals(extAsunto.getPropiedadAsunto().getCodigo()) && 
				subasta.getProcedimiento().getTipoProcedimiento().getCodigo().equals(subastaBankia)) {
			sb.append("No se puede enviar a cierre de deuda una subasta bankia si la propiedad del asunto es sareb;");
		}
		
		if(!Checks.esNulo(extAsunto.getPropiedadAsunto()) && 
				DDPropiedadAsunto.PROPIEDAD_BANKIA.equals(extAsunto.getPropiedadAsunto().getCodigo()) && 
				subasta.getProcedimiento().getTipoProcedimiento().getCodigo().equals(subastaBankia) && 
				!getExisteTareaContabilizarCDD()) {
			sb.append("No esta iniciada la tarea Contabilizar activos/cierre de deudas de la subasta bankia que intenta enviar a cierre de deuda;");
		}

		if(!Checks.esNulo(extAsunto.getPropiedadAsunto()) && 
				DDPropiedadAsunto.PROPIEDAD_BANKIA.equals(extAsunto.getPropiedadAsunto().getCodigo())) {
			if (!validaProcedimientoContratos(subasta)) {
				sb.append("El procedimiento no tienen ninguna operacion activa;"); // Alguna deberia ser
			}			
		}
		
		if(!Checks.esNulo(extAsunto.getPropiedadAsunto()) && 
				DDPropiedadAsunto.PROPIEDAD_SAREB.equals(extAsunto.getPropiedadAsunto().getCodigo())) {
			booleanBienes = validaBienesContratos();
			if (!booleanBienes.isValidacionCorrecta()) {
				for (String descBien : booleanBienes.getListBienes()) {
					sb.append("El bien ");
					sb.append(descBien);
					sb.append(" no tiene relaci�n con ning�n contrato;");
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
			sb.append("Se ha de incluir, al menos, un lote en el procedimiento;");
		}
		
		booleanBienes = validaLoteSinBien();
		if (!booleanBienes.isValidacionCorrecta()) {
			for (String descBien : booleanBienes.getListBienes()) {
				sb.append("El lote ");
				sb.append(descBien);
				sb.append(" no contiene ning�n bien;");
			}
		}
		
		BooleanBienesLotes bienLotes = validaBienVariosLote();
		if (!bienLotes.isValidacionCorrecta()) {
			for (BienManyLotes bienLote : bienLotes.getBienLote()) {
				sb.append("El Bien ");
				sb.append(bienLote.getBien());
				sb.append(" se encuentra en m�s de un lote (");
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
		mensajesValidacion = sb.toString();
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
		for (DatosLoteCDD datoLote : getDatosLoteCDD()) {
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
	private BooleanBienes validaBienesPersonas() {
		BooleanBienes validacion = new BooleanBienes();
		validacion.setValidacionCorrecta(true);
		for (DatosLoteCDD datoLote : getDatosLoteCDD()) {
			for (InfoBienesCDD infoBien : datoLote.getInfoBienes()) {
				NMBBien nmbBien = (NMBBien) proxyFactory.proxy(BienApi.class).getBienById(infoBien.getIdBien());
				if (Checks.estaVacio(nmbBien.getPersonas())) {
					validacion.setValidacionCorrecta(false);
					validacion.getListBienes().add(nmbBien.getDescripcionBien());
				}
			}
		}
		return validacion;
	}

	// Comprueba si no existe ningun lote
	private boolean validaSinLotes() {
		boolean incorrecto = false;
		if (Checks.estaVacio(getDatosLoteCDD())) {
			incorrecto = true;
		}
		return incorrecto;
	}

	// Comprueba si existe algun lote sin bien
	private BooleanBienes validaLoteSinBien() {
		BooleanBienes validacion = new BooleanBienes();
		validacion.setValidacionCorrecta(true);
		for (DatosLoteCDD datoLote : getDatosLoteCDD()) {
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
		for (DatosLoteCDD datoLote : getDatosLoteCDD()) {
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

	public ApiProxyFactory getProxyFactory() {
		return proxyFactory;
	}

	public void setProxyFactory(ApiProxyFactory proxyFactory) {
		this.proxyFactory = proxyFactory;
	}

	public SubastaApi getSubastaApi() {
		return subastaApi;
	}

	public void setSubastaApi(SubastaApi subastaApi) {
		this.subastaApi = subastaApi;
	}
	
	public NMBProjectContext getNmbProjectContext() {
		return nmbProjectContext;
	}
	
	public void setNmbProjectContext(NMBProjectContext nmbProjectContext) {
		this.nmbProjectContext = nmbProjectContext;
	}
	
	public List<BienLoteDto> getBienesLote() {
		return bienesLote;
	}

	public void setBienesLote(List<BienLoteDto> bienesLote) {
		this.bienesLote = bienesLote;
	}

	public Long getIdSubasta() {
		return idSubasta;
	}

	public void setIdSubasta(Long idSubasta) {
		this.idSubasta = idSubasta;
	}

	public ProcedimientoSubastaCDD getProcedimientoSubastaCDD() {
		return procedimientoSubastaCDD;
	}

	public void setProcedimientoSubastaCDD(
			ProcedimientoSubastaCDD procedimientoSubastaCDD) {
		this.procedimientoSubastaCDD = procedimientoSubastaCDD;
	}

	public List<DatosLoteCDD> getDatosLoteCDD() {
		return datosLoteCDD;
	}

	public void setDatosLoteCDD(List<DatosLoteCDD> datosLoteCDD) {
		this.datosLoteCDD = datosLoteCDD;
	}

	public String getMensajesValidacion() {
		return mensajesValidacion;
	}

	public void setMensajesValidacion(String mensajesValidacion) {
		this.mensajesValidacion = mensajesValidacion;
	}

	public Boolean getValidacionOK() {
		return validacionOK;
	}

	public void setValidacionOK(Boolean validacionOK) {
		this.validacionOK = validacionOK;
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
	
	public Subasta getSubasta() {
		return subasta;
	}

	public void setSubasta(Subasta subasta) {
		this.subasta = subasta;
	}
	

}