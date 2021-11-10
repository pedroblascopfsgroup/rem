package es.pfsgroup.plugin.rem.service;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.activo.dao.*;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.ActivoPublicacionDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.*;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.*;
import es.pfsgroup.plugin.rem.notificacion.api.AnotacionApi;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.*;

@Component
public class TabActivoInformeFiscal implements TabActivoService {

	@Autowired
	private GenericABMDao genericDao;
	
	protected static final Log logger = LogFactory.getLog(TabActivoInformeFiscal.class);

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_INFORME_FISCAL};
	}
	
	
	public DtoActivoFichaInformeFiscal getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoActivoFichaInformeFiscal dto = new DtoActivoFichaInformeFiscal();
		ActivoFiscalidadAdquisicion afa = genericDao.get(ActivoFiscalidadAdquisicion.class,
				genericDao.createFilter(FilterType.EQUALS, "activo", activo));

		if(afa == null){
			return dto;
		}

		BeanUtils.copyProperties(dto, afa);

		dto = setCodigosDiccionarios(afa, dto);

		return dto;
	}

	private DtoActivoFichaInformeFiscal setCodigosDiccionarios(ActivoFiscalidadAdquisicion afa, DtoActivoFichaInformeFiscal dto) {

		dto.setBonificado(afa.getBonificado() != null ? afa.getBonificado() == 1 ? DDSinSiNo.CODIGO_SI : DDSinSiNo.CODIGO_NO : null);
		dto.setDeducible(afa.getDeducible() != null ? afa.getDeducible() == 1 ? DDSinSiNo.CODIGO_SI : DDSinSiNo.CODIGO_NO : null);
		dto.setRenunciaExencionCompra(afa.getRenunciaExencionCompra() != null ? afa.getRenunciaExencionCompra() ? DDSinSiNo.CODIGO_SI : DDSinSiNo.CODIGO_NO : null);
		dto.setCodigoTipoImpositivoITP(afa.getTipoImpositivoITP() != null ? afa.getTipoImpositivoITP().getCodigo() : null);
		dto.setCodigoTipoImpuestoCompra(afa.getTipoImpuestoCompra() != null ? afa.getTipoImpuestoCompra().getCodigo() : null);
		dto.setCodigoTipoImpositivoIVA(afa.getTipoImpositivoIVA() != null ? afa.getTipoImpositivoIVA().getCodigo() : null);

		return dto;
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto)  throws JsonViewerException {
		return activo;
	}
}

