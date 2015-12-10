package es.capgemini.devon.hibernate.dao;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import javax.transaction.TransactionManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.HibernateException;
import org.springframework.jdbc.support.lob.LobCreator;
import org.springframework.jdbc.support.lob.LobHandler;
import org.springframework.orm.hibernate3.support.AbstractLobType;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.FileManagerImpl;

/**
 * <p>Hibernate UserType implementation for files that get mapped to BLOBs. Retrieves the LobHandler to use from
 * LocalSessionFactoryBean at config time.</p>
 * <p>Can also be defined in generic Hibernate mappings, as DefaultLobCreator will work with most JDBC-compliant
 * database drivers. In this case, the field type does not have to be BLOB: For databases like MySQL and MS SQL
 * Server, any large enough binary type will work.</p>
 * <p>This UserType creates a temporary file using {@link #createTemporaryFile(java.io.File, java.sql.ResultSet, String[], Object)}
 * method. By default the file name is generated using the value returned from {@link Object#hashCode()} on the owner.
 * This can be modified by extending this class and re-implementing the
 * {@link #createTemporaryFile(java.io.File, java.sql.ResultSet, String[], Object)} method.</p>
 *
 * <p>Based on org.springframework.orm.hibernate3.support.BlobByteArrayType by Juergen Hoeller.</p>
 *
 * @author Dan Washusen
 * @version $Id: BlobStreamType.java 9693 2009-07-23 19:19:01Z ncornagl $
 */
public class BlobStreamType extends AbstractLobType {

    private static final Log log = LogFactory.getLog(BlobStreamType.class);

    /**
     * Constructor used by Hibernate: fetches config-time LobHandler and
     * config-time JTA TransactionManager from LocalSessionFactoryBean.
     *
     * @see org.springframework.orm.hibernate3.LocalSessionFactoryBean#getConfigTimeLobHandler
     * @see org.springframework.orm.hibernate3.LocalSessionFactoryBean#getConfigTimeTransactionManager
     */
    public BlobStreamType() {
        super();
    }

    /**
     * Constructor used for testing: takes an explicit LobHandler
     * and an explicit JTA TransactionManager (can be null).
     */
    protected BlobStreamType(LobHandler lobHandler, TransactionManager jtaTransactionManager) {
        super(lobHandler, jtaTransactionManager);
    }

    /**
     * Creates a temporary file using the {@link #createTemporaryFile(java.io.File, java.sql.ResultSet, String[], Object)}
     * method and then writes the contents of the blob to the the temporary file.
     * @param resultSet a JDBC result set
     * @param columns the column names
     * @param owner the containing entity
     * @param lobHandler the LobHandler to use
     * @todo This class will run into problems in a threaded environment, two threads creating the same file...
     * @todo This could be a lot more efficent when writing the temporary file
     */
    @Override
    protected Object nullSafeGetInternal(ResultSet resultSet, String[] columns, Object owner, LobHandler lobHandler) throws SQLException,
            IOException, HibernateException {
        // we only handle one column, so panic if it isn't so
        if (columns == null || columns.length != 1)
            throw new HibernateException("Only one column name can be used for the " + getClass() + " user type");

        FileItem fileItem = FileManagerImpl.getInstance().createTemporaryFileItem();
        File file = fileItem.getFile();

        // write the contents of the file to disk
        BufferedInputStream inputStream = new BufferedInputStream(lobHandler.getBlobAsBinaryStream(resultSet, columns[0]));
        OutputStream outputStream = new BufferedOutputStream(new FileOutputStream(file));

        // we really should read and write more than one byte at a time...
        int foo = -1;
        while ((foo = inputStream.read()) != -1) {
            outputStream.write(foo);
        }
        outputStream.flush();
        outputStream.close();

        inputStream.close();

        return fileItem;
    }

    /**
     * Creates a buffered {@link FileInputStream} from the file provided as the value parameter.
     * @param statement the PreparedStatement to set on
     * @param index the statement parameter index
     * @param value the file
     * @param lobCreator the LobCreator to use
     * @throws SQLException if thrown by JDBC methods
     * @throws FileNotFoundException If the file specified by the value parameter could not be found
     * @throws HibernateException if the file is bigger than {@link Integer.MAX_VALUE}
     */
    @Override
    protected void nullSafeSetInternal(PreparedStatement statement, int index, Object value, LobCreator lobCreator) throws SQLException,
            HibernateException, FileNotFoundException {
        // check the file length, it can't be greater than Integer.MAX_VALUE because we are going to cast the length
        // down to an int alter
        File file = ((FileItem) value).getFile();
        if (file.length() >= Integer.MAX_VALUE)
            throw new HibernateException("File size exceeds " + Integer.MAX_VALUE + " in length.");

        BufferedInputStream inputStream = new BufferedInputStream(new FileInputStream(file));
        lobCreator.setBlobAsBinaryStream(statement, index, inputStream, (int) file.length());
    }

    public int[] sqlTypes() {
        return new int[] { Types.BLOB };
    }

    public Class returnedClass() {
        return FileItem.class;
    }

    @Override
    public boolean isMutable() {
        return true;
    }

}
