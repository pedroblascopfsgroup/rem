package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.cierreDeuda;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.multigestor.api.GestorAdicionalAsuntoApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContextImpl;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.BienApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.SubastaApi;

public class InformeValidacionCDDBean {

	private static final String CODIGO_TIPO_LETRADO = "LETR";
	private static final String VALOR_COSTAS_PROCURADOR = "costasProcurador";
	private static final String VALOR_COMBO_POSTORES = "comboPostores";
	private static final String VALOR_FECHA_TESTIMONIO = "fechaTestimonio";

	private static final String TIPO_PROCEDIMIENTO_SAREB = "H002";
	private static final String TIPO_PROCEDIMIENTO_CONCURSAL = "H003";
	private static final String TIPO_PROCEDIMIENTO_TERCEROS = "H004";

	private static final String ADJUDICACION_TAREA_CONFIRMAR_TESTIMONIO = "H005_ConfirmarTestimonio";

	protected ApiProxyFactory proxyFactory;
	protected SubastaApi subastaApi;
	private List<BienLoteDto> bienesLote;
	private Long idSubasta;
	private ProcedimientoSubastaCDD procedimientoSubastaCDD;
	private List<DatosLoteCDD> datosLoteCDD;
	private String mensajesValidacion;
	private Boolean validacionOK;

	public List<Object> create() {
		InformeValidacionCDDBean informe = new InformeValidacionCDDBean();
		Subasta subasta = subastaApi.getSubasta(idSubasta);
		rellenaProcedimientoSubastaCDD(subasta);
		rellenaDatosLoteCDD(subasta);
		crearMensajeValidacion(subasta);
		validacionOK = !(hayAlgunCampoNullProcedimientoSubastaCDD()
				|| hayAlgunCampoNullDatosLoteCDD()
				|| hayAlgunCampoNullInfoBienesCDD() 
				|| !Checks.esNulo(mensajesValidacion));
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

		procedimientoSubastaCDD.setLetrado(getLetrado(subasta));
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

		procedimientoSubastaCDD.setCostasLetrado(convertObjectString(subasta.getCostasLetrado()));
		if (Checks.esNulo(procedimientoSubastaCDD.getCostasLetrado())) {
			sb.append("Costas letrado; ");
		}

		procedimientoSubastaCDD.setCostasProcurador(getCostasProcurador(subasta));
		if (Checks.esNulo(procedimientoSubastaCDD.getCostasProcurador())) {
			sb.append("Costas procurador; ");
		}

		procedimientoSubastaCDD.setFechaCelebracionSubasta(convertObjectString(subasta.getFechaSenyalamiento()));
		if (Checks.esNulo(procedimientoSubastaCDD.getFechaCelebracionSubasta())) {
			sb.append("Fecha celebracion subasta; ");
		}

		procedimientoSubastaCDD.setSubastaConPostores(getSubastaConPostores(subasta));
		if (Checks.esNulo(procedimientoSubastaCDD.getSubastaConPostores())) {
			sb.append("Subasta con postores; ");
		}

		mensajesValidacion += sb.toString();
	}

	private void rellenaDatosLoteCDD(Subasta subasta) {
		datosLoteCDD = new ArrayList<DatosLoteCDD>();
		for (LoteSubasta loteSubasta : subasta.getLotesSubasta()) {
			if(!Checks.estaVacio(getBienesLote())){
				List<Integer> lotes = new ArrayList<Integer>();
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
		datosLote.setNumLote(loteSubasta.getNumLote());
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

		if(!Checks.estaVacio(getBienesLote())){
			List<Bien> bienes = new ArrayList<Bien>();
			for(BienLoteDto bienLoteDTO : getBienesLote()) {
				if(loteSubasta.getId().equals(bienLoteDTO.getLote())) {					
					Bien bien = new Bien();
					bien.setId(bienLoteDTO.getIdBien());
					bienes.add(bien);	
				}
			}
			loteSubasta.setBienes(bienes);
		}
		datosLote.setInfoBienes(rellenaInfoBienes(loteSubasta));
		if (Checks.estaVacio(datosLote.getInfoBienes())) {
			sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Info bienes; ");
		}
		mensajesValidacion += sb.toString();
		return datosLote;
	}

	private List<InfoBienesCDD> rellenaInfoBienes(LoteSubasta loteSubasta) {
		List<InfoBienesCDD> listInfoBienes = new ArrayList<InfoBienesCDD>();
		StringBuilder sb = new StringBuilder();
		for (Bien bien : loteSubasta.getBienes()) {
			NMBBien nmbBien = (NMBBien) proxyFactory.proxy(BienApi.class).get(bien.getId());
			InfoBienesCDD infobien = new InfoBienesCDD();

			infobien.setIdBien(nmbBien.getId());
			if (Checks.esNulo(infobien.getIdBien())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien ID; ");
			}
			infobien.setDescripcion(nmbBien.getDescripcionBien());
			if (Checks.esNulo(infobien.getDescripcion())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion; ");
			}
			if(Checks.esNulo(nmbBien.getDatosRegistralesActivo().getNumRegistro())) {
				infobien.setNumRegistro(null);
			}else{
				infobien.setNumRegistro(nmbBien.getDatosRegistralesActivo().getNumRegistro());				
			}
			if (Checks.esNulo(infobien.getNumRegistro())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Numero registro; ");
			}
			infobien.setReferenciaCatastral(nmbBien.getReferenciaCatastral());
			if (Checks.esNulo(infobien.getReferenciaCatastral())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Referencia catastral; ");
			}
			if(Checks.esNulo(nmbBien.getDatosRegistralesActivo().getNumFinca())) {
				infobien.setNumFinca(null);
			} else {
				infobien.setNumFinca(nmbBien.getDatosRegistralesActivo().getNumFinca());				
			}
			if (Checks.esNulo(infobien.getNumFinca())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Numero finca; ");
			}
			infobien.setNumeroActivo(nmbBien.getNumeroActivo());
			if (Checks.esNulo(infobien.getNumeroActivo())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Numero activo; ");
			}
			if(Checks.esNulo(nmbBien.getValoracionActiva())) {
				infobien.setValorTasacion(null);
			}else{
				infobien.setValorTasacion(convertObjectString(nmbBien.getValoracionActiva().getImporteValorTasacion()));				
			}
			if (Checks.esNulo(infobien.getValorTasacion())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Valor tasacion; ");
			}
			if(Checks.esNulo(nmbBien.getValoracionActiva())) {
				infobien.setFechaTasacion(null);
			}else{
				infobien.setFechaTasacion(convertObjectString(nmbBien.getValoracionActiva().getFechaValorTasacion()));
			}
			if (Checks.esNulo(infobien.getFechaTasacion())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Fecha tasacion; ");
			}
			infobien.setValorJudicial(convertObjectString(nmbBien.getTipoSubasta()));
			if (Checks.esNulo(infobien.getValorJudicial())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Valor judicial; ");
			}
			if(!Checks.esNulo(nmbBien.getLocalizacionActual())) {
				if(!Checks.esNulo(nmbBien.getLocalizacionActual().getProvincia())) {
					infobien.setProvincia(nmbBien.getLocalizacionActual().getProvincia().getDescripcion());									
				}
				if(!Checks.esNulo(nmbBien.getLocalizacionActual().getLocalidad())) {
					infobien.setLocalidad(nmbBien.getLocalizacionActual().getLocalidad().getDescripcion());
				}
				if(!Checks.esNulo(nmbBien.getLocalizacionActual().getUnidadPoblacional())) {
					infobien.setLocalidad(nmbBien.getLocalizacionActual().getUnidadPoblacional().getDescripcion());
				}
				infobien.setCodigoPostal(nmbBien.getLocalizacionActual().getCodPostal());
				infobien.setDireccion(nmbBien.getLocalizacionActual().getDireccion());
			}
			if (Checks.esNulo(infobien.getProvincia())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Provincia; ");
			}
			if (Checks.esNulo(infobien.getLocalidad())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Localidad; ");
			}
			if (Checks.esNulo(infobien.getUnidadPoblacional())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Unidad Poblacional; ");
			}
			if (Checks.esNulo(infobien.getDireccion())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Dirección; ");
			}
			if (Checks.esNulo(infobien.getCodigoPostal())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Codigo Postal; ");
			}	
			infobien.setViviendaHabitual(convertObjectString(nmbBien.getViviendaHabitual()));
			if (Checks.esNulo(infobien.getViviendaHabitual())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Vivienda habitual; ");
			}
			if(Checks.esNulo(nmbBien.getAdjudicacion()) && Checks.esNulo(nmbBien.getAdjudicacion().getEntidadAdjudicataria())) {
				infobien.setResultadoAdjudicacion(null);
			}else{
				infobien.setResultadoAdjudicacion(nmbBien.getAdjudicacion().getEntidadAdjudicataria().getDescripcion());
			}
			if (Checks.esNulo(infobien.getResultadoAdjudicacion())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Resultado adjudicacion; ");
			}
			if(Checks.esNulo(nmbBien.getAdjudicacion())) {
				infobien.setImporteAdjudicacion(null);
			}else{
				infobien.setImporteAdjudicacion(convertObjectString(nmbBien.getAdjudicacion().getImporteAdjudicacion()));				
			}
			if (Checks.esNulo(infobien.getImporteAdjudicacion())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Importe adjudicacion; ");
			}
			infobien.setFechaTestimonioAdjudicacionSareb(getFechaTestimonioAdjudicacionSareb(loteSubasta.getSubasta()));
			if (Checks.esNulo(infobien.getFechaTestimonioAdjudicacionSareb())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", Fecha testimonio adjudicacion sareb; ");
			}
			infobien.setContratosRelacionado(contratosBienRelacionados(nmbBien));
			if (Checks.esNulo(infobien.getContratosRelacionado())) {
				sb.append("Numero Lote:").append(loteSubasta.getNumLote()).append(", Bien Descripcion:").append(nmbBien.getDescripcionBien()).append(", List Contratos relacionado; ");
			}
			listInfoBienes.add(infobien);
		}
		mensajesValidacion += sb.toString();
		return listInfoBienes;
	}

	private String getLetrado(Subasta subasta) {
		String usuarioLetrado = "";
		List<Usuario> usuarios = (List<Usuario>) proxyFactory.proxy(GestorAdicionalAsuntoApi.class).findGestoresByAsunto(subasta.getAsunto().getId(), CODIGO_TIPO_LETRADO);
		if (!Checks.estaVacio(usuarios) && usuarios.size() == 1) {
			usuarioLetrado = usuarios.get(0).getApellidoNombre();
		}
		return usuarioLetrado;
	}

	private String getSubastaConPostores(Subasta subasta) {
		String tareaCelebracionSubasta = "";

		Map<String, String> mapaTareasCierreDeuda = (Map<String, String>) proxyFactory.proxy(SubastaApi.class).obtenerTareasCierreDeuda();
		if (TIPO_PROCEDIMIENTO_SAREB.equals(subasta.getProcedimiento().getTipoProcedimiento().getCodigo())) {
			tareaCelebracionSubasta = mapaTareasCierreDeuda.get(NMBProjectContextImpl.CONST_TAREA_CELEBRACION_SUBASTA_SAREB);
		} else if (TIPO_PROCEDIMIENTO_CONCURSAL.equals(subasta.getProcedimiento().getTipoProcedimiento().getCodigo())) {
			tareaCelebracionSubasta = mapaTareasCierreDeuda.get(NMBProjectContextImpl.CONST_TAREA_CELEBRACION_SUBASTA_CONCURSAL);
		} else if (TIPO_PROCEDIMIENTO_TERCEROS.equals(subasta.getProcedimiento().getTipoProcedimiento().getCodigo())) {
			tareaCelebracionSubasta = mapaTareasCierreDeuda.get(NMBProjectContextImpl.CONST_TAREA_CELEBRACION_SUBASTA_TERCEROS);
		}

		return subastaApi.obtenValorNodoPrc(subasta.getProcedimiento(), tareaCelebracionSubasta, VALOR_COMBO_POSTORES);
	}

	private String getCostasProcurador(Subasta subasta) {
		String tareaSenyalamientoSubasta = "";

		Map<String, String> mapaTareasCierreDeuda = (Map<String, String>) proxyFactory.proxy(SubastaApi.class).obtenerTareasCierreDeuda();
		if (TIPO_PROCEDIMIENTO_SAREB.equals(subasta.getProcedimiento().getTipoProcedimiento().getCodigo())) {
			tareaSenyalamientoSubasta = mapaTareasCierreDeuda.get(NMBProjectContextImpl.CONST_TAREA_SENYALAMIENTO_SUBASTA_SAREB);
		} else if (TIPO_PROCEDIMIENTO_CONCURSAL.equals(subasta.getProcedimiento().getTipoProcedimiento().getCodigo())) {
			tareaSenyalamientoSubasta = mapaTareasCierreDeuda.get(NMBProjectContextImpl.CONST_TAREA_SENYALAMIENTO_SUBASTA_CONCURSAL);
		} else if (TIPO_PROCEDIMIENTO_TERCEROS.equals(subasta.getProcedimiento().getTipoProcedimiento().getCodigo())) {
			tareaSenyalamientoSubasta = mapaTareasCierreDeuda.get(NMBProjectContextImpl.CONST_TAREA_SENYALAMIENTO_SUBASTA_TERCEROS);
		}

		return subastaApi.obtenValorNodoPrc(subasta.getProcedimiento(), tareaSenyalamientoSubasta, VALOR_COSTAS_PROCURADOR);
	}

	private String getFechaTestimonioAdjudicacionSareb(Subasta subasta) {
		return subastaApi.obtenValorNodoPrc(subasta.getProcedimiento(), ADJUDICACION_TAREA_CONFIRMAR_TESTIMONIO, VALOR_FECHA_TESTIMONIO);
	}

	private List<String> contratosBienRelacionados(NMBBien nmbBien) {
		List<String> listContratosBien = new ArrayList<String>();
		for (NMBContratoBien contrato : nmbBien.getContratos()) {
			listContratosBien.add(contrato.getContrato().getDescripcion());
		}
		return listContratosBien;
	}

	// Crea el mensaje de validacion a partir de si cumple ciertas validaciones
	private void crearMensajeValidacion(Subasta subasta) {
		StringBuilder sb = new StringBuilder();
		BooleanBienes booleanBienes = new BooleanBienes();
		if (validaProcedimientoContratos(subasta)) {
			sb.append("El procedimiento no tienen ninguna operación activa");
		}
		booleanBienes = validaBienesContratos();
		if (!booleanBienes.isValidacionCorrecta()) {
			for (String descBien : booleanBienes.getListBienes()) {
				sb.append("El bien ");
				sb.append(descBien);
				sb.append(" no tiene relación con ningún contrato");
			}
		}
		booleanBienes = validaBienesPersonas();
		if (!booleanBienes.isValidacionCorrecta()) {
			for (String descBien : booleanBienes.getListBienes()) {
				sb.append("El bien ");
				sb.append(descBien);
				sb.append(" no tiene relación con ninguna persona");
			}
		}
		if (validaSinLotes()) {
			sb.append("Se ha de incluir, al menos, un lote en el procedimiento");
		}
		booleanBienes = validaLoteSinBien();
		if (!booleanBienes.isValidacionCorrecta()) {
			for (String descBien : booleanBienes.getListBienes()) {
				sb.append("El lote ");
				sb.append(descBien);
				sb.append(" no contiene ningún bien");
			}
		}
		BooleanBienesLotes bienLotes = validaBienVariosLote();
		if (!bienLotes.isValidacionCorrecta()) {
			for (BienManyLotes bienLote : bienLotes.getBienLote()) {
				sb.append("El Bien ");
				sb.append(bienLote.getBien());
				sb.append(" se encuentra en más de un lote (");
				int contador = 1;
				for (Integer numLote : bienLote.getLotes()) {
					sb.append(numLote);
					if (contador < bienLote.getLotes().size()) {
						sb.append(", ");
						contador++;
					}
				}
				sb.append(")");
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
				NMBBien nmbBien = (NMBBien) proxyFactory.proxy(BienApi.class).get(infoBien.getIdBien());
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
				NMBBien nmbBien = (NMBBien) proxyFactory.proxy(BienApi.class).get(infoBien.getIdBien());
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
		boolean correcto = true;
		if (Checks.estaVacio(getDatosLoteCDD())) {
			correcto = false;
		}
		return correcto;
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

	private boolean hayAlgunCampoNullProcedimientoSubastaCDD() {
		Field[] fields = ProcedimientoSubastaCDD.class.getDeclaredFields();
		for (Field f : fields) {
			String field = f.getName();
			try {
				// Obtener nombre de Metodo Getter
				Method getter = procedimientoSubastaCDD.getClass().getMethod(
						"get" + String.valueOf(field.charAt(0)).toUpperCase()
								+ field.substring(1));

				// Llamo al Metodo especificado de este Objeto
				// con un array con los respectivos Parametros
				// En este caso al ser un Getter no recibe parametros
				Object value = getter.invoke(procedimientoSubastaCDD,
						new Object[0]);
				if (Checks.esNulo(value)) {
					return true;
				}
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return false;
	}

	private boolean hayAlgunCampoNullDatosLoteCDD() {
		Field[] fields = DatosLoteCDD.class.getDeclaredFields();
		for (Field f : fields) {
			String field = f.getName();
			try {
				// Obtener nombre de Metodo Getter
				Method getter = datosLoteCDD.getClass().getMethod(
						"get" + String.valueOf(field.charAt(0)).toUpperCase()
								+ field.substring(1));

				// Llamo al Metodo especificado de este Objeto
				// con un array con los respectivos Parametros
				// En este caso al ser un Getter no recibe parametros
				Object value = getter.invoke(datosLoteCDD, new Object[0]);
				if (Checks.esNulo(value)) {
					return true;
				}
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return false;
	}

	private boolean hayAlgunCampoNullInfoBienesCDD() {
		for (DatosLoteCDD datoLote : datosLoteCDD) {
			for (InfoBienesCDD infoBien : datoLote.getInfoBienes()) {
				Field[] fields = InfoBienesCDD.class.getDeclaredFields();
				for (Field f : fields) {
					String field = f.getName();
					try {
						// Obtener nombre de Metodo Getter
						Method getter = infoBien.getClass().getMethod(
								"get"
										+ String.valueOf(field.charAt(0))
												.toUpperCase()
										+ field.substring(1));

						// Llamo al Metodo especificado de este Objeto
						// con un array con los respectivos Parametros
						// En este caso al ser un Getter no recibe parametros
						Object value = getter.invoke(datosLoteCDD,
								new Object[0]);
						if (Checks.esNulo(value)) {
							return true;
						}
					} catch (Exception ex) {
						ex.printStackTrace();
					}
				}
			}
		}
		return false;
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
				ret = ((Boolean) variable ? "true" : "false");
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
		private List<Integer> lotes;

		public String getBien() {
			return bien;
		}

		public void setBien(String bien) {
			this.bien = bien;
		}

		public List<Integer> getLotes() {
			return lotes;
		}

		public void setLotes(List<Integer> lotes) {
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

}