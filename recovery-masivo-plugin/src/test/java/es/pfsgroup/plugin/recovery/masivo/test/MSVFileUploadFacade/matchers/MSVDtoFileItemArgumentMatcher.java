package es.pfsgroup.plugin.recovery.masivo.test.MSVFileUploadFacade.matchers;

import org.hamcrest.Description;
import org.hamcrest.Matcher;
import org.mockito.ArgumentMatcher;

import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFileItem;

public class MSVDtoFileItemArgumentMatcher extends ArgumentMatcher<MSVDtoFileItem> {

	private Long idTipoOperacion;
	private Long idProceso;

	public MSVDtoFileItemArgumentMatcher(Long idTipoOperacion, Long idProceso) {
		super();
		this.idTipoOperacion = idTipoOperacion;
		this.idProceso = idProceso;
	}

	@Override
	public boolean matches(Object arg0) {
		if (arg0 != null) {
			if (arg0 instanceof MSVDtoFileItem) {
				MSVDtoFileItem dto = (MSVDtoFileItem) arg0;
				return checkEquals(idTipoOperacion, dto.getIdTipoOperacion()) 
						&& checkEquals(idProceso, dto.getIdProceso());
			}
		}
		return false;
	}

	private boolean checkEquals(Object expected, Object current) {
		if (expected != null) {
			return expected.equals(current);
		} else {
			return current == null;
		}
	}

}
