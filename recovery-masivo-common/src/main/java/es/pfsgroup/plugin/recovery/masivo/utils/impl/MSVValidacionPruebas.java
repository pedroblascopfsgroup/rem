package es.pfsgroup.plugin.recovery.masivo.utils.impl;

import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoValidacion;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVExcelFileItemDto;
import es.pfsgroup.plugin.recovery.masivo.utils.MSVExcelValidator;


@Component
public class MSVValidacionPruebas implements MSVExcelValidator{

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto file) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public MSVDtoValidacion validarFormatoFichero(MSVExcelFileItemDto file) {
		MSVDtoValidacion dto= new MSVDtoValidacion();
		dto.setFicheroTieneErrores(true);
		dto.setExcelErroresFormato(new FileItem());
		return dto;
	}

}
