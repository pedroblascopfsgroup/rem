package es.pfsgroup.commons.utils;

import javax.sql.DataSource;

import org.springframework.batch.item.database.support.DefaultDataFieldMaxValueIncrementerFactory;
import org.springframework.jdbc.support.incrementer.DataFieldMaxValueIncrementer;
import org.springframework.jdbc.support.incrementer.OracleSequenceMaxValueIncrementer;


public class PFSDataFieldMaxValueIncrementerFactory extends
		DefaultDataFieldMaxValueIncrementerFactory {

	public class PFSIncrementer extends OracleSequenceMaxValueIncrementer
			implements DataFieldMaxValueIncrementer {

		public PFSIncrementer(DataSource dataSource, String incrementerName) {
			super(dataSource, incrementerName);
		}

		@Override
		protected String getSequenceQuery() {
			return "select ${master.schema}.batch_job_seq.nextval from dual";
		}

	}

	public PFSDataFieldMaxValueIncrementerFactory(DataSource dataSource) {
		super(dataSource);
		this.ds = dataSource;
	}
	
	private DataSource ds;

	@Override
	public DataFieldMaxValueIncrementer getIncrementer(String incrementerType,
			String incrementerName) {
		// TODO Auto-generated method stub
		return new PFSIncrementer(this.ds, "pfsIncrementer");
	}

}
