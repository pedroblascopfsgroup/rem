package es.pfsgroup.plugin.rem.servlet;

import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Usuario;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import java.io.*;
import java.util.Date;
import java.util.Properties;

/**
 * Esta clase sirve de punto de entrada para la gestión de adjuntos o asociados a un email.
 * <br>
 * Es un servlet con cierta lógica embebida.
 * <br><br>
 * Primero recibe la orden como método GET y comprueba que tenga los datos necesarios.
 * Si contiene el parámetro en la url del nombre del adjunto hace un traspase a la JSP de validar
 * credenciales del usuario.
 * El formulario de validación de credenciales vuelve a este servlet con una llamada de tipo POST
 * junto a los datos del formulario de validación de credenciales.
 * Se comprueba que las credenciales sean válidas y que el archivo exista. Si son correctas,
 * manda de vuelta como respuesta el archivo para ser descargado por el usuario que ha iniciado el
 * proceso.
 */
public class EmailAttachment extends HttpServlet {
	private static final String FILE_NAME_PARAMETER = "file";
	private static final String HOST_ENVIRONMENT_VAR_DEVON_DIRECTORY = "DEVON_HOME";
	private static final String FORM_USERNAME_NAME_PARAMETER = "username";
	private static final String FORM_PASSWORD_NAME_PARAMETER = "password";

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private UsuarioDao usuarioDao;

	private final Properties properties = new Properties();

	@Override
	@SuppressWarnings({"squid:S1075"})
	public void init(final ServletConfig config) throws ServletException {
		super.init(config);

		// Autowired
		final WebApplicationContext springContext = WebApplicationContextUtils.getRequiredWebApplicationContext(config.getServletContext());
		final AutowireCapableBeanFactory beanFactory = springContext.getAutowireCapableBeanFactory();
		beanFactory.autowireBean(this);

		// Resource
		String devonHome =  System.getProperty(HOST_ENVIRONMENT_VAR_DEVON_DIRECTORY);
		File devonPropertiesFile = new File(devonHome);
		InputStream inputStream = null;
		try {
			inputStream = new FileInputStream(devonPropertiesFile);
			this.properties.load(inputStream);

		} catch (IOException e) {
			logger.error("No ha sido posible obtener las properties del devon\n" + e.getMessage());
		} finally {
			if (inputStream != null) {
				try {
					inputStream.close();
				} catch (IOException e) {
					// Nothing
				}
			}
		}
	}

	/**
	 * Este método es disparado cuando se inicia el proceso de obtener un adjunto asociado como enlace en
	 * un correo.
	 *
	 * @param req  petición que llega al servlet.
	 * @param resp respuesta que da el servlet.
	 * @throws ServletException Excepción lanzada cuando el servlet tiene un mal funcionamiento.
	 * @throws IOException      Excepción lanzada cuando no es posible leer parámetros de los canales de entrada.
	 */
	@Override
	@SuppressWarnings({"squid:S1989"})
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// Si la ruta no lleva los parámetros correctos mandar a la dirección de la página informativa del error
		String fileName = req.getParameter("file");
		if (null == fileName || fileName.isEmpty()) {
			resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resp.sendRedirect("/pfs/js/plugin/rem/email-attachment/invalid-resource-url.jsp");
			return;
		}

		/// Envía la página de login sin mostrar en la url el cambio de espacio visual y mantiene los url params
		RequestDispatcher dispatcher = this.getServletContext().getRequestDispatcher("/js/plugin/rem/email-attachment/attachment-resource-login.jsp");
		dispatcher.forward(req, resp);
	}

	/**
	 * Este método es disparado cuando se devuelven las credenciales del usuario que intenta acceder al recurso
	 * del archivo adjunto para que sean validadas. Una vez validadas y aprobadas se devuelve el archivo adjunto
	 * para que sea descargado.
	 *
	 * @param req  petición que llega al servlet.
	 * @param resp respuesta que da el servlet.
	 * @throws IOException Excepción lanzada cuando no es posible leer parámetros de los canales de entrada.
	 */
	@Override
	@SuppressWarnings({"squid:S1989"})
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String fileName = req.getParameter(FILE_NAME_PARAMETER);
		String username = req.getParameter(FORM_USERNAME_NAME_PARAMETER);
		String password = req.getParameter(FORM_PASSWORD_NAME_PARAMETER);

		// Comprobar validez de las credenciales
		if (!this.isValidUser(username, password)) {
			resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			resp.sendRedirect("/pfs/js/plugin/rem/email-attachment/invalid-credentials.jsp");
			return;
		}

		// Obtener archivo por el nombre de archivo
		File srcFile = this.getFileByName(fileName);

		if (srcFile.exists()) {
			// Enviar archivo
			resp.setStatus(HttpServletResponse.SC_OK);
			resp.setContentType(MediaType.APPLICATION_OCTET_STREAM);
			resp.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + srcFile.getName() + "\"");
			resp.setContentLength((int) srcFile.length());
			InputStream fileInputStream = null;
			OutputStream outputStream = null;

			try {
				fileInputStream = new FileInputStream(srcFile);
				outputStream = resp.getOutputStream();
				byte[] buffer = new byte[1024];
				int numBytesRead;
				while ((numBytesRead = fileInputStream.read(buffer)) > 0) {
					outputStream.write(buffer, 0, numBytesRead);
				}
			} catch (Exception exception) {
				logger.error("Error al enviar para descarga el recurso de adjunto solicitado.\n" + exception.getMessage());
			} finally {
				if (fileInputStream != null) fileInputStream.close();
				if (outputStream != null) outputStream.close();
			}
		} else {
			// Indicar que el archivo no existe
			resp.setStatus(HttpServletResponse.SC_GONE);
			resp.sendRedirect("/pfs/js/plugin/rem/email-attachment/requested-resource-gone.jsp");
		}
	}

	/**
	 * Este método obtiene un archivo de la carpeta de recursos de adjuntos para el correo.
	 *
	 * @param fileName Nombre del recurso.
	 * @return Devuelve un objeto File con el recurso.
	 */
	private File getFileByName(String fileName) {
		String attachmentFolderRoute = this.properties.getProperty("email.attachment.folder.src", "/recovery/app-server/pfs/attachment");
		String fileCompleteRoute = attachmentFolderRoute + File.separator + fileName;

		return new File(fileCompleteRoute);
	}

	/**
	 * Este método obtiene una entidad en base a los datos obtenidos del usuario y comprueba ciertas medidas
	 * de seguridad para con el mismo.
	 *
	 * @param username 'username' único del usuario.
	 * @param password contraseña del usuario.
	 * @return Devuelve TRUE si el usuario obtenido es válido en cuanto a cuestiones de seguridad, FALSE de cualquier otro modo.
	 */
	private boolean isValidUser(String username, String password) {
		Usuario usuario = this.usuarioDao.getByUsername(username);

		return null != usuario && !usuario.getAuditoria().isBorrado() && usuario.getPassword().equals(password) && usuario.isEnabled() && !usuario.getFechaVigenciaPassword().before(new Date());
	}

}
