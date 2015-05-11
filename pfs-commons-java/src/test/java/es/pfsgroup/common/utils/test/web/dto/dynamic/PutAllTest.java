package es.pfsgroup.common.utils.test.web.dto.dynamic;

import java.util.Date;

import org.junit.Test;

import static org.junit.Assert.*;

import es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample.DictImpl;
import es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample.DictInfo;
import es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample.MainEntity;
import es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample.MainInfo;
import es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample.OtherImpl;
import es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample.OtherInfo;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDTO;

public class PutAllTest {
	
	
	
	protected static final String OTHER_DESCRIPCION = "Other descripcion";
	protected static final String NAME = "My name";
	protected static final String DICT_DESCRIPCION = "Dict description";
	protected static final Date DATE = new Date();

	@Test
	public void testPutAllExample() throws Exception {
		MainInfo mainInfo = createMainInfo();
		MainEntity entity = new DynamicDTO<MainEntity>(MainEntity.class).putAll(mainInfo).create();
		
		//Assert values
		assertNull(entity.getId());
		assertEquals(NAME, entity.getName());
		assertEquals(DATE, entity.getDate());
		assertNotNull(entity.getDictionary());
		assertNotNull(entity.getOther());
		assertNull(entity.getDictionary().getCode());
		assertNull(entity.getOther().getId());
		assertEquals(OTHER_DESCRIPCION, entity.getOther().getDescripcion());
		assertEquals(DICT_DESCRIPCION, entity.getDictionary().getDescripcion());
	}

	private MainInfo createMainInfo() {
		return new MainInfo() {
			
			@Override
			public OtherInfo getOther() {
				return new OtherImpl(OTHER_DESCRIPCION);
			}
			
			@Override
			public String getName() {
				return NAME;
			}
			
			@Override
			public DictInfo getDictionary() {
				return new DictImpl(DICT_DESCRIPCION);
			}
			
			@Override
			public Date getDate() {
				return DATE;
			}
		};
	}

}
